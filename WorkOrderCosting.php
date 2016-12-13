<?php
/* $Id: WorkOrderCosting.php 7576 2016-07-27 10:10:03Z exsonqu $*/

include('includes/session.inc');
$Title = _('Work Order Costing');
include('includes/header.inc');
include('includes/SQL_CommonFunctions.inc');


if (isset($_GET['WO'])) {
	$SelectedWO = $_GET['WO'];
} elseif (isset($_POST['WO'])){
	$SelectedWO = $_POST['WO'];
} else {
	unset($SelectedWO);
}

echo '<a href="'. $RootPath . '/SelectWorkOrder.php">' . _('Back to Work Orders'). '</a>
	<br />
	<p class="page_title_text">
		<img src="'.$RootPath.'/css/'.$Theme.'/images/maintenance.png" title="' .
	_('Search') . '" alt="" />' . ' ' . $Title . '
	</p>';

echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '" method="post">';
echo '<div>';
echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';

if (!isset($SelectedWO)) {
	/* This page can only be called with a work order number */
	echo '<div class="centre><a href="' . $RootPath . '/SelectWorkOrder.php">' .
		_('Select a work order') . '</a></div>';
	prnMsg(_('This page can only be opened if a work order has been selected.'),'info');
	include ('includes/footer.inc');
	exit;
} else {
	echo '<input type="hidden" name="WO" value="' .$SelectedWO . '" />';
	$_POST['WO']=$SelectedWO;
}


$ErrMsg = _('Could not retrieve the details of the selected work order');
$WOResult = DB_query("SELECT weberp_workorders.loccode,
							weberp_locations.locationname,
							weberp_workorders.requiredby,
							weberp_workorders.startdate,
							weberp_workorders.closed,
							closecomments
						FROM weberp_workorders INNER JOIN weberp_locations
						ON weberp_workorders.loccode=weberp_locations.loccode
						INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locations.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canupd=1
						WHERE weberp_workorders.wo='" . $_POST['WO'] . "'",
						$ErrMsg);

if (DB_num_rows($WOResult)==0){
	prnMsg(_('The selected work order item cannot be retrieved from the database'),'info');
	include('includes/footer.inc');
	exit;
}
$WorkOrderRow = DB_fetch_array($WOResult);


echo '<table class="selection">
	<tr>
		<td class="label">' . _('Work order') . ':</td>
		<td>' . $_POST['WO']  . '</td>
	 	<td class="label">' . _('Manufactured at') . ':</td>
		<td>' . $WorkOrderRow['locationname'] . '</td>
		<td class="label">' . _('Required By') . ':</td>
		<td>' . ConvertSQLDate($WorkOrderRow['requiredby']) . '</td>
	</tr>
	</table>
	<br />';


$WOItemsResult = DB_query("SELECT weberp_woitems.stockid,
									weberp_stockmaster.description,
									weberp_stockmaster.decimalplaces,
									weberp_stockmaster.units,
									weberp_stockmaster.materialcost+weberp_stockmaster.labourcost+weberp_stockmaster.overheadcost AS currcost,
									weberp_woitems.qtyreqd,
									weberp_woitems.qtyrecd,
									weberp_woitems.stdcost,
									weberp_stockcategory.materialuseagevarac,
									weberp_stockcategory.purchpricevaract,
									weberp_stockcategory.wipact,
									weberp_stockcategory.stockact
							FROM weberp_woitems INNER JOIN weberp_stockmaster
							ON weberp_woitems.stockid=weberp_stockmaster.stockid
							INNER JOIN weberp_stockcategory
							ON weberp_stockmaster.categoryid=weberp_stockcategory.categoryid
							WHERE weberp_woitems.wo='". $_POST['WO'] . "'",
							$ErrMsg);

echo  '<table class="selection">
		<tr>
			<th>' . _('Item') . '</th>
			<th>' . _('Description') . '</th>
			<th>' . _('Quantity Required') . '</th>
			<th>' . _('Units') . '</th>
			<th>' . _('Quantity Received') . '</th>
			<th>' . _('Status') . '</th>
			<th>' . _('Receive') . '</th>
			<th>' . _('Issue') . '</th>
		</tr>';

