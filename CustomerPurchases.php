<?php
/* $Id: CustomerPurchases.php 7090 2015-01-20 13:43:08Z daintree $*/
/* This script is to view the items purchased by a customer. */

include('includes/session.inc');
$Title = _('Customer Purchases');// Screen identificator.
$ViewTopic = 'ARInquiries';// Filename's id in ManualContents.php's TOC.
/* This help needs to be writing...
$BookMark = 'CustomerPurchases';// Anchor's id in the manual's html document.*/
include('includes/header.inc');

if(isset($_GET['DebtorNo'])) {
	$DebtorNo = $_GET['DebtorNo'];// Set DebtorNo from $_GET['DebtorNo'].
} elseif(isset($_POST['DebtorNo'])) {
	$DebtorNo = $_POST['DebtorNo'];// Set DebtorNo from $_POST['DebtorNo'].
} else {
	prnMsg(_('This script must be called with a customer code.'), 'info');
	include('includes/footer.inc');
	exit;
}

$SQL = "SELECT weberp_debtorsmaster.name,
				weberp_custbranch.brname
		FROM weberp_debtorsmaster
		INNER JOIN weberp_custbranch
			ON weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno
		WHERE weberp_debtorsmaster.debtorno = '" . $DebtorNo . "'";

$ErrMsg = _('The customer details could not be retrieved by the SQL because');
$CustomerResult = DB_query($SQL, $ErrMsg);
$CustomerRecord = DB_fetch_array($CustomerResult);

echo '<p class="page_title_text"><img alt="" src="'.$RootPath.'/css/'.$Theme.
	'/images/customer.png" title="' .
	_('Customer') . '" /> ' .// Icon title.
	_('Items Purchased by Customer') . '<br />' . $DebtorNo . " - " . $CustomerRecord['name'] . '</p>';// Page title.

$SQL = "SELECT weberp_stockmoves.stockid,
			weberp_stockmaster.description,
			weberp_systypes.typename,
			transno,
			weberp_locations.locationname,
			trandate,
			weberp_stockmoves.branchcode,
			price,
			reference,
			qty,
			narrative
		FROM weberp_stockmoves
		INNER JOIN weberp_stockmaster
			ON weberp_stockmaster.stockid=weberp_stockmoves.stockid
		INNER JOIN weberp_systypes
			ON weberp_stockmoves.type=weberp_systypes.typeid
		INNER JOIN weberp_locations
			ON weberp_stockmoves.loccode=weberp_locations.loccode
		INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locations.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1";

$SQLWhere=" WHERE weberp_stockmoves.debtorno='" . $DebtorNo . "'";

if ($_SESSION['SalesmanLogin'] != '') {
	$SQL .= " INNER JOIN weberp_custbranch
				ON weberp_stockmoves.branchcode=weberp_custbranch.branchcode";
	$SQLWhere .= " AND weberp_custbranch.salesman='" . $_SESSION['SalesmanLogin'] . "'";
}

$SQL .= $SQLWhere . " ORDER BY trandate DESC";

$ErrMsg = _('The stock movement details could not be retrieved by the SQL because');
$StockMovesResult = DB_query($SQL, $ErrMsg);

if (DB_num_rows($StockMovesResult) == 0) {
	echo '<br />';
	prnMsg(_('There are no items for this customer'), 'notice');
	echo '<br />';
} //DB_num_rows($StockMovesResult) == 0
else {
	echo '<table class="selection">
			<tr>
				<th>' . _('Transaction Date') . '</th>
				<th>' . _('Stock ID') . '</th>
				<th>' . _('Description') . '</th>
				<th>' . _('Type') . '</th>
				<th>' . _('Transaction No.') . '</th>
				<th>' . _('From Location') . '</th>
				<th>' . _('Branch Code') . '</th>
				<th>' . _('Price') . '</th>
				<th>' . _('Quantity') . '</th>
				<th>' . _('Amount of Sale') . '</th>
				<th>' . _('Reference') . '</th>
				<th>' . _('Narrative') . '</th>
			</tr>';

	while ($StockMovesRow = DB_fetch_array($StockMovesResult)) {
		echo '<tr>
				<td>' . ConvertSQLDate($StockMovesRow['trandate']) . '</td>
				<td>' . $StockMovesRow['stockid'] . '</td>
				<td>' . $StockMovesRow['description'] . '</td>
				<td>' . _($StockMovesRow['typename']) . '</td>
				<td class="number">' . $StockMovesRow['transno'] . '</td>
				<td>' . $StockMovesRow['locationname'] . '</td>
				<td>' . $StockMovesRow['branchcode'] . '</td>
				<td class="number">' . locale_number_format($StockMovesRow['price'], $_SESSION['CompanyRecord']['decimalplaces']) . '</td>
				<td class="number">' . locale_number_format(-$StockMovesRow['qty'], $_SESSION['CompanyRecord']['decimalplaces']) . '</td>
				<td class="number">' . locale_number_format((-$StockMovesRow['qty'] * $StockMovesRow['price']), $_SESSION['CompanyRecord']['decimalplaces']) . '</td>
				<td class="number">' . $StockMovesRow['reference'] . '</td>
				<td>' . $StockMovesRow['narrative'] . '</td>
			</tr>';

	} //$StockMovesRow = DB_fetch_array($StockMovesResult)

	echo '</table>';
}

echo '<br /><div class="centre"><a href="SelectCustomer.php">' . _('Return to customer selection screen') . '</a></div><br />';

include('includes/footer.inc');
?>
