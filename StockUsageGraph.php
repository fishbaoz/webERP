<?php
/* $Id: StockUsageGraph.php 6944 2014-10-27 07:15:34Z daintree $*/

include('includes/session.inc');
$result = DB_query("SELECT description FROM weberp_stockmaster WHERE stockid='" . trim(mb_strtoupper($_GET['StockID'])) . "'");
$myrow = DB_fetch_row($result);

include('includes/phplot/phplot.php');
$graph = new phplot(1000,500);
$graph->SetTitle($myrow[0] . ' ' . _('Usage'));
$graph->SetXTitle(_('Month'));
$graph->SetYTitle(_('Quantity'));
$graph->SetBackgroundColor("wheat");
$graph->SetTitleColor("blue");
$graph->SetPlotType="bars";
$graph->SetShading(5);
$graph->SetDrawYGrid(TRUE);
$graph->SetMarginsPixels(40,40,40,40);
$graph->SetDataType('text-data');

if($_GET['StockLocation']=='All'){
	$sql = "SELECT weberp_periods.periodno,
			weberp_periods.lastdate_in_period,
			SUM(-weberp_stockmoves.qty) AS qtyused
		FROM weberp_stockmoves INNER JOIN weberp_periods
			ON weberp_stockmoves.prd=weberp_periods.periodno
		INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_stockmoves.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
		WHERE (weberp_stockmoves.type=10 OR weberp_stockmoves.type=11 OR weberp_stockmoves.type=28)
		AND weberp_stockmoves.hidemovt=0
		AND weberp_stockmoves.stockid = '" . trim(mb_strtoupper($_GET['StockID'])) . "'
		GROUP BY weberp_periods.periodno,
			weberp_periods.lastdate_in_period
		ORDER BY periodno  LIMIT 24";
} else {
	$sql = "SELECT weberp_periods.periodno,
			weberp_periods.lastdate_in_period,
			SUM(-weberp_stockmoves.qty) AS qtyused
		FROM weberp_stockmoves INNER JOIN weberp_periods
			ON weberp_stockmoves.prd=weberp_periods.periodno
		INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_stockmoves.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
		WHERE (weberp_stockmoves.type=10 Or weberp_stockmoves.type=11 OR weberp_stockmoves.type=28)
		AND weberp_stockmoves.hidemovt=0
		AND weberp_stockmoves.loccode='" . $_GET['StockLocation'] . "'
		AND weberp_stockmoves.stockid = '" . trim(mb_strtoupper($_GET['StockID'])) . "'
		GROUP BY weberp_periods.periodno,
			weberp_periods.lastdate_in_period
		ORDER BY periodno  LIMIT 24";
}
$MovtsResult = DB_query($sql);
if (DB_error_no() !=0) {
	$Title = _('Stock Usage Graph Problem');
	include ('includes/header.inc');
	echo _('The stock usage for the selected criteria could not be retrieved because') . ' - ' . DB_error_msg();
	if ($debug==1){
	echo '<br />' . _('The SQL that failed was') . $sql;
	}
	include('includes/footer.inc');
	exit;
}
if (DB_num_rows($MovtsResult)==0){
	$Title = _('Stock Usage Graph Problem');
	include ('includes/header.inc');
	prnMsg(_('There are no movements of this item from the selected location to graph'),'info');
	include('includes/footer.inc');
	exit;
}

$UsageArray = array();
$NumberOfPeriodsUsage = DB_num_rows($MovtsResult);
if ($NumberOfPeriodsUsage!=24){
	$graph->SetDataColors(
		array("blue"),  //Data Colors
		array("black")	//Border Colors
		);
	for ($i=1;$i++;$i<=$NumberOfPeriodsUsage){
		$UsageRow = DB_fetch_array($MovtsResult);
		if (!$UsageRow){
			break;
		} else {
			$UsageArray[] = array(MonthAndYearFromSQLDate($UsageRow['lastdate_in_period']),$UsageRow['qtyused']);
		}
	}
}else {
	$graph->SetDataColors(
		array("blue","red"),  //Data Colors
		array("black")	//Border Colors
	);
	for ($i=1;$i++;$i<=12){
		$UsageRow = DB_fetch_array($MovtsResult);
		if (!$UsageRow){
			break;
		}
		$UsageArray[] = array(MonthAndYearFromSQLDate($UsageRow['lastdate_in_period']),$UsageRow['qtyused']);
	}
	for ($i=0,$i++;$i<=11;){
		$UsageRow = DB_fetch_array($MovtsResult);
		if (!$UsageRow){
			break;
		}
		$UsageArray[$i][0] = MonthAndYearFromSQLDate($UsageRow['lastdate_in_period']);
		$UsageArray[$i][2] = $UsageRow['qtyused'];
	}
}
//$graph->SetDrawXGrid(TRUE);
$graph->SetDataValues($UsageArray);
$graph->SetDataColors(
	array("blue","red"),  //Data Colors
	array("black")	//Border Colors
);


//Draw it
$graph->DrawGraph();
?>