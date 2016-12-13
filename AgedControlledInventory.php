<?php

/* $Id: AgedControlledInventory.php 1 2014-08-08 04:47:42Z agaluski $ */

include('includes/session.inc');
$PricesSecurity = 12;//don't show pricing info unless security token 12 available to user
$Today =  time();
$Title = _('Aged Controlled Inventory') . ' ' ._('as-of') .' ' . Date(($_SESSION['DefaultDateFormat']), strtotime($UpcomingDate . ' + 0 days'));
include('includes/header.inc');

echo '<p class="page_title_text">
		<img src="'.$RootPath.'/css/'.$Theme.'/images/inventory.png" title="' . _('Inventory') .
'" alt="" /><b>' . $Title. '</b>
	</p>';

$sql = "SELECT weberp_stockserialitems.stockid,
				weberp_stockmaster.description,
				weberp_stockserialitems.serialno,
				weberp_stockserialitems.quantity,
				weberp_stockmoves.trandate,
				weberp_stockmaster.materialcost+weberp_stockmaster.labourcost+weberp_stockmaster.overheadcost AS cost,
				decimalplaces
			FROM weberp_stockserialitems
			LEFT JOIN weberp_stockserialmoves ON weberp_stockserialitems.serialno=weberp_stockserialmoves.serialno
			LEFT JOIN weberp_stockmoves ON weberp_stockserialmoves.stockmoveno=weberp_stockmoves.stkmoveno
			INNER JOIN weberp_stockmaster ON weberp_stockmaster.stockid = weberp_stockserialitems.stockid
			INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_stockserialitems.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
			WHERE quantity > 0
			GROUP BY stockid, serialno
			ORDER BY trandate";

$ErrMsg =  _('The stock held could not be retrieved because');
$LocStockResult = DB_query($sql, $ErrMsg);
$NumRows = DB_num_rows($LocStockResult, $db);

$j = 1;
$TotalQty=0;
$TotalVal=0;
$k=0; //row colour counter
echo '<table>
		<tr>
			<th class="ascending">' . _('Stock') . '</th>
			<th class="ascending">' . _('Description') . '</th>
			<th class="ascending">' . _('Batch') . '</th>
			<th class="ascending">' . _('Quantity Remaining') . '</th>
			<th class="ascending">' . _('Inventory Value') . '</th>
			<th class="ascending">' . _('Date') . '</th>
			<th class="ascending">' . _('Days Old') . '</th>
		</tr>';
while ($LocQtyRow=DB_fetch_array($LocStockResult)) {

	if ($k==1){
		echo '<tr class="OddTableRows">';
		$k=0;
	} else {
		echo '<tr class="EvenTableRows">';
		$k=1;
	}
	$DaysOld=floor(($Today - strtotime($LocQtyRow['trandate']))/(60*60*24));
	$TotalQty +=$LocQtyRow['quantity'];
	//$TotalVal +=($LocQtyRow['quantity'] *$LocQtyRow['cost']);
	$DispVal =  '-----------';
	if (in_array($PricesSecurity, $_SESSION['AllowedPageSecurityTokens']) OR !isset($PricesSecurity)) {
		$DispVal =locale_number_format(($LocQtyRow['quantity']*$LocQtyRow['cost']),$LocQtyRow['decimalplaces']);
		$TotalVal +=($LocQtyRow['quantity'] *$LocQtyRow['cost']);
	}
	printf('<td>%s</td>
			<td>%s</td>
			<td>%s</td>
			<td class="number">%s</td>
			<td class="number">%s</td>
			<td>%s</td>
			<td class="number">%s</td></tr>',
			mb_strtoupper($LocQtyRow['stockid']),
			$LocQtyRow['description'],
			$LocQtyRow['serialno'],
			locale_number_format($LocQtyRow['quantity'],$LocQtyRow['decimalplaces']),
			$DispVal,
			ConvertSQLDate($LocQtyRow['trandate']),
			$DaysOld);


} //while
if ($k==1){
	echo '<tfoot><tr class="OddTableRows">';
	$k=0;
} else {
	echo '<tfoot><tr class="EvenTableRows">';
	$k=1;
}
echo '<td colspan="3"><b>' . _('Total') . '</b></td><td class="number"><b>' . locale_number_format($TotalQty,2) . '</td><td class="number"><b>' . locale_number_format($TotalVal,2) . '</td><td colspan="2"></td>';
echo '</table>';

include('includes/footer.inc');
?>