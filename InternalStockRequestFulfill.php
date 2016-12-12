<?php

/* $Id: InternalStockRequestFulfill.php  $*/

include('includes/session.inc');

$Title = _('Fulfill Stock Requests');
$ViewTopic = 'Inventory';
$BookMark = 'FulfilRequest';

include('includes/header.inc');
include('includes/SQL_CommonFunctions.inc');

echo '<p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/inventory.png" title="' . _('Contract') . '" alt="" />' . _('Fulfill Stock Requests') . '</p>';

if (isset($_POST['UpdateAll'])) {
	foreach ($_POST as $key => $value) {
		if (mb_strpos($key,'Qty')) {
			$RequestID = mb_substr($key,0, mb_strpos($key,'Qty'));
			$LineID = mb_substr($key,mb_strpos($key,'Qty')+3);
			$Quantity = filter_number_format($_POST[$RequestID.'Qty'.$LineID]);
			$StockID = $_POST[$RequestID.'StockID'.$LineID];
			$Location = $_POST[$RequestID.'Location'.$LineID];
			$Department = $_POST[$RequestID.'Department'.$LineID];
			$Tag = $_POST[$RequestID.'Tag'.$LineID];
			$RequestedQuantity = filter_number_format($_POST[$RequestID.'RequestedQuantity'.$LineID]);
			if (isset($_POST[$RequestID.'Completed'.$LineID])) {
				$Completed=True;
			} else {
				$Completed=False;
			}

			$sql="SELECT materialcost, labourcost, overheadcost, decimalplaces FROM weberp_stockmaster WHERE stockid='".$StockID."'";
			$result=DB_query($sql);
			$myrow=DB_fetch_array($result);
			$StandardCost=$myrow['materialcost']+$myrow['labourcost']+$myrow['overheadcost'];
			$DecimalPlaces = $myrow['decimalplaces'];

			$Narrative = _('Issue') . ' ' . $Quantity . ' ' . _('of') . ' '. $StockID . ' ' . _('to department') . ' ' . $Department . ' ' . _('from') . ' ' . $Location ;

			$AdjustmentNumber = GetNextTransNo(17,$db);
			$PeriodNo = GetPeriod (Date($_SESSION['DefaultDateFormat']), $db);
			$SQLAdjustmentDate = FormatDateForSQL(Date($_SESSION['DefaultDateFormat']));

			$Result = DB_Txn_Begin();

			// Need to get the current location quantity will need it later for the stock movement
			$SQL="SELECT weberp_locstock.quantity
					FROM weberp_locstock
					WHERE weberp_locstock.stockid='" . $StockID . "'
						AND loccode= '" . $Location . "'";
			$Result = DB_query($SQL);
			if (DB_num_rows($Result)==1){
				$LocQtyRow = DB_fetch_row($Result);
				$QtyOnHandPrior = $LocQtyRow[0];
			} else {
				// There must actually be some error this should never happen
				$QtyOnHandPrior = 0;
			}

			if ($_SESSION['ProhibitNegativeStock']==0 OR ($_SESSION['ProhibitNegativeStock']==1 AND $QtyOnHandPrior >= $Quantity)) {

				$SQL = "INSERT INTO weberp_stockmoves (
									stockid,
									type,
									transno,
									loccode,
									trandate,
									userid,
									prd,
									reference,
									qty,
									newqoh)
								VALUES (
									'" . $StockID . "',
									17,
									'" . $AdjustmentNumber . "',
									'" . $Location . "',
									'" . $SQLAdjustmentDate . "',
									'" . $_SESSION['UserID'] . "',
									'" . $PeriodNo . "',
									'" . $Narrative ."',
									'" . -$Quantity . "',
									'" . ($QtyOnHandPrior - $Quantity) . "'
								)";


				$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The stock movement record cannot be inserted because');
				$DbgMsg =  _('The following SQL to insert the stock movement record was used');
				$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);


				/*Get the ID of the StockMove... */
				$StkMoveNo = DB_Last_Insert_ID($db,'weberp_stockmoves','stkmoveno');

				$SQL="UPDATE weberp_stockrequestitems
						SET qtydelivered=qtydelivered+" . $Quantity . "
						WHERE dispatchid='" . $RequestID . "'
							AND dispatchitemsid='" . $LineID . "'";

				$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' ._('The location stock record could not be updated because');
				$DbgMsg = _('The following SQL to update the stock record was used');
				$Result = DB_query($SQL, $ErrMsg, $DbgMsg,true);

				$SQL = "UPDATE weberp_locstock SET quantity = quantity - '" . $Quantity . "'
									WHERE stockid='" . $StockID . "'
										AND loccode='" . $Location . "'";

				$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' ._('The location stock record could not be updated because');
				$DbgMsg = _('The following SQL to update the stock record was used');

				$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);

				if ($_SESSION['CompanyRecord']['gllink_stock']==1 AND $StandardCost > 0){

					$StockGLCodes = GetStockGLCode($StockID,$db);

					$SQL = "INSERT INTO weberp_gltrans (type,
												typeno,
												trandate,
												periodno,
												account,
												amount,
												narrative,
												tag)
											VALUES (17,
												'"  .$AdjustmentNumber . "',
												'" . $SQLAdjustmentDate . "',
												'" . $PeriodNo . "',
												'" . $StockGLCodes['issueglact'] . "',
												'" . $StandardCost * ($Quantity) . "',
												'" . $Narrative . "',
												'" . $Tag . "'
											)";

					$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The general ledger transaction entries could not be added because');
					$DbgMsg = _('The following SQL to insert the GL entries was used');
					$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);

					$SQL = "INSERT INTO weberp_gltrans (type,
												typeno,
												trandate,
												periodno,
												account,
												amount,
												narrative,
												tag)
											VALUES (17,
												'" . $AdjustmentNumber . "',
												'" . $SQLAdjustmentDate . "',
												'" . $PeriodNo . "',
												'" . $StockGLCodes['stockact'] . "',
												'" . $StandardCost * -$Quantity . "',
												'" . $Narrative . "',
												'" . $Tag . "'
											)";

					$Errmsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The general ledger transaction entries could not be added because');
					$DbgMsg = _('The following SQL to insert the GL entries was used');
					$Result = DB_query($SQL, $ErrMsg, $DbgMsg,true);
				}

				if (($Quantity >= $RequestedQuantity) OR $Completed==True) {
					$SQL="UPDATE weberp_stockrequestitems
								SET completed=1
							WHERE dispatchid='".$RequestID."'
								AND dispatchitemsid='".$LineID."'";
					$Result = DB_query($SQL, $ErrMsg, $DbgMsg,true);
				}

				$Result = DB_Txn_Commit();

				$ConfirmationText = _('An internal stock request for'). ' ' . $StockID . ' ' . _('has been fulfilled from location').' ' . $Location .' '. _('for a quantity of') . ' ' . locale_number_format($Quantity, $DecimalPlaces ) ;
				prnMsg( $ConfirmationText,'success');

				if ($_SESSION['InventoryManagerEmail']!=''){
					$ConfirmationText = $ConfirmationText . ' ' . _('by user') . ' ' . $_SESSION['UserID'] . ' ' . _('at') . ' ' . Date('Y-m-d H:i:s');
					$EmailSubject = _('Internal Stock Request Fulfillment for'). ' ' . $StockID;
					if($_SESSION['SmtpSetting']==0){
						      mail($_SESSION['InventoryManagerEmail'],$EmailSubject,$ConfirmationText);
					}else{
						include('includes/htmlMimeMail.php');
						$mail = new htmlMimeMail();
						$mail->setSubject($EmailSubject);
						$mail->setText($ConfirmationText);
						$result = SendmailBySmtp($mail,array($_SESSION['InventoryManagerEmail']));
					}

				
				}
			} else {
				$ConfirmationText = _('An internal stock request for'). ' ' . $StockID . ' ' . _('has been fulfilled from location').' ' . $Location .' '. _('for a quantity of') . ' ' . locale_number_format($Quantity, $DecimalPlaces) . ' ' . _('cannot be created as there is insufficient stock and your system is configured to not allow negative stocks');
				prnMsg( $ConfirmationText,'warn');
			}

			// Check if request can be closed and close if done.
			if (isset($RequestID)) {
				$SQL="SELECT dispatchid
						FROM weberp_stockrequestitems
						WHERE dispatchid='".$RequestID."'
							AND completed=0";
				$Result=DB_query($SQL);
				if (DB_num_rows($Result)==0) {
					$SQL="UPDATE weberp_stockrequest
						SET closed=1
					WHERE dispatchid='".$RequestID."'";
					$Result=DB_query($SQL);
				}
			}
		}
	}
}

if (!isset($_POST['Location'])) {
	echo '<form method="post" action="' . htmlspecialchars($_SERVER['PHP_SELF'], ENT_QUOTES, 'UTF-8') . '">';
    echo '<div>';
	echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';
	echo '<table class="selection">
			<tr>
				<td>' . _('Choose a location to issue requests from') . '</td>
				<td><select name="Location">';
	$sql = "SELECT weberp_locations.loccode, locationname
			FROM weberp_locations
			INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locations.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canupd=1
			WHERE internalrequest = 1
			ORDER BY locationname";
	$resultStkLocs = DB_query($sql);
	while ($myrow=DB_fetch_array($resultStkLocs)){
		if (isset($_SESSION['Adjustment']->StockLocation)){
			if ($myrow['loccode'] == $_SESSION['Adjustment']->StockLocation){
				echo '<option selected="selected" value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
			} else {
				echo '<option value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
			}
		} elseif ($myrow['loccode']==$_SESSION['UserStockLocation']){
			echo '<option selected="selected" value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
			$_POST['StockLocation']=$myrow['loccode'];
		} else {
		 echo '<option value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
		}
	}
	echo '</select></td></tr>';
	echo '</table><br />';
	echo '<div class="centre"><input type="submit" name="EnterAdjustment" value="'. _('Show Requests'). '" /></div>';
    echo '</div>
          </form>';
	include('includes/footer.inc');
	exit;
}

/* Retrieve the requisition header information
 */
if (isset($_POST['Location'])) {
	$sql="SELECT weberp_stockrequest.dispatchid,
			weberp_locations.locationname,
			weberp_stockrequest.despatchdate,
			weberp_stockrequest.narrative,
			weberp_departments.description,
			weberp_www_users.realname,
			weberp_www_users.email
		FROM weberp_stockrequest
		LEFT JOIN weberp_departments
			ON weberp_stockrequest.departmentid=weberp_departments.departmentid
		LEFT JOIN weberp_locations
			ON weberp_stockrequest.loccode=weberp_locations.loccode
		LEFT JOIN weberp_www_users
			ON weberp_www_users.userid=weberp_departments.authoriser
	WHERE weberp_stockrequest.authorised=1
		AND weberp_stockrequest.closed=0
		AND weberp_stockrequest.loccode='".$_POST['Location']."'";
	$result=DB_query($sql);

	if (DB_num_rows($result)==0) {
		prnMsg( _('There are no outstanding authorised requests for this location'), 'info');
		echo '<br />';
		echo '<div class="centre"><a href="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '">' . _('Select another location') . '</a></div>';
		include('includes/footer.inc');
		exit;
	}

	echo '<form method="post" action="' . htmlspecialchars($_SERVER['PHP_SELF'], ENT_QUOTES, 'UTF-8') . '">';
    echo '<div>';
	echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';
	echo '<table class="selection">
			<tr>
				<th>' . _('Request Number') . '</th>
				<th>' . _('Department') . '</th>
				<th>' . _('Location Of Stock') . '</th>
				<th>' . _('Requested Date') . '</th>
				<th>' . _('Narrative') . '</th>
			</tr>';

	while ($myrow=DB_fetch_array($result)) {

		echo '<tr>
				<td>' . $myrow['dispatchid'] . '</td>
				<td>' . $myrow['description'] . '</td>
				<td>' . $myrow['locationname'] . '</td>
				<td>' . ConvertSQLDate($myrow['despatchdate']) . '</td>
				<td>' . $myrow['narrative'] . '</td>
			</tr>';
		$LineSQL="SELECT weberp_stockrequestitems.dispatchitemsid,
						weberp_stockrequestitems.dispatchid,
						weberp_stockrequestitems.stockid,
						weberp_stockrequestitems.decimalplaces,
						weberp_stockrequestitems.uom,
						weberp_stockmaster.description,
						weberp_stockrequestitems.quantity,
						weberp_stockrequestitems.qtydelivered
				FROM weberp_stockrequestitems
				LEFT JOIN weberp_stockmaster
				ON weberp_stockmaster.stockid=weberp_stockrequestitems.stockid
			WHERE dispatchid='".$myrow['dispatchid'] . "'
				AND completed=0";
		$LineResult=DB_query($LineSQL);

		echo '<tr>
				<td></td>
				<td colspan="5" align="left">
					<table class="selection" align="left">
					<tr>
						<th>' . _('Product') . '</th>
						<th>' . _('Quantity') . '<br />' . _('Required') . '</th>
						<th>' . _('Quantity') . '<br />' . _('Delivered') . '</th>
						<th>' . _('Units') . '</th>
						<th>' . _('Completed') . '</th>
						<th>' . _('Tag') . '</th>
					</tr>';

		while ($LineRow=DB_fetch_array($LineResult)) {
			echo '<tr>
					<td>' . $LineRow['description'] . '</td>
					<td class="number">' . locale_number_format($LineRow['quantity']-$LineRow['qtydelivered'],$LineRow['decimalplaces']) . '</td>
					<td class="number"><input type="text" class="number" name="'. $LineRow['dispatchid'] . 'Qty'. $LineRow['dispatchitemsid'] . '" value="'.locale_number_format($LineRow['quantity']-$LineRow['qtydelivered'],$LineRow['decimalplaces']).'" /></td>
					<td>' . $LineRow['uom'] . '</td>
					<td><input type="checkbox" name="'. $LineRow['dispatchid'] . 'Completed'. $LineRow['dispatchitemsid'] . '" /></td>
					<td><select name="'. $LineRow['dispatchid'] . 'Tag'. $LineRow['dispatchitemsid'] . '">';

			$SQL = "SELECT tagref,
							tagdescription
						FROM weberp_tags
						ORDER BY tagref";

			$TagResult=DB_query($SQL);
			echo '<option value=0>0 - None</option>';
			while ($mytagrow=DB_fetch_array($TagResult)){
				if (isset($_SESSION['Adjustment']->tag) and $_SESSION['Adjustment']->tag==$mytagrow['tagref']){
					echo '<option selected="selected" value="' . $mytagrow['tagref'] . '">' . $mytagrow['tagref'].' - ' .$myrow['tagdescription'] . '</option>';
				} else {
					echo '<option value="' . $mytagrow['tagref'] . '">' . $mytagrow['tagref'].' - ' .$mytagrow['tagdescription'] . '</option>';
				}
			}
			echo '</select></td>';
// End select tag
			echo '</tr>';
			echo '<input type="hidden" class="number" name="'. $LineRow['dispatchid'] . 'StockID'. $LineRow['dispatchitemsid'] . '" value="'.$LineRow['stockid'].'" />';
			echo '<input type="hidden" class="number" name="'. $LineRow['dispatchid'] . 'Location'. $LineRow['dispatchitemsid'] . '" value="'.$_POST['Location'].'" />';
			echo '<input type="hidden" class="number" name="'. $LineRow['dispatchid'] . 'RequestedQuantity'. $LineRow['dispatchitemsid'] . '" value="'.locale_number_format($LineRow['quantity']-$LineRow['qtydelivered'],$LineRow['decimalplaces']).'" />';
			echo '<input type="hidden" class="number" name="'. $LineRow['dispatchid'] . 'Department'. $LineRow['dispatchitemsid'] . '" value="'.$myrow['description'].'" />';
		} // end while order line detail
		echo '</table></td></tr>';
	} //end while header loop
	echo '</table>';
	echo '<br /><div class="centre"><input type="submit" name="UpdateAll" value="' . _('Update'). '" /></div>
          </div>
          </form>';
}

include('includes/footer.inc');

?>