$TotalStdValueRecd =0;
while ($WORow = DB_fetch_array($WOItemsResult)){

	 echo '<tr>
				<td>' . $WORow['stockid'] . '</td>
	 			<td>' . $WORow['description'] . '</td>
	 			<td class="number">' . locale_number_format($WORow['qtyreqd'],$WORow['decimalplaces']) . '</td>
	 			<td>' . $WORow['units'] . '</td>
	 			<td class="number">' . locale_number_format($WORow['qtyrecd'],$WORow['decimalplaces']) . '</td>
	 			<td class="number"><a href="'. $RootPath . '/WorkOrderStatus.php?WO=' . $_POST['WO'] . '&amp;StockID=' . $WORow['stockid'] . '">' . _('Status') . '</a></td>
	 			<td class="number"><a href="'. $RootPath . '/WorkOrderReceive.php?WO=' . $_POST['WO'] . '&amp;StockID=' . $WORow['stockid'] . '">' . _('Receive') . '</a></td>
	 			<td class="number"><a href="'. $RootPath . '/WorkOrderIssue.php?WO=' . $_POST['WO'] . '&amp;StockID=' . $WORow['stockid'] . '">' . _('Issue') . '</a></td>
 			</tr>';

	$TotalStdValueRecd +=($WORow['stdcost']*$WORow['qtyrecd']);

}
echo '</table>
	<br />
	<table class="selection">';

echo '<tr>
		<th>' . _('Item') . '</th>
		<th>' . _('Description') . '</th>
		<th>' . _('Qty Reqd') . '</th>
		<th>' . _('Cost Reqd') . '</th>
		<th>' . _('Date Issued') . '</th>
		<th>' . _('Issued Qty') . '</th>
		<th>' . _('Issued Cost') . '</th>
		<th>' . _('Usage Variance') . '</th>
		<th>' . _('Cost Variance') . '</th>
	</tr>';

