?php

/* $Id: MRP.php 7093 2015-01-22 20:15:40Z vvs2012 $*/

include('includes/session.inc');
$Title = _('Run MRP Calculation');
include('includes/header.inc');
if (isset($_POST['submit'])) {

	if (!isset($_POST['Leeway']) OR !is_numeric(filter_number_format($_POST['Leeway']))) {
		$_POST['Leeway'] = 0;
	}

	// MRP - Create levels table based on weberp_bom
	echo '<br />'  ._('Start time') . ': ' . date('h:i:s') . '<br />';
	echo '<br />' . _('Initialising tables .....') . '<br />';
	flush();
	$result = DB_query("DROP TABLE IF EXISTS weberp_tempbom");
	$result = DB_query("DROP TABLE IF EXISTS weberp_passbom");
	$result = DB_query("DROP TABLE IF EXISTS weberp_passbom2");
	$result = DB_query("DROP TABLE IF EXISTS weberp_bomlevels");
	$result = DB_query("DROP TABLE IF EXISTS weberp_levels");

	$sql = "CREATE TEMPORARY TABLE weberp_passbom (part char(20),
											sortpart text) DEFAULT CHARSET=utf8";
	$ErrMsg = _('The SQL to create passbom failed with the message');
	$result = DB_query($sql,$ErrMsg);

	$sql = "CREATE TEMPORARY TABLE weberp_tempbom (parent char(20),
											component char(20),
											sortpart text,
											level int) DEFAULT CHARSET=utf8";
	$result = DB_query($sql,_('Create of weberp_tempbom failed because'));
	// To create levels, first, find parts in weberp_bom that are top level assemblies.
	// Do this by doing a LEFT JOIN from weberp_bom to weberp_bom (as bom2), linking
	// weberp_bom.PARENT to bom2.COMPONENT and using WHERE bom2.COMPONENT IS NULL
	// Put those top level assemblies in weberp_passbom, use COMPONENT in weberp_passbom
	// to link to PARENT in weberp_bom to find next lower level and accumulate
	// those parts into weberp_tempbom

	prnMsg(_('Creating first level'),'info');
	flush();
	// This finds the top level
	$sql = "INSERT INTO weberp_passbom (part, sortpart)
					   SELECT weberp_bom.component AS part,
							  CONCAT(weberp_bom.parent,'%',weberp_bom.component) AS sortpart
							  FROM weberp_bom LEFT JOIN weberp_bom as bom2
							  ON weberp_bom.parent = bom2.component
					  WHERE bom2.component IS NULL";
	$result = DB_query($sql);

	$lctr = 2;
	// $lctr is the level counter
	$sql = "INSERT INTO weberp_tempbom (parent, component, sortpart, level)
			  SELECT weberp_bom.parent AS parent, weberp_bom.component AS component,
					 CONCAT(weberp_bom.parent,'%',weberp_bom.component) AS sortpart,
					 '". $lctr. "' as level
					 FROM weberp_bom LEFT JOIN weberp_bom as bom2 ON weberp_bom.parent = bom2.component
			  WHERE bom2.component IS NULL";
	$result = DB_query($sql);
	//echo "<br />sql is $sql<br />";
	// This while routine finds the other levels as long as $compctr - the
	// component counter - finds there are more components that are used as
	// assemblies at lower levels
	prnMsg(_('Creating other levels'),'info');
	flush();
	$compctr = 1;
	while ($compctr > 0) {
		$lctr++;
		$sql = "INSERT INTO weberp_tempbom (parent, component, sortpart, level)
		  SELECT weberp_bom.parent AS parent, weberp_bom.component AS component,
			 CONCAT(weberp_passbom.sortpart,'%',weberp_bom.component) AS sortpart,
			 '" .$lctr . "' as level
			 FROM weberp_bom,weberp_passbom WHERE weberp_bom.parent = weberp_passbom.part";
		$result = DB_query($sql);

		$result = DB_query("DROP TABLE IF EXISTS weberp_passbom2");
		$result = DB_query("ALTER TABLE weberp_passbom RENAME AS weberp_passbom2");
		$result = DB_query("DROP TABLE IF EXISTS weberp_passbom");

		$sql = "CREATE TEMPORARY TABLE weberp_passbom (part char(20),
												sortpart text) DEFAULT CHARSET=utf8";
		$result = DB_query($sql);

		$sql = "INSERT INTO weberp_passbom (part, sortpart)
				   SELECT weberp_bom.component AS part,
						  CONCAT(weberp_passbom2.sortpart,'%',weberp_bom.component) AS sortpart
						  FROM weberp_bom,weberp_passbom2
				   WHERE weberp_bom.parent = weberp_passbom2.part";
		$result = DB_query($sql);


		$sql = "SELECT COUNT(*) FROM weberp_bom
						INNER JOIN weberp_passbom ON weberp_bom.parent = weberp_passbom.part
						GROUP BY weberp_bom.parent";
		$result = DB_query($sql);

		$myrow = DB_fetch_row($result);
		$compctr = $myrow[0];

	} // End of while $compctr > 0

	prnMsg(_('Creating bomlevels table'),'info');
	flush();
	$sql = "CREATE TEMPORARY TABLE weberp_bomlevels (
									part char(20),
									level int) DEFAULT CHARSET=utf8";
	$result = DB_query($sql);

	// Read weberp_tempbom and split sortpart into separate parts. For each separate part, calculate level as
	// the sortpart level minus the position in the @parts array of the part. For example, the first
	// part in the array for a level 4 sortpart would be created as a level 3 in levels, the fourth
	// and last part in sortpart would have a level code of zero, meaning it has no components

	$sql = "SELECT * FROM weberp_tempbom";
	$result = DB_query($sql);
	while ($myrow=DB_fetch_array($result)) {
			$Parts = explode('%',$myrow['sortpart']);
			$Level = $myrow['level'];
			$ctr = 0;
			foreach ($Parts as $Part) {
			   $ctr++;
			   $newlevel = $Level - $ctr;
			   $sql = "INSERT INTO weberp_bomlevels (part, level) VALUES('" . $Part . "','" . $newlevel . "')";
			   $result2 = DB_query($sql);
			} // End of foreach
	}  //end of while loop

	prnMsg(_('Creating levels table'),'info');
	flush();
	// Create levels from bomlevels using the highest level number found for a part

	$sql = "CREATE TABLE weberp_levels (
							part char(20),
							level int,
							leadtime smallint(6) NOT NULL default '0',
							pansize double NOT NULL default '0',
							shrinkfactor double NOT NULL default '0',
							eoq double NOT NULL default '0') DEFAULT CHARSET=utf8";
	$result = DB_query($sql);
	$sql = "INSERT INTO weberp_levels (part,
							level,
							leadtime,
							pansize,
							shrinkfactor,
							eoq)
		   SELECT weberp_bomlevels.part,
				   MAX(weberp_bomlevels.level),
				   0,
				   pansize,
				   shrinkfactor,
				   weberp_stockmaster.eoq
			 FROM weberp_bomlevels
			   	 INNER JOIN weberp_stockmaster ON weberp_bomlevels.part = weberp_stockmaster.stockid
			 GROUP BY weberp_bomlevels.part,
					  pansize,
					  shrinkfactor,
					  weberp_stockmaster.eoq";
	$result = DB_query($sql);
	$sql = "ALTER TABLE weberp_levels ADD INDEX part(part)";
	$result = DB_query($sql);

	// Create levels records with level of zero for all parts in weberp_stockmaster that
	// are not in weberp_bom

	$sql = "INSERT INTO weberp_levels (part,
							level,
							leadtime,
							pansize,
							shrinkfactor,
							eoq)
			SELECT  weberp_stockmaster.stockid AS part,
					0,
					0,
					weberp_stockmaster.pansize,
					weberp_stockmaster.shrinkfactor,
					weberp_stockmaster.eoq
			FROM weberp_stockmaster
			LEFT JOIN weberp_levels ON weberp_stockmaster.stockid = weberp_levels.part
			WHERE weberp_levels.part IS NULL";
	$result = DB_query($sql);

	// Update leadtime in levels from weberp_purchdata. Do it twice so can make sure leadtime from preferred
	// vendor is used
	$sql = "UPDATE weberp_levels,weberp_purchdata
					SET weberp_levels.leadtime = weberp_purchdata.leadtime
					WHERE weberp_levels.part = weberp_purchdata.stockid
					AND weberp_purchdata.leadtime > 0";
	$result = DB_query($sql);
	$sql = "UPDATE weberp_levels,weberp_purchdata
						SET weberp_levels.leadtime = weberp_purchdata.leadtime
					WHERE weberp_levels.part = weberp_purchdata.stockid
					AND weberp_purchdata.preferred = 1
					AND weberp_purchdata.leadtime > 0";
	$result = DB_query($sql);

	prnMsg(_('Levels table has been created'),'info');
	flush();

	// Get rid if temporary tables
	$sql = "DROP TABLE IF EXISTS weberp_weberp_tempbom";
	//$result = DB_query($sql);
	$sql = "DROP TABLE IF EXISTS weberp_passbom";
	//$result = DB_query($sql);
	$sql = "DROP TABLE IF EXISTS weberp_passbom2";
	//$result = DB_query($sql);
	$sql = "DROP TABLE IF EXISTS weberp_bomlevels";
	//$result = DB_query($sql);

	// In the following section, create mrprequirements from open sales orders and
	// mrpdemands
	prnMsg(_('Creating requirements table'),'info');
	flush();
	$result = DB_query("DROP TABLE IF EXISTS weberp_mrprequirements");
	// directdemand is 1 if demand is directly for this part, is 0 if created because have netted
	// out supply and demands for a top level part and determined there is still a net
	// requirement left and have to pass that down to the BOM parts using the
	// CreateLowerLevelRequirement() function. Mostly do this so can distinguish the type
	// of requirements for the MRPShortageReport so don't show double requirements.
	$sql = "CREATE TABLE weberp_mrprequirements (	part char(20),
											daterequired date,
											quantity double,
											mrpdemandtype varchar(6),
											orderno int(11),
											directdemand smallint,
											whererequired char(20),
											KEY part (part)
															) DEFAULT CHARSET=utf8";
	$result = DB_query($sql,_('Create of mrprequirements failed because'));

	prnMsg(_('Loading requirements from sales orders'),'info');
	flush();
	$sql = "INSERT INTO weberp_mrprequirements	(part,
										 daterequired,
										 quantity,
										 mrpdemandtype,
										 orderno,
										 directdemand,
										 whererequired)
							   SELECT stkcode,
									  itemdue,
									  (quantity - qtyinvoiced) AS netqty,
									  'SO',
									  weberp_salesorderdetails.orderno,
									  '1',
									  stkcode
							  FROM weberp_salesorders INNER JOIN weberp_salesorderdetails
								ON weberp_salesorders.orderno = weberp_salesorderdetails.orderno
								INNER JOIN weberp_stockmaster
								ON weberp_stockmaster.stockid = weberp_salesorderdetails.stkcode
							  WHERE weberp_stockmaster.discontinued = 0
							  AND (quantity - qtyinvoiced) > 0
							  AND weberp_salesorderdetails.completed = 0
							  AND weberp_salesorders.quotation = 0";
	$result = DB_query($sql);

	prnMsg(_('Loading requirements from work orders'),'info');
	flush();
	// Definition of demand from SelectProduct.php
	$sql = "INSERT INTO weberp_mrprequirements	(part,
										 daterequired,
										 quantity,
										 mrpdemandtype,
										 orderno,
										 directdemand,
										 whererequired)
							   SELECT weberp_worequirements.stockid,
									weberp_workorders.requiredby,
									(qtypu*weberp_woitems.qtyreqd +
									SUM(CASE WHEN weberp_stockmoves.qty IS NOT NULL
										THEN weberp_stockmoves.qty
										ELSE 0
										END))						
									AS netqty,
									'WO',
									weberp_woitems.wo,
									'1',
									parentstockid
								FROM weberp_woitems
									INNER JOIN weberp_worequirements
										ON weberp_woitems.stockid=weberp_worequirements.parentstockid
									INNER JOIN weberp_workorders
									  ON weberp_woitems.wo=weberp_workorders.wo
									  AND weberp_woitems.wo=weberp_worequirements.wo
									  INNER JOIN weberp_stockmaster
										ON weberp_woitems.stockid = weberp_stockmaster.stockid
										LEFT JOIN weberp_stockmoves ON (weberp_stockmoves.stockid = weberp_worequirements.stockid AND weberp_stockmoves.reference=weberp_woitems.wo AND type=28)
								GROUP BY weberp_workorders.wo,weberp_worequirements.stockid,weberp_workorders.requiredby,weberp_woitems.qtyreqd,weberp_worequirements.qtypu,weberp_woitems.wo,weberp_worequirements.stockid,weberp_workorders.closed,weberp_stockmaster.discontinued,weberp_stockmoves.reference,weberp_workorders.closed
								HAVING weberp_workorders.closed=0
								AND weberp_stockmaster.discontinued = 0
								AND netqty > 0";
	$result = DB_query($sql);

	if ($_POST['UseMRPDemands'] == 'y') {
		$sql = "INSERT INTO weberp_mrprequirements	(part,
											 daterequired,
											 quantity,
											 mrpdemandtype,
											 orderno,
											 directdemand,
											 whererequired)
								   SELECT weberp_mrpdemands.stockid,
										  weberp_mrpdemands.duedate,
										  weberp_mrpdemands.quantity,
										  weberp_mrpdemands.mrpdemandtype,
										  weberp_mrpdemands.demandid,
										  '1',
										  weberp_mrpdemands.stockid
									 FROM weberp_mrpdemands, weberp_stockmaster
									 WHERE weberp_mrpdemands.stockid = weberp_stockmaster.stockid
										AND weberp_stockmaster.discontinued = 0";
		$result = DB_query($sql);
		prnMsg(_('Loading requirements based on mrpdemands'),'info');
		flush();
	}
	if ($_POST['UseRLDemands'] == 'y') {
		$sql = "INSERT INTO weberp_mrprequirements	(part,
											 daterequired,
											 quantity,
											 mrpdemandtype,
											 orderno,
											 directdemand,
											 whererequired)
								   SELECT weberp_locstock.stockid,
										  '" . date('Y-m-d') . "',
										  (weberp_locstock.reorderlevel - weberp_locstock.quantity) AS reordqty,
										  'REORD',
										  '1',
										  '1',
										  weberp_locstock.stockid
									 FROM weberp_locstock, weberp_stockmaster
									 WHERE weberp_stockmaster.stockid = weberp_locstock.stockid
										AND weberp_stockmaster.discontinued = 0
										AND reorderlevel - quantity > 0";
		$result = DB_query($sql);
		prnMsg(_('Loading requirements based on reorder level'),'info');
		flush();
	}

	// In the following section, create mrpsupplies from open purchase orders,
	// open work orders, and current quantity onhand from weberp_locstock
	prnMsg(_('Creating supplies table'),'info');
	flush();
	$result = DB_query("DROP TABLE IF EXISTS weberp_mrpsupplies");
	// updateflag is set to 1 in UpdateSupplies if change date when matching requirements to
	// supplies. Actually only change update flag in the array created from mrpsupplies
	$sql = "CREATE TABLE weberp_mrpsupplies (	id int(11) NOT NULL auto_increment,
										part char(20),
										duedate date,
										supplyquantity double,
										ordertype varchar(6),
										orderno int(11),
										mrpdate date,
										updateflag smallint(6),
										PRIMARY KEY (id)) DEFAULT CHARSET=utf8";
	$result = DB_query($sql,_('Create of mrpsupplies failed because'));

	prnMsg(_('Loading supplies from purchase orders'),'info');
	flush();
	$sql = "INSERT INTO weberp_mrpsupplies	(id,
									 part,
									 duedate,
									 supplyquantity,
									 ordertype,
									 orderno,
									 mrpdate,
									 updateflag)
						   SELECT Null,
								  weberp_purchorderdetails.itemcode,
								  weberp_purchorderdetails.deliverydate,
								  (quantityord - quantityrecd) AS netqty,
								  'PO',
								  weberp_purchorderdetails.orderno,
								  weberp_purchorderdetails.deliverydate,
								  0
							  FROM weberp_purchorderdetails,
								   weberp_purchorders
						  WHERE weberp_purchorderdetails.orderno = weberp_purchorders.orderno
							AND weberp_purchorders.status != 'Cancelled'
							AND weberp_purchorders.status != 'Rejected'
							AND weberp_purchorders.status != 'Completed'
							AND(quantityord - quantityrecd) > 0
							AND weberp_purchorderdetails.completed = 0";
	$result = DB_query($sql);

	prnMsg(_('Loading supplies from inventory on hand'),'info');
	flush();
	// Set date for inventory already onhand to 0000-00-00 so it is first in sort
	if ($_POST['location'][0] == 'All') {
		$WhereLocation = ' ';
	} elseif (sizeof($_POST['location']) == 1) {
		$WhereLocation = " AND loccode ='" . $_POST['location'][0] . "' ";
	} else {
		$WhereLocation = " AND loccode IN(";
		$commactr = 0;
		foreach ($_POST['location'] as $key => $value) {
			$WhereLocation .= "'" . $value . "'";
			$commactr++;
			if ($commactr < sizeof($_POST['location'])) {
				$WhereLocation .= ",";
			} // End of if
		} // End of foreach
		$WhereLocation .= ')';
	}
	$sql = "INSERT INTO weberp_mrpsupplies	(id,
									 part,
									 duedate,
									 supplyquantity,
									 ordertype,
									 orderno,
									 mrpdate,
									 updateflag)
						   SELECT Null,
								  stockid,
								  '0000-00-00',
								  SUM(quantity),
								  'QOH',
								  1,
								  '0000-00-00',
								  0
							  FROM weberp_locstock
							  WHERE quantity > 0 " .
							  $WhereLocation .
						  "GROUP BY stockid";
	$result = DB_query($sql);

	prnMsg(_('Loading supplies from work orders'),'info');
	flush();
	$sql = "INSERT INTO weberp_mrpsupplies	(id,
									 part,
									 duedate,
									 supplyquantity,
									 ordertype,
									 orderno,
									 mrpdate,
									 updateflag)
						   SELECT Null,
								  stockid,
								  weberp_workorders.requiredby,
								  (weberp_woitems.qtyreqd-weberp_woitems.qtyrecd) AS netqty,
								  'WO',
								  weberp_woitems.wo,
								  weberp_workorders.requiredby,
								  0
							  FROM weberp_woitems INNER JOIN weberp_workorders
								ON weberp_woitems.wo=weberp_workorders.wo
								WHERE weberp_workorders.closed=0
								AND (weberp_woitems.qtyreqd-weberp_woitems.qtyrecd) > 0";
	$result = DB_query($sql);

	$sql = "ALTER TABLE weberp_mrpsupplies ADD INDEX part(part)";
	$result = DB_query($sql);

	// Create weberp_mrpplannedorders table to create a record for any unmet requirments
	// In the following section, create mrpsupplies from open purchase orders,
	// open work orders, and current quantity onhand from weberp_locstock
	prnMsg(_('Creating planned orders table'),'info');
	flush();
	$result = DB_query("DROP TABLE IF EXISTS weberp_mrpplannedorders");
	$sql = "CREATE TABLE weberp_mrpplannedorders (id int(11) NOT NULL auto_increment,
											part char(20),
											duedate date,
											supplyquantity double,
											ordertype varchar(6),
											orderno int(11),
											mrpdate date,
											updateflag smallint(6),
											PRIMARY KEY (id)) DEFAULT CHARSET=utf8";
	$result = DB_query($sql,_('Create of weberp_mrpplannedorders failed because'));

	// Find the highest and lowest level number
	$sql = "SELECT MAX(level),MIN(level) from weberp_levels";
	$result = DB_query($sql);

	$myrow = DB_fetch_row($result);
	$MaxLevel = $myrow[0];
	$MinLevel = $myrow[1];

	// At this point, have all requirements in mrprequirements and all supplies to satisfy
	// those requirements in mrpsupplies.  Starting at the top level, will read all parts one
	// at a time, compare the requirements and supplies to see if have to re-schedule or create
	// planned orders to satisfy requirements. If there is a net requirement from a higher level
	// part, that serves as a gross requirement for a lower level part, so will read down through
	// the Bill of Materials to generate those requirements in function LevelNetting().
	for ($Level = $MaxLevel; $Level >= $MinLevel; $Level--) {
		$sql = "SELECT * FROM weberp_levels WHERE level = '" . $Level ."' LIMIT 50000"; //should cover most eventualities!! ... yes indeed :-)

		prnMsg('------ ' . _('Processing level') .' ' . $Level . ' ------','info');
		flush();
		$result = DB_query($sql);
		while ($myrow=DB_fetch_array($result)) {
			LevelNetting($db,$myrow['part'],$myrow['eoq'],$myrow['pansize'],$myrow['shrinkfactor'], $myrow['leadtime']);
		}  //end of while loop
	} // end of for
	echo '<br />' . _('End time') . ': ' . date('h:i:s') . '<br />';

	// Create mrpparameters table
	$sql = "DROP TABLE IF EXISTS weberp_mrpparameters";
	$result = DB_query($sql);
	$sql = "CREATE TABLE weberp_mrpparameters  (
						runtime datetime,
						location varchar(50),
						pansizeflag varchar(5),
						shrinkageflag varchar(5),
						eoqflag varchar(5),
						usemrpdemands varchar(5),
						userldemands varchar(5),
						leeway smallint) DEFAULT CHARSET=utf8";
	$result = DB_query($sql);
	// Create entry for location field from $_POST['location'], which is an array
	// since multiple locations can be selected
	$commactr = 0;
	$locparm='';
	foreach ($_POST['location'] as $key => $value) {
		$locparm .=  $value ;
		$commactr++;
		if ($commactr < sizeof($_POST['location'])) {
			$locparm .= " - ";
		} // End of if
	} // End of foreach
	$sql = "INSERT INTO weberp_mrpparameters (runtime,
									location,
									pansizeflag,
									shrinkageflag,
									eoqflag,
									usemrpdemands,
									userldemands,
									leeway)
									VALUES (CURRENT_TIMESTAMP,
								'" . $locparm . "',
								'" .  $_POST['PanSizeFlag']  . "',
								'" .  $_POST['ShrinkageFlag']  . "',
								'" .  $_POST['EOQFlag']  . "',
								'" .  $_POST['UseMRPDemands']  . "',
								'" .  $_POST['UseRLDemands']  . "',
								'" . filter_number_format($_POST['Leeway']) . "')";
	$result = DB_query($sql);

} else { // End of if submit isset
	// Display form if submit has not been hit
	echo '<p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/inventory.png" title="' .
			_('Inventory') . '" alt="" />' . ' ' . $Title . '</p>';

	// Display parameters from last run
	$sql = "SELECT * FROM weberp_mrpparameters";
	$result = DB_query($sql,'','',false,false);
	if (DB_error_no()==0){

		$myrow = DB_fetch_array($result);

		$Leeway = $myrow['leeway'];
		$UseMRPDemands = _('No');
		if ($myrow['usemrpdemands'] == 'y') {
			 $UseMRPDemands = _('Yes');
		}
		$UseRLDemands = _('No');
		if ($myrow['userldemands'] == 'y') {
			 $UseRLDemands = _('Yes');
		}
		$useeoq = _('No');
		if ($myrow['eoqflag'] == 'y') {
			 $useeoq = _('Yes');
		}
		$usepansize = _('No');
		if ($myrow['pansizeflag'] == 'y') {
			 $usepansize = _('Yes');
		}
		$useshrinkage = _('No');
		if ($myrow['shrinkageflag'] == 'y') {
			 $useshrinkage = _('Yes');
		}
		echo '<table class="selection">
				<tr>
					<th colspan="3"><h3>' . _('Last Run Details') . '</h3></th>
				</tr>
				<tr>
					<td>' . _('Last Run Time') . ':</td><td>' . $myrow['runtime'] . '</td>
				</tr>
				<tr>
					<td>' . _('Location') . ':</td>
					<td>' . $myrow['location'] . '</td>
				</tr>
				<tr>
					<td>' . _('Days Leeway') . ':</td>
					<td>' . $Leeway . '</td>
				</tr>
				<tr>
					<td>' . _('Use MRP Demands') . ':</td>
					<td>' . $UseMRPDemands . '</td>
				</tr>
				<tr>
					<td>' . _('Use Reorder Level Demands') . ':</td>
					<td>' . $UseRLDemands . '</td>
				</tr>
				<tr>
					<td>' . _('Use EOQ') . ':</td>
					<td>' . $useeoq . '</td>
				</tr>
				<tr>
					<td>' . _('Use Pan Size') . ':</td>
					<td>' . $usepansize . '</td>
				</tr>
				<tr>
					<td>' . _('Use Shrinkage') . ':</td>
					<td>' . $useshrinkage . '</td>
				</tr>
				</table>';
	}
	echo '<br /><form method="post" action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8')  . '">';
    echo '<div>';
	echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';
	echo '<table class="selection">
			<tr>
				<th colspan="3"><h3>' . _('This Run Details') . '</h3></th>
			</tr>
			<tr>
				<td>' . _('Location') . '</td>
				<td><select required="required" autofocus="autofocus" name="location[]" multiple="multiple">
					<option value="All" selected="selected">' . _('All') . '</option>';
	 $sql = "SELECT loccode,
				locationname
			   FROM weberp_locations";
	$Result = DB_query($sql);
	while ($myrow = DB_fetch_array($Result)) {
		echo '<option value="';
		echo $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
	} //end while loop
	echo '</select></td></tr>';
	if (!isset($Leeway)){
		$Leeway =0;
	}

	echo '<tr>
			<td>' . _('Days Leeway') . ':</td>
			<td><input type="text" required="required" name="Leeway" class="integer" size="4" value="' . $Leeway . '" /></td>
		</tr>
		<tr>
			<td>' ._('Use MRP Demands?') . ':</td>
			<td><input type="checkbox" name="UseMRPDemands" value="y" checked="checked" /></td>
		</tr>
		<tr>
			<td>' ._('Use Reorder Level Demands?') . ':</td>
			<td><input type="checkbox" name="UseRLDemands" value="y" checked="checked" /></td>
		</tr>
		<tr>
			<td>' ._('Use EOQ?') . ':</td>
			<td><input type="checkbox" name="EOQFlag" value="y" checked="checked" /></td>
		</tr>
		<tr>
			<td>' ._('Use Pan Size?') . ':</td>
			<td><input type="checkbox" name="PanSizeFlag" value="y" checked="checked" /></td>
		</tr>
		<tr>
			<td>' ._('Use Shrinkage?') . ':</td>
			<td><input type="checkbox" name="ShrinkageFlag" value="y" checked="checked" /></td>
		</tr>
		</table>
		<div class="centre">
			<br />
			<br />
			<input type="submit" name="submit" value="' . _('Run MRP') . '" />
		</div>
        </div>
		</form>';
}  // End of Main program logic -------------------------------------------------------



function LevelNetting(&$db,$Part,$eoq,$PanSize,$ShrinkFactor,$LeadTime) {
		// Create an array of mrprequirements and an array of mrpsupplies, then read through
		// them seeing if all requirements are covered by supplies. Create a planned order
		// for any unmet requirements. Change dates if necessary for the supplies.
		//echo '<br />Part is ' . "$Part" . '<br />';

		// Get decimal places from weberp_stockmaster for rounding of shrinkage factor
	$sql = "SELECT decimalplaces FROM weberp_stockmaster WHERE stockid = '" . $Part . "'";
	$result = DB_query($sql);
	$myrow=DB_fetch_row($result);
	$DecimalPlaces = $myrow[0];

	// Load mrprequirements into $Requirements array
	$sql = "SELECT * FROM weberp_mrprequirements WHERE part = '" .$Part. "' ORDER BY daterequired";
	$result = DB_query($sql);
	$Requirements = array();
	$i = 0;
	while ($myrow=DB_fetch_array($result)) {
			array_push($Requirements,$myrow);
			$i++;
	}  //end of while loop

	// Load mrpsupplies into $Supplies array
	$sql = "SELECT * FROM weberp_mrpsupplies WHERE part = '" . $Part. "' ORDER BY duedate";
	$result = DB_query($sql);
	$Supplies = array();
	$i = 0;
	while ($myrow=DB_fetch_array($result)) {
			array_push($Supplies,$myrow);
			$i++;
	}  //end of while loop
	// Go through all requirements and check if have supplies to cover them
	$RequirementCount = count($Requirements);
	$SupplyCount = count($Supplies);
	$reqi = 0; //Index for requirements
	$supi = 0; // index for supplies
	$TotalRequirement = 0;
	$TotalSupply = 0;

	if ($RequirementCount > 0 && $SupplyCount > 0) {
			$TotalRequirement += $Requirements[$reqi]['quantity'];
			$TotalSupply += $Supplies[$supi]['supplyquantity'];
		while ($TotalRequirement > 0 && $TotalSupply > 0) {
			$Supplies[$supi]['updateflag'] = 1;
			// ******** Put leeway calculation in here ********
			$DueDate = ConvertSQLDate($Supplies[$supi]['duedate']);
			$ReqDate = ConvertSQLDate($Requirements[$reqi]['daterequired']);
			$DateDiff = DateDiff($DueDate,$ReqDate,'d');
			if ($DateDiff > abs(filter_number_format($_POST['Leeway']))) {
				$sql = "UPDATE weberp_mrpsupplies SET mrpdate = '" . $Requirements[$reqi]['daterequired'] .
				   "' WHERE id = '" . $Supplies[$supi]['id'] . "' AND duedate = mrpdate";
				$result = DB_query($sql);
			}
			if ($TotalRequirement > $TotalSupply) {
				$TotalRequirement -= $TotalSupply;
				$Requirements[$reqi]['quantity'] -= $TotalSupply;
				$TotalSupply = 0;
				$Supplies[$supi]['supplyquantity'] = 0;
				$supi++;
				if ($SupplyCount > $supi) {
					$TotalSupply += $Supplies[$supi]['supplyquantity'];
				}
			} elseif ($TotalRequirement < $TotalSupply) {
				$TotalSupply -= $TotalRequirement;
				$Supplies[$supi]['supplyquantity'] -= $TotalRequirement;
				$TotalRequirement = 0;
				$Requirements[$reqi]['quantity'] = 0;
				$reqi++;
				if ($RequirementCount > $reqi) {
					$TotalRequirement += $Requirements[$reqi]['quantity'];
				}
			} else {
				$TotalSupply -= $TotalRequirement;
				$Supplies[$supi]['supplyquantity'] -= $TotalRequirement;
				$TotalRequirement = 0;
				$Requirements[$reqi]['quantity'] = 0;
				$reqi++;
				if ($RequirementCount > $reqi) {
					$TotalRequirement += $Requirements[$reqi]['quantity'];
				}
				$TotalRequirement -= $TotalSupply;
				if(isset($Requirements[$reqi]['quantity'])){
					$Requirements[$reqi]['quantity'] -= $TotalSupply;
				}
				$TotalSupply = 0;
				$Supplies[$supi]['supplyquantity'] = 0;
				$supi++;
				if ($SupplyCount > $supi) {
					$TotalSupply += $Supplies[$supi]['supplyquantity'];
				}
			} 
		} // End of while
	} // End of if

	// When get to this part of code, have gone through all requirements, If there is any
	// unmet requirements, create an mrpplannedorder to cover it. Also call the
	// CreateLowerLevelRequirement() function to create gross requirements for lower level parts.

	// There is an excess quantity if the eoq is higher than the actual required amount.
	// If there is a subsuquent requirement, the excess quantity is subtracted from that
	// quantity. For instance, if the first requirement was for 2 and the eoq was 5, there
	// would be an excess of 3; if there was another requirement for 3 or less, the excess
	// would cover it, so no planned order would have to be created for the second requirement.
	$ExcessQty = 0;
	foreach ($Requirements as $key => $row) {
		 $DateRequired[$key] = $row['daterequired'];
	}
	if (count($Requirements)) {
		array_multisort($DateRequired, SORT_ASC, $Requirements);
	}
	foreach($Requirements as $Requirement) {
		// First, inflate requirement if there is a shrinkage factor
		// Should the quantity be rounded?
		if ($_POST['ShrinkageFlag'] == 'y' AND $ShrinkFactor > 0) {
			$Requirement['quantity'] = ($Requirement['quantity'] * 100) / (100 - $ShrinkFactor);
			$Requirement['quantity'] = round($Requirement['quantity'],$DecimalPlaces);
		}
		if ($ExcessQty >= $Requirement['quantity']) {
			$PlannedQty = 0;
			$ExcessQty -= $Requirement['quantity'];
		} else {
			$PlannedQty = $Requirement['quantity'] - $ExcessQty;
			$ExcessQty = 0;
		}
		if ($PlannedQty > 0) {
			if ($_POST['EOQFlag'] == 'y' AND $eoq > $PlannedQty) {
				$ExcessQty = $eoq - $PlannedQty;
				$PlannedQty = $eoq;
			}
			// Pansize calculation here
			// if $PlannedQty not evenly divisible by $PanSize, calculate as $PlannedQty
			// divided by $PanSize and rounded up to the next highest integer and then
			// multiplied by the pansize. For instance, with a planned qty of 17 with a pansize
			// of 5, divide 17 by 5 to get 3 with a remainder of 2, which is rounded up to 4
			// and then multiplied by 5 - the pansize - to get 20
			if ($_POST['PanSizeFlag'] == 'y' AND $PanSize != 0 AND $PlannedQty != 0) {
				$PlannedQty = ceil($PlannedQty / $PanSize) * $PanSize;
			}

			// Calculate required date by subtracting leadtime from top part's required date
		$PartRequiredDate = $Requirement['daterequired'];
			if ((int)$LeadTime>0) {

				$CalendarSQL = "SELECT COUNT(*),cal2.calendardate
						  FROM weberp_mrpcalendar
							LEFT JOIN weberp_mrpcalendar as cal2
							  ON (weberp_mrpcalendar.daynumber - '".$LeadTime."') = cal2.daynumber
						  WHERE weberp_mrpcalendar.calendardate = '".$PartRequiredDate."'
							AND cal2.manufacturingflag='1'
							GROUP BY cal2.calendardate";
				$ResultDate = DB_query($CalendarSQL);
				$myrowdate = DB_fetch_array($ResultDate);
				if($myrowdate[0]>0){
					$NewDate = $myrowdate[1];
				} else {//No calendar date available, so use $PartRequiredDate
						$ConvertDate = ConvertSQLDate($PartRequiredDate);
						$DateAdd = DateAdd($ConvertDate,'d',($LeadTime * -1));
						$NewDate = FormatDateForSQL($DateAdd);
				}
				// If can't find date based on manufacturing calendar, use $PartRequiredDate
			}  else {
				// Convert $PartRequiredDate from mysql format to system date format, use that to subtract leadtime
				// from it using DateAdd, convert that date back to mysql format
				$ConvertDate = ConvertSQLDate($PartRequiredDate);
				$DateAdd = DateAdd($ConvertDate,'d',($LeadTime * -1));
				$NewDate = FormatDateForSQL($DateAdd);
		}

		$sql = "INSERT INTO weberp_mrpplannedorders (id,
												part,
												duedate,
												supplyquantity,
												ordertype,
												orderno,
												mrpdate,
												updateflag)
											VALUES (NULL,
												'" . $Requirement['part'] . "',
												'" . $NewDate . "',
												'" . $PlannedQty  . "',
												'" . $Requirement['mrpdemandtype']  . "',
												'" . $Requirement['orderno']  . "',
												'" . $NewDate . "',
												'0')";


			$result = DB_query($sql);
			// If part has lower level components, create requirements for them
			$sql = "SELECT COUNT(*) FROM weberp_bom
					  WHERE parent ='" . $Requirement['part'] . "'
					  GROUP BY parent";
			$result = DB_query($sql);
			$myrow = DB_fetch_row($result);
			if ($myrow[0] > 0) {
				CreateLowerLevelRequirement($db,$Requirement['part'],$NewDate,
				  $PlannedQty,$Requirement['mrpdemandtype'],$Requirement['orderno'],
				  $Requirement['whererequired']);
			}
		} // End of if $PlannedQty > 0
	} // End of foreach $Requirements

   // If there are any supplies not used and updateflag is zero, those supplies are not
	// necessary, so change date

	foreach($Supplies as $supply) {
		if ($supply['supplyquantity'] > 0  && $supply['updateflag'] == 0) {
			$id = $supply['id'];
			$sql = "UPDATE weberp_mrpsupplies SET mrpdate ='2050-12-31' WHERE id = '".$id."'
					  AND ordertype <> 'QOH'";
			$result = DB_query($sql);
		}
	}

} // End of LevelNetting -------------------------------------------------------

