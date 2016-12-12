<?php

/* $Id: StockReorderLevel.php 6941 2014-10-26 23:18:08Z daintree $*/

include('includes/session.inc');
$Title = _('Stock Re-Order Level Maintenance');
include('includes/header.inc');

if (isset($_GET['StockID'])){
	$StockID = trim(mb_strtoupper($_GET['StockID']));
} elseif (isset($_POST['StockID'])){
	$StockID = trim(mb_strtoupper($_POST['StockID']));
}else{
	$StockID = '';
}

echo '<a href="' . $RootPath . '/SelectProduct.php">' . _('Back to Items') . '</a>';

echo '<p class="page_title_text">
		<img src="'.$RootPath.'/css/'.$Theme.'/images/inventory.png" title="' . _('Inventory') . '" alt="" /><b>' . $Title. '</b>
	</p>';

$result = DB_query("SELECT description, units FROM weberp_stockmaster WHERE stockid='" . $StockID . "'");
$myrow = DB_fetch_row($result);

echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '" method="post">';
echo '<div>';
echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';

$sql = "SELECT weberp_locstock.loccode,
				weberp_locations.locationname,
				weberp_locstock.quantity,
				weberp_locstock.reorderlevel,
				weberp_stockmaster.decimalplaces,
				canupd
		FROM weberp_locstock INNER JOIN weberp_locations
			ON weberp_locstock.loccode=weberp_locations.loccode
		INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locstock.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
			INNER JOIN weberp_stockmaster
			ON weberp_locstock.stockid=weberp_stockmaster.stockid
		WHERE weberp_locstock.stockid = '" . $StockID . "'
		ORDER BY weberp_locations.locationname";

$ErrMsg = _('The stock held at each location cannot be retrieved because');
$DbgMsg = _('The SQL that failed was');

$LocStockResult = DB_query($sql, $ErrMsg, $DbgMsg);

echo '<table class="selection">';
echo '<tr>
		<th colspan="3">' . _('Stock Code') . ':<input  type="text" data-type="no-illegal-chars" title="'._('The stock id should not contains illegal characters and blank or percentage mark is not allowed').'" required="required" name="StockID" size="21" value="' . $StockID . '" maxlength="20" /><input type="submit" name="Show" value="' . _('Show Re-Order Levels') . '" /></th>
	</tr>';
echo '<tr>
		<th colspan="3"><h3><b>' . $StockID . ' - ' . $myrow[0] . '</b>  (' . _('In Units of') . ' ' . $myrow[1] . ')</h3></th>
	</tr>';

$TableHeader = '<tbody><tr>
					<th class="ascending">' . _('Location') . '</th>
					<th class="ascending">' . _('Quantity On Hand') . '</th>
					<th class="ascending">' . _('Re-Order Level') . '</th>
				</tr>';

echo $TableHeader;
$k=0; //row colour counter

while ($myrow=DB_fetch_array($LocStockResult)) {

	if ($k==1){
		echo '<tr class="EvenTableRows">';
		$k=0;
	} else {
		echo '<tr class="OddTableRows">';
		$k=1;
	}

	if (isset($_POST['UpdateData'])
		AND $_POST['Old_' . $myrow['loccode']]!= filter_number_format($_POST[$myrow['loccode']])
		AND is_numeric(filter_number_format($_POST[$myrow['loccode']]))
		AND filter_number_format($_POST[$myrow['loccode']])>=0){

	   $myrow['reorderlevel'] = filter_number_format($_POST[$myrow['loccode']]);
	   $sql = "UPDATE weberp_locstock SET reorderlevel = '" . filter_number_format($_POST[$myrow['loccode']]) . "'
	   		WHERE stockid = '" . $StockID . "'
			AND loccode = '"  . $myrow['loccode'] ."'";
	   $UpdateReorderLevel = DB_query($sql);

	}
	if ($myrow['canupd']==1) {
		$UpdateCode='<input title="'._('Input safety stock quantity').'" type="text" class="number" name="%s" maxlength="10" size="10" value="%s" />
			<input type="hidden" name="Old_%s" value="%s" />';
	} else {
		$UpdateCode='<input type="hidden" name="%s">%s<input type="hidden" name="Old_%s" value="%s" />';
	}
	printf('<td>%s</td>
			<td class="number">%s</td>
			<td class="number">' . $UpdateCode . '</td></tr>',
			$myrow['locationname'],
			locale_number_format($myrow['quantity'],$myrow['decimalplaces']),
			$myrow['loccode'],
			$myrow['reorderlevel'],
			$myrow['loccode'],
			$myrow['reorderlevel']);

//end of page full new headings if
}
//end of while loop

echo '</tbody></table>
	<br />
	<div class="centre">
		<input type="submit" name="UpdateData" value="' . _('Update') . '" />
		<br />
		<br />';

echo '<a href="' . $RootPath . '/StockMovements.php?StockID=' . $StockID . '">' . _('Show Stock Movements') . '</a>';
echo '<br /><a href="' . $RootPath . '/StockUsage.php?StockID=' . $StockID . '">' . _('Show Stock Usage') . '</a>';
echo '<br /><a href="' . $RootPath . '/SelectSalesOrder.php?SelectedStockItem=' . $StockID . '">' . _('Search Outstanding Sales Orders') . '</a>';
echo '<br /><a href="' . $RootPath . '/SelectCompletedOrder.php?SelectedStockItem=' . $StockID . '">' . _('Search Completed Sales Orders') . '</a>';

echo '</div>
    </div>
	</form>';
include('includes/footer.inc');
?>