$RequirementsResult = DB_query("SELECT weberp_worequirements.stockid,
									   weberp_stockmaster.description,
 									   weberp_stockmaster.decimalplaces,
 									   weberp_worequirements.stdcost,
									   SUM(weberp_worequirements.qtypu*weberp_woitems.qtyrecd) AS requiredqty,
									   SUM(weberp_worequirements.stdcost*weberp_worequirements.qtypu*weberp_woitems.qtyrecd) AS expectedcost,
									   AVG(weberp_worequirements.qtypu) as qtypu
								FROM weberp_worequirements INNER JOIN weberp_stockmaster
								 ON weberp_worequirements.stockid=weberp_stockmaster.stockid
								 INNER JOIN weberp_woitems ON weberp_woitems.stockid=weberp_worequirements.parentstockid AND weberp_woitems.wo=weberp_worequirements.wo
								WHERE weberp_worequirements.wo='" . $_POST['WO'] . "'
								GROUP BY weberp_worequirements.stockid,
										weberp_stockmaster.description,
										weberp_stockmaster.decimalplaces,
										weberp_worequirements.stdcost");

$k=0;
$TotalUsageVar =0;
$TotalCostVar =0;
$TotalIssuedCost=0;
$TotalReqdCost=0;
$RequiredItems =array();

while ($RequirementsRow = DB_fetch_array($RequirementsResult)){
	$RequiredItems[] = $RequirementsRow['stockid'];
	if ($k==1){
		echo '<tr class="EvenTableRows">';
	} else {
		echo '<tr class="OddTableRows">';
	}

	echo '<td>' .  $RequirementsRow['stockid'] . '</td>
		<td>' .  $RequirementsRow['description'] . '</td>
        </tr>';

	$IssuesResult = DB_query("SELECT weberp_stockmoves.trandate,
									weberp_stockmoves.qty,
									weberp_stockmoves.standardcost,
									weberp_stockmaster.decimalplaces
								FROM weberp_stockmoves INNER JOIN weberp_stockmaster
								ON weberp_stockmoves.stockid = weberp_stockmaster.stockid
								WHERE weberp_stockmoves.type=28
								AND weberp_stockmoves.reference = '" . $_POST['WO'] . "'
								AND weberp_stockmoves.stockid = '" . $RequirementsRow['stockid'] . "'",
								_('Could not retrieve the issues of the item because:'));
	$IssueQty =0;
	$IssueCost=0;

	if (DB_num_rows($IssuesResult)>0){
		while ($IssuesRow = DB_fetch_array($IssuesResult)){
			if ($k==1){
				echo '<tr class="EvenTableRows">';
			} else {
				echo '<tr class="OddTableRows">';
			}
			echo '<td colspan="4"></td><td>' . ConvertSQLDate($IssuesRow['trandate']) . '</td>
				<td class="number">' . locale_number_format(-$IssuesRow['qty'],$RequirementsRow['decimalplaces']) . '</td>
				<td class="number">' . locale_number_format(-($IssuesRow['qty']*$IssuesRow['standardcost']),$IssuesRow['decimalplaces']) . '</td></tr>';
			$IssueQty -= $IssuesRow['qty'];// because qty for the stock movement will be negative
			$IssueCost -= ($IssuesRow['qty']*$IssuesRow['standardcost']);

		}
		if ($k==1){
			echo '<tr class="EvenTableRows">';
		} else {
			echo '<tr class="OddTableRows">';
		}
		echo '<td colspan="9"><hr /></td>
			</tr>';
	}
	if ($k==1){
		echo '<tr class="EvenTableRows">';
	} else {
		echo '<tr class="OddTableRows">';
	}

	if ($IssueQty != 0){
	  $CostVar = $IssueQty *(($RequirementsRow['stdcost']) -($IssueCost/$IssueQty));
	} else {
		$CostVar = 0;
	}
	/*Required quantity is the quantity required of the component based on the quantity of the finished item received */
	$UsageVar =($RequirementsRow['requiredqty']-$IssueQty)*($RequirementsRow['stdcost']);

	echo '<td colspan="2"></td>
			<td class="number">'  . locale_number_format($RequirementsRow['requiredqty'],$RequirementsRow['decimalplaces']) . '</td>
			<td class="number">' . locale_number_format($RequirementsRow['expectedcost'],$_SESSION['CompanyRecord']['decimalplaces']) . '</td>
			<td></td>
			<td class="number">' . locale_number_format($IssueQty,$RequirementsRow['decimalplaces']) . '</td>
			<td class="number">' . locale_number_format($IssueCost,$_SESSION['CompanyRecord']['decimalplaces']) . '</td>
			<td class="number">' . locale_number_format($UsageVar,$_SESSION['CompanyRecord']['decimalplaces']) . '</td>
			<td class="number">' . locale_number_format($CostVar,$_SESSION['CompanyRecord']['decimalplaces']) . '</td>
		</tr>';
	$TotalReqdCost += $RequirementsRow['expectedcost'];
	$TotalIssuedCost += $IssueCost;
	$TotalCostVar += $CostVar;
	$TotalUsageVar += $UsageVar;
	if ($k==1){
		$k=0;
	} else {
		$k++;
	}
	echo '<tr>
			<td colspan="9"><hr /></td>
		</tr>';
}


//Now need to run through the issues to the work order that weren't in the requirements

$sql = "SELECT weberp_stockmoves.stockid,
				weberp_stockmaster.description,
				weberp_stockmaster.decimalplaces,
				trandate,
				qty,
				weberp_stockmoves.standardcost
		FROM weberp_stockmoves INNER JOIN weberp_stockmaster
		ON weberp_stockmoves.stockid=weberp_stockmaster.stockid
		WHERE weberp_stockmoves.type=28
		AND reference = '" . $_POST['WO'] . "'
		AND weberp_stockmoves.stockid NOT IN
					(SELECT weberp_worequirements.stockid
						FROM weberp_worequirements
					WHERE weberp_worequirements.wo='" . $_POST['WO'] . "')";

$WOIssuesResult = DB_query($sql,_('Could not get issues that were not required by the BOM because'));

if (DB_num_rows($WOIssuesResult)>0){
	while ($WOIssuesRow = DB_fetch_array($WOIssuesResult)){
		if ($k==1){
			echo '<tr class="EvenTableRows">';
			$k=0;
		} else {
			echo '<tr class="OddTableRows">';
			$k++;
		}

		echo '<td>' .  $WOIssuesRow['stockid'] . '</td>
				<td>' .  $WOIssuesRow['description'] . '</td>
				<td class="number">0</td>
				<td class="number">0</td>
				<td>' . ConvertSQLDate($WOIssuesRow['trandate']) . '</td>
				<td class="number">' . locale_number_format(-$WOIssuesRow['qty'],$WOIssuesRow['decimalplaces'])   . '</td>
				<td class="number">' . locale_number_format(-$WOIssuesRow['qty']*$WOIssuesRow['standardcost'],$_SESSION['CompanyRecord']['decimalplaces'])   . '</td>
				<td class="number">' . locale_number_format($WOIssuesRow['qty']*$WOIssuesRow['standardcost'],$_SESSION['CompanyRecord']['decimalplaces'])   . '</td>
				<td class="number">0</td>
			</tr>';

		$TotalUsageVar += ($WOIssuesRow['qty']*$WOIssuesRow['standardcost']);
	}
}
# <!--	<td colspan="5"></td> -->
echo '<tr>
		<td colspan="3"></td>
		<td><hr/></td>
		<td colspan="2"></td>
		<td colspan="3"><hr /></td>
	</tr>';
echo '<tr>
		<td colspan="2" class="number">' . _('Totals') . '</td>
		<td></td>
		<td class="number">' . locale_number_format($TotalReqdCost,$_SESSION['CompanyRecord']['decimalplaces'])  . '</td>
		<td></td><td></td>
		<td class="number">' . locale_number_format($TotalIssuedCost,$_SESSION['CompanyRecord']['decimalplaces'])  . '</td>
		<td class="number">' . locale_number_format($TotalUsageVar,$_SESSION['CompanyRecord']['decimalplaces']) . '</td>
		<td class="number">' . locale_number_format($TotalCostVar,$_SESSION['CompanyRecord']['decimalplaces']) . '</td>
	</tr>';

echo '<tr>
		<td colspan="3"></td>
		<td><hr/></td>
		<td colspan="2"></td>
		<td colspan="3"><hr /></td>
	</tr>';

If (isset($_POST['Close'])) {

	DB_data_seek($WOItemsResult,0);
	$NoItemsOnWO = DB_num_rows($WOItemsResult);
	$TotalVariance = $TotalUsageVar + $TotalCostVar;
	$PeriodNo = GetPeriod(Date($_SESSION['DefaultDateFormat']), $db);
	$WOCloseNo = GetNextTransNo(29, $db);
	$TransResult = DB_Txn_Begin();

	while ($WORow = DB_fetch_array($WOItemsResult)){
		if ($TotalStdValueRecd==0){
			$ShareProportion = 1/$NoItemsOnWO;
		} else {
			$ShareProportion = ($WORow['stdcost']*$WORow['qtyrecd'])/$TotalStdValueRecd;
		}
 		if ($_SESSION['WeightedAverageCosting']==1){
			//we need to post the variances to stock and update the weighted average cost

			/*  need to get the current total quantity on hand
			if the quantity on hand is less than the quantity received on the work order
			then some of the variance needs to be written off to P & L and only the proportion
			of the variance relating to the stock still on hand should be posted to the stock value
			*/

			$TotOnHandResult =DB_query("SELECT SUM(quantity)
										FROM weberp_locstock
										WHERE stockid='" . $WORow['stockid'] . "'");
			$TotOnHandRow = DB_fetch_row($TotOnHandResult);
			$TotalOnHand = $TotOnHandRow[0];

			if ($TotalOnHand >= $WORow['qtyrecd']){
				$ProportionOnHand = 1;
			}else {
				$ProportionOnHand = 1 - (($WORow['qtyrecd']- $TotalOnHand)/$WORow['qtyrecd']);
			}

			if ($_SESSION['CompanyRecord']['gllink_stock']==1 AND $TotalVariance!=0){

				//need to get the current cost of the item
				if ($ProportionOnHand < 1){

					$SQL = "INSERT INTO weberp_gltrans (type,
										typeno,
										trandate,
										periodno,
										account,
										narrative,
										amount)
									VALUES (29,
										'" . $WOCloseNo . "',
										'" . Date('Y-m-d') . "',
										'" . $PeriodNo . "',
										'" . $WORow['materialuseagevarac'] . "',
										'" . $_POST['WO'] . ' - ' . $WORow['stockid'] . ' ' . _('share of variance') . "',
										'" .round((-$TotalVariance*$ShareProportion*(1-$ProportionOnHand)),$_SESSION['CompanyRecord']['decimalplaces']) . "')";

					$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The GL posting for the work order variance could not be inserted because');
					$DbgMsg = _('The following SQL to insert the GLTrans record was used');
					$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);
				}


				$SQL = "INSERT INTO weberp_gltrans (type,
							typeno,
							trandate,
							periodno,
							account,
							narrative,
							amount)
						VALUES (29,
							'" . $WOCloseNo . "',
							'" . Date('Y-m-d') . "',
							'" . $PeriodNo . "',
							'" . $WORow['stockact'] . "',
							'" . $_POST['WO'] . ' - ' . $WORow['stockid'] . ' ' . _('share of variance') . "',
							'" . round((-$TotalVariance*$ShareProportion*$ProportionOnHand),$_SESSION['CompanyRecord']['decimalplaces']) . "')";

				$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The GL posting for the work order variance could not be inserted because');
				$DbgMsg = _('The following SQL to insert the GLTrans record was used');
				$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

				$SQL = "INSERT INTO weberp_gltrans (type,
							typeno,
							trandate,
							periodno,
							account,
							narrative,
							amount)
						VALUES (29,
							'" . $WOCloseNo . "',
							'" . Date('Y-m-d') . "',
							'" . $PeriodNo . "',
							'" . $WORow['wipact'] . "',
							'" . $_POST['WO'] . ' - ' . $WORow['stockid'] . ' ' . _('share of variance') . "',
							'" . round(($TotalVariance*$ShareProportion),$_SESSION['CompanyRecord']['decimalplaces']) . "')";

				$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The GL posting for the WIP side of the work order variance posting could not be inserted because');
				$DbgMsg = _('The following SQL to insert the GLTrans record was used');
				$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

			}
			if ($TotalOnHand>0) {//to avoid negative quantity make cost data abnormal
				$NewCost = $WORow['currcost'] +(-$TotalVariance	* $ShareProportion *$ProportionOnHand)/$TotalOnHand;
			} else {
				$NewCost = $WORow['currcost'];
			}

			$SQL = "UPDATE weberp_stockmaster SET
						materialcost='" . $NewCost . "',
						labourcost=0,
						overheadcost=0,
						lastcost='" . $WORow['currcost'] . "',
						lastcostupdate = '" . Date('Y-m-d') . "'
					WHERE stockid='" . $WORow['stockid'] . "'";

			$ErrMsg = _('The cost details for the stock item could not be updated because');
			$DbgMsg = _('The SQL that failed was');
			$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

		} else { //we are standard costing post the variances
			if ($_SESSION['CompanyRecord']['gllink_stock']==1 AND $TotalUsageVar!=0){

				$SQL = "INSERT INTO weberp_gltrans (type,
											typeno,
											trandate,
											periodno,
											account,
											narrative,
											amount)
						VALUES (29,
							'" . $WOCloseNo . "',
							'" . Date('Y-m-d') . "',
							'" . $PeriodNo . "',
							'" . $WORow['materialuseagevarac'] . "',
							'" . $_POST['WO'] . ' - ' . $WORow['stockid'] . ' ' . _('share of usage variance') . "',
							'" . round((-$TotalUsageVar*$ShareProportion),$_SESSION['CompanyRecord']['decimalplaces']) . "')";

				$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The GL posting for the material usage variance could not be inserted because');
				$DbgMsg = _('The following SQL to insert the GLTrans record was used');
				$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

				$SQL = "INSERT INTO weberp_gltrans (type,
											typeno,
											trandate,
											periodno,
											account,
											narrative,
											amount)
						VALUES (29,
							'" . $WOCloseNo . "',
							'" . Date('Y-m-d') . "',
							'" . $PeriodNo . "',
							'" . $WORow['wipact'] . "',
							'" . $_POST['WO'] . ' - ' . $WORow['stockid'] . ' ' . _('share of usage variance') . "',
							'" . round(($TotalUsageVar*$ShareProportion),$_SESSION['CompanyRecord']['decimalplaces']) . "')";

				$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The GL posting for the WIP side of the usage variance posting could not be inserted because');
				$DbgMsg = _('The following SQL to insert the GLTrans record was used');
				$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

			}//end if gl-stock linked and a usage variance exists

			if ($_SESSION['CompanyRecord']['gllink_stock']==1 AND $TotalCostVar!=0){

				$SQL = "INSERT INTO weberp_gltrans (type,
											typeno,
											trandate,
											periodno,
											account,
											narrative,
							amount)
						VALUES (29,
							'" . $WOCloseNo . "',
							'" . Date('Y-m-d') . "',
							'" . $PeriodNo . "',
							'" . $WORow['purchpricevaract'] . "',
							'" . $_POST['WO'] . ' - ' . $WORow['stockid'] . ' ' . _('share of cost variance') . "',
							'" . round((-$TotalCostVar*$ShareProportion),$_SESSION['CompanyRecord']['decimalplaces']) . "')";

				$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The GL posting for the cost variance could not be inserted because');
				$DbgMsg = _('The following SQL to insert the GLTrans record was used');
				$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

				$SQL = "INSERT INTO weberp_gltrans (type,
											typeno,
											trandate,
											periodno,
											account,
											narrative,
											amount)
						VALUES (29,
							'" . $WOCloseNo . "',
							'" . Date('Y-m-d') . "',
							'" . $PeriodNo . "',
							'" . $WORow['wipact'] . "',
							'" . $_POST['WO'] . ' - ' . $WORow['stockid'] . ' ' . _('share of cost variance') . "',
							'" . round(($TotalCostVar*$ShareProportion),$_SESSION['CompanyRecord']['decimalplaces']) . "')";

				$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The GL posting for the WIP side of the cost variance posting could not be inserted because');
				$DbgMsg = _('The following SQL to insert the GLTrans record was used');
				$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

			} //end of if gl-stock integrated and there's a cost variance
		} //end of standard costing section
	} // end loop around the items on the work order

	$CloseWOResult =DB_query("UPDATE weberp_workorders SET closed=1, closecomments = '". $_POST['CloseComments'] ."' WHERE wo='" .$_POST['WO'] . "'",
				_('Could not update the work order to closed because:'),
				_('The SQL used to close the work order was:'),
				true);
	$DeleteAnyWOSerialNos = DB_query("DELETE FROM weberp_woserialnos WHERE wo='" . $_POST['WO'] . "'",
									_('Could not delete the predefined work order serial numbers'),
									_('The SQL used to delete the predefined serial numbers was:'),
									true);
	$TransResult = DB_Txn_Commit();
	if ($_SESSION['CompanyRecord']['gllink_stock']==1){
		if ($_SESSION['WeightedAverageCosting']==1){
			prnMsg(_('The item cost as calculated from the work order has been applied against the weighted average cost and the necessary GL journals created to update stock as a result of closing this work order'),'success');
		} else {
			prnMsg(_('The work order has been closed and general ledger entries made for the variances on the work order'),'success');
		}
	} else {
		if ($_SESSION['WeightedAverageCosting']==1){
			prnMsg(_('The item costs resulting from the work order have been applied against the weighted average stock value of the items on the work order, and the work order has been closed'),'success');
		} else {
			prnMsg(_('The work order has been closed'),'success');
		}
	}
	$WorkOrderRow['closed']=1;
}//end close button hit by user

if ($WorkOrderRow['closed']==0){
	$ReadOnly='';
} else{
	$ReadOnly='readonly';
	if (!isset($_POST['CloseComments'])) {
		$_POST['CloseComments'] = $WorkOrderRow['closecomments'];
	}
}

echo 	'<tr>
			<td colspan="9">
				<div class="centre">
					<textarea ' . $ReadOnly . ' style="width:100%" rows="5" cols="80" name="CloseComments" >' . $_POST['CloseComments'] . '</textarea>
				</div>
			</td>
		</tr>';

if ($WorkOrderRow['closed']==0){
	echo '<tr>
			<td colspan="9">
				<div class="centre">
					<input type="submit" name="Close" value="' . _('Close This Work Order') . '" onclick="return confirm(\'' . _('Closing the work order takes the variances to the general ledger (if integrated). The work order will no longer be able to have manufactured goods received entered against it or materials issued to it.') . '  ' . _('Are You Sure?') . '\');" />
				</div>
			</td>
		</tr>';
} else {
	echo '<tr>
			<td colspan="9">' . _('This work order is closed and cannot accept additional issues of materials or receipts of manufactured items') . '</td>
		</tr>';
}
echo '</table>
	</div>
	</form>';

include('includes/footer.inc');
?>
