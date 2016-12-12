<?php
/* $Id: Z_CurrencySuppliersBalances.php 7052 2014-12-28 21:40:12Z rchacon $*/
/* This script is an utility to show suppliers balances in total by currency. */

include ('includes/session.inc');
$Title = _('Currency Supplier Balances');// Screen identificator.
$ViewTopic = 'SpecialUtilities';// Filename's id in ManualContents.php's TOC.
$BookMark = 'Z_CurrencySuppliersBalances';// Anchor's id in the manual's html document.
include('includes/header.inc');
echo '<p class="page_title_text"><img alt="" src="'.$RootPath.'/css/'.$Theme.
	'/images/supplier.png" title="' .
	_('Show Local Currency Total Suppliers Balances') . '" /> ' .// Icon title.
	_('Suppliers Balances By Currency Totals') . '</p>';// Page title.

$sql = "SELECT SUM(ovamount+ovgst-alloc) AS currencybalance,
		currcode,
		decimalplaces AS currdecimalplaces,
		SUM((ovamount+ovgst-alloc)/weberp_supptrans.rate) AS localbalance
		FROM weberp_supptrans INNER JOIN weberp_suppliers ON weberp_supptrans.supplierno=weberp_suppliers.supplierid
		INNER JOIN weberp_currencies ON weberp_suppliers.currcode=weberp_currencies.currabrev
		WHERE (ovamount+ovgst-alloc)<>0
		GROUP BY currcode";

$result = DB_query($sql);

$LocalTotal =0;

echo '<table>';

while ($myrow=DB_fetch_array($result)){

	echo '<tr>
			<td>' . _('Total Supplier Balances in') . ' </td>
			<td>' . $myrow['currcode'] . '</td>
			<td class="number">' . locale_number_format($myrow['currencybalance'],$myrow['currdecimalplaces']) . '</td>
			<td> ' . _('in') . ' ' . $_SESSION['CompanyRecord']['currencydefault'] . '</td>
			<td class="number">' . locale_number_format($myrow['localbalance'],$_SESSION['CompanyRecord']['decimalplaces']) . '</td>
		</tr>';
	$LocalTotal += $myrow['localbalance'];
}

echo '<tr>
		<td colspan="4">' . _('Total Balances in local currency') . ':</td>
		<td class="number">' . locale_number_format($LocalTotal,$_SESSION['CompanyRecord']['decimalplaces']) . '</td>
	</tr>';

echo '</table>';

include('includes/footer.inc');
?>
