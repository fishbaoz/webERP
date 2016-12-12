<?php

/* $Id: StockUsage.php 6944 2014-10-27 07:15:34Z daintree $*/

include('includes/session.inc');

$Title = _('Stock Usage');

if (isset($_GET['StockID'])){
	$StockID = trim(mb_strtoupper($_GET['StockID']));
} elseif (isset($_POST['StockID'])){
	$StockID = trim(mb_strtoupper($_POST['StockID']));
} else {
	$StockID = '';
}

if (isset($_POST['ShowGraphUsage'])) {
	echo '<meta http-equiv="Refresh" content="0; url=' . $RootPath . '/StockUsageGraph.php?StockLocation=' . $_POST['StockLocation']  . '&amp;StockID=' . $StockID . '">';
	prnMsg(_('You should automatically be forwarded to the usage graph') .
			'. ' . _('If this does not happen') .' (' . _('if the browser does not support META Refresh') . ') ' .
			'<a href="' . $RootPath . '/StockUsageGraph.php?StockLocation=' . $_POST['StockLocation'] .'&amp;StockID=' . $StockID . '">' . _('click here') . '</a> ' . _('to continue'),'info');
	exit;
}

include('includes/header.inc');

echo '<p class="page_title_text">
		<img src="'.$RootPath.'/css/'.$Theme.'/images/magnifier.png" title="' . _('Dispatch') .
		'" alt="" />' . ' ' . $Title . '
	</p>';