function CreateLowerLevelRequirement(&$db,
									$TopPart,
									$TopDate,
									$TopQuantity,
									$TopMRPDemandType,
									$TopOrderNo,
									$WhereRequired) {
// Creates an mrprequirement based on the net requirement from the part above it in the weberp_bom
	$sql = "SELECT weberp_bom.component,
				   weberp_bom.quantity,
				   weberp_levels.leadtime,
				   weberp_levels.eoq
			FROM weberp_bom
				 LEFT JOIN weberp_levels
				   ON weberp_bom.component = weberp_levels.part
			WHERE weberp_bom.parent = '".$TopPart."'
            AND weberp_bom.effectiveafter <= '" . date('Y-m-d') . "'
            AND weberp_bom.effectiveto > '" . date('Y-m-d') . "'";
	$ResultBOM = DB_query($sql);
	while ($myrow=DB_fetch_array($ResultBOM)) {
		// Calculate required date by subtracting leadtime from top part's required date
		$LeadTime = $myrow['leadtime'];
		$Component = $myrow['component'];
		$ExtendedQuantity = $myrow['quantity'] * $TopQuantity;
// Commented out the following lines 8/15/09 because the eoq should be considered in the
// LevelNetting() function where $ExcessQty is calculated
//		 if ($myrow['eoq'] > $ExtendedQuantity) {
//			 $ExtendedQuantity = $myrow['eoq'];
//		 }
		$sql = "INSERT INTO weberp_mrprequirements (part,
											 daterequired,
											 quantity,
											 mrpdemandtype,
											 orderno,
											 directdemand,
											 whererequired)
			   VALUES ('".$Component."',
					  '".$TopDate."',
					  '".$ExtendedQuantity."',
					  '".$TopMRPDemandType."',
					  '".$TopOrderNo."',
					  '0',
					  '".$WhereRequired."')";
		$result = DB_query($sql);
	}  //end of while loop

}  // End of CreateLowerLevelRequirement

include('includes/footer.inc');
?>
