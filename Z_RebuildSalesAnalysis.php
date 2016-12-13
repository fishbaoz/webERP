<?php
/* $Id: Z_RebuildSalesAnalysis.php 5784 2012-12-29 04:00:43Z daintree $*/
/* Script to rebuild sales analysis records from stock movements*/
$PageSecurity = 15;
include ('includes/session.inc');
$Title = _('Rebuild sales analysis Records');
include('includes/header.inc');

echo '<br /><br />' . _('This script rebuilds sales analysis records. NB: all sales budget figures will be lost!');

$result = DB_query("TRUNCATE TABLE weberp_salesanalysis");

$sql = "INSERT INTO weberp_salesanalysis (typeabbrev,
									periodno,
									amt,
									cost,
									cust,
									custbranch,
									qty,
									disc,
									stockid,
									area,
									budgetoractual,
									salesperson,
									stkcategory)
		SELECT salestype,
		(SELECT periodno FROM weberp_periods WHERE MONTH(lastdate_in_period)=MONTH(trandate) AND YEAR(lastdate_in_period)=YEAR(trandate)) as prd,
				SUM(price*-qty) as salesvalue,
				SUM(standardcost*-qty) as cost,
				weberp_stockmoves.debtorno,
				weberp_stockmoves.branchcode,
				SUM(-qty),
				SUM(-qty*price*discountpercent) AS discountvalue,
				weberp_stockmoves.stockid,
				weberp_custbranch.area,
				1,
				weberp_custbranch.salesman,
				weberp_stockmaster.categoryid
		FROM weberp_stockmoves
		INNER JOIN weberp_debtorsmaster
		ON weberp_stockmoves.debtorno=weberp_debtorsmaster.debtorno
		INNER JOIN weberp_custbranch
		ON weberp_stockmoves.debtorno=weberp_custbranch.debtorno
		AND weberp_stockmoves.branchcode=weberp_custbranch.branchcode
		INNER JOIN weberp_stockmaster
		ON weberp_stockmoves.stockid=weberp_stockmaster.stockid
        WHERE show_on_inv_crds=1
		GROUP BY salestype,
				debtorno,
				prd,
				branchcode,
				stockid,
				area,
				salesman,
				categoryid
		ORDER BY prd";
		
$ErrMsg = _('The sales analysis data could not be recreated because');
$Result = DB_query($sql,$ErrMsg);

echo '<p />';
prnMsg(_('The sales analsysis data has been recreated based on current stock master and customer master information'),'info');

include('includes/footer.inc');
?>

?>
?>