$result = DB_query("SELECT description,
						units,
						mbflag,
						decimalplaces
					FROM weberp_stockmaster
					WHERE stockid='".$StockID."'");
$myrow = DB_fetch_row($result);

$DecimalPlaces = $myrow[3];

echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '" method="post">';
echo '<div>';
echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';
echo '<table class="selection">';

$Its_A_KitSet_Assembly_Or_Dummy =False;
if ($myrow[2]=='K'
	OR $myrow[2]=='A'
	OR $myrow[2]=='D') {

	$Its_A_KitSet_Assembly_Or_Dummy =True;
	echo '<h3>' . $StockID . ' - ' . $myrow[0] . '</h3>';

	prnMsg( _('The selected item is a dummy or assembly or kit-set item and cannot have a stock holding') . '. ' . _('Please select a different item'),'warn');

	$StockID = '';
} else {
	echo '<tr>
			<th><h3>' . _('Item') . ' : ' . $StockID . ' - ' . $myrow[0] . '   (' . _('in units of') . ' : ' . $myrow[1] . ')</h3></th>
		</tr>';
}

echo '<tr><td>' . _('Stock Code') . ':<input type="text" pattern="(?!^\s+$)[^%]{1,20}" title="'._('The input should not be blank or percentage mark').'" required="required" name="StockID" size="21" maxlength="20" value="' . $StockID . '" />';

echo _('From Stock Location') . ':<select name="StockLocation">';

$sql = "SELECT weberp_locations.loccode, locationname FROM weberp_locations
			INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locations.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1";
$resultStkLocs = DB_query($sql);
while ($myrow=DB_fetch_array($resultStkLocs)){
	if (isset($_POST['StockLocation'])){
		if ($myrow['loccode'] == $_POST['StockLocation']){
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
if (isset($_POST['StockLocation'])){
	if ('All'== $_POST['StockLocation']){
	     echo '<option selected="selected" value="All">' . _('All Locations') . '</option>';
	} else {
	     echo '<option value="All">' . _('All Locations') . '</option>';
	}
}
echo '</select>';

echo ' <input type="submit" name="ShowUsage" value="' . _('Show Stock Usage') . '" />';
echo ' <input type="submit" name="ShowGraphUsage" value="' . _('Show Graph Of Stock Usage') . '" /></td>
		</tr>
		</table>
		<br />';


/*HideMovt ==1 if the movement was only created for the purpose of a transaction but is not a physical movement eg. A price credit will create a movement record for the purposes of display on a credit note
but there is no physical stock movement - it makes sense honest ??? */

$CurrentPeriod = GetPeriod(Date($_SESSION['DefaultDateFormat']),$db);

if (isset($_POST['ShowUsage'])){
	if($_POST['StockLocation']=='All'){
		$sql = "SELECT weberp_periods.periodno,
				weberp_periods.lastdate_in_period,
				canview,
				SUM(CASE WHEN (weberp_stockmoves.type=10 Or weberp_stockmoves.type=11 OR weberp_stockmoves.type=28)
							AND weberp_stockmoves.hidemovt=0
							AND weberp_stockmoves.stockid = '" . $StockID . "'
						THEN -weberp_stockmoves.qty ELSE 0 END) AS qtyused
				FROM weberp_periods LEFT JOIN weberp_stockmoves
					ON weberp_periods.periodno=weberp_stockmoves.prd
				INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_stockmoves.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
				WHERE weberp_periods.periodno <='" . $CurrentPeriod . "'
				GROUP BY weberp_periods.periodno,
					weberp_periods.lastdate_in_period
				ORDER BY periodno DESC LIMIT " . $_SESSION['NumberOfPeriodsOfStockUsage'];
	} else {
		$sql = "SELECT weberp_periods.periodno,
				weberp_periods.lastdate_in_period,
				SUM(CASE WHEN (weberp_stockmoves.type=10 Or weberp_stockmoves.type=11 OR weberp_stockmoves.type=28)
								AND weberp_stockmoves.hidemovt=0
								AND weberp_stockmoves.stockid = '" . $StockID . "'
								AND weberp_stockmoves.loccode='" . $_POST['StockLocation'] . "'
							THEN -weberp_stockmoves.qty ELSE 0 END) AS qtyused
				FROM weberp_periods LEFT JOIN weberp_stockmoves
					ON weberp_periods.periodno=weberp_stockmoves.prd
				WHERE weberp_periods.periodno <='" . $CurrentPeriod . "'
				GROUP BY weberp_periods.periodno,
					weberp_periods.lastdate_in_period
				ORDER BY periodno DESC LIMIT " . $_SESSION['NumberOfPeriodsOfStockUsage'];

	}
	$MovtsResult = DB_query($sql);
	if (DB_error_no() !=0) {
		echo _('The stock usage for the selected criteria could not be retrieved because') . ' - ' . DB_error_msg();
		if ($debug==1){
		echo '<br />' . _('The SQL that failed was') . $sql;
		}
		exit;
	}

	echo '<table class="selection">';
	$tableheader = '<tr>
						<th class="ascending">' . _('Month') . '</th>
						<th class="ascending">' . _('Usage') . '</th>
					</tr>';
	echo $tableheader;

	$j = 1;
	$k=0; //row colour counter

	$TotalUsage = 0;
	$PeriodsCounter =0;

	while ($myrow=DB_fetch_array($MovtsResult)) {

		if ($k==1){
			echo '<tr class="EvenTableRows">';
			$k=0;
		} else {
			echo '<tr class="OddTableRows">';
			$k++;
		}

		$DisplayDate = MonthAndYearFromSQLDate($myrow['lastdate_in_period']);

		$TotalUsage += $myrow['qtyused'];
		$PeriodsCounter++;
		printf('<td>%s</td>
				<td class="number">%s</td>
				</tr>',
				$DisplayDate,
				locale_number_format($myrow['qtyused'],$DecimalPlaces));

	//end of page full new headings if
	}
	//end of while loop
		echo '</table>';
	if ($TotalUsage>0 AND $PeriodsCounter>0){
		echo '<table class="selection"><tr>
				<th colspan="2">' . _('Average Usage per month is') . ' ' . locale_number_format($TotalUsage/$PeriodsCounter) . '</th>
			</tr></table>';
	}

} /* end if Show Usage is clicked */

echo '<div class="centre">';
echo '<br />
    <a href="' . $RootPath . '/StockStatus.php?StockID=' . $StockID . '">' . _('Show Stock Status')  . '</a>';
echo '<br />
	<a href="' . $RootPath . '/StockMovements.php?StockID=' . $StockID . '&amp;StockLocation=' . $_POST['StockLocation'] . '">' . _('Show Stock Movements') . '</a>';
echo '<br />
	<a href="' . $RootPath . '/SelectSalesOrder.php?SelectedStockItem=' . $StockID . '&amp;StockLocation=' . $_POST['StockLocation'] . '">' . _('Search Outstanding Sales Orders') . '</a>';
echo '<br />
	<a href="' . $RootPath . '/SelectCompletedOrder.php?SelectedStockItem=' . $StockID . '">' . _('Search Completed Sales Orders') . '</a>';
echo '<br />
	<a href="' . $RootPath . '/PO_SelectOSPurchOrder.php?SelectedStockItem=' . $StockID . '">' . _('Search Outstanding Purchase Orders') . '</a>';

echo '</div>
      </div>
      </form>';
include('includes/footer.inc');

?>
