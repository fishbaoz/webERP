<?php
/* $Id: Z_CurrencyDebtorsBalances.php 7052 2014-12-28 21:40:12Z rchacon $*/
/* This script is an utility to show debtors balances in total by currency. */

include ('includes/session.inc');
$Title = _('Currency Debtor Balances');// Screen identificator.
$ViewTopic = 'SpecialUtilities';// Filename's id in ManualContents.php's TOC.
$BookMark = 'Z_CurrencyDebtorsBalances';// Anchor's id in the manual's html document.
include('includes/header.inc');
echo '<p class="page_title_text"><img alt="" src="'.$RootPath.'/css/'.$Theme.
	'/images/ar.png" title="' .
	_('Show Local Currency Total Debtors Balances') . '" /> ' .// Icon title.
	_('Debtors Balances By Currency Totals') . '</p>';// Page title.

$sql = "SELECT SUM(ovamount+ovgst+ovdiscount+ovfreight-alloc) AS currencybalance,
		currcode,
		decimalplaces AS currdecimalplaces,
		SUM((ovamount+ovgst+ovdiscount+ovfreight-alloc)/weberp_debtortrans.rate) AS localbalance
	FROM weberp_debtortrans INNER JOIN weberp_debtorsmaster
		ON weberp_debtortrans.debtorno=weberp_debtorsmaster.debtorno
	INNER JOIN weberp_currencies
	ON weberp_debtorsmaster.currcode=weberp_currencies.currabrev
	WHERE (ovamount+ovgst+ovdiscount+ovfreight-alloc)<>0 GROUP BY currcode";

$result = DB_query($sql);


$LocalTotal =0;

echo '<table>';

while ($myrow=DB_fetch_array($result)){

	echo '<tr>
			<td>' . _('Total Debtor Balances in') . ' </td>
			<td>' . $myrow['currcode'] . '</td>
			<td class="number">' . locale_number_format($myrow['currencybalance'],$myrow['currdecimalplaces']) . '</td>
			<td>' . _('in') . ' ' . $_SESSION['CompanyRecord']['currencydefault'] . '</td>
			<td class="number">' . locale_number_format($myrow['localbalance'],$_SESSION['CompanyRecord']['decimalplaces']) . '</td>
		</tr>';
	$LocalTotal += $myrow['localbalance'];
}

echo '<tr>
		<td colspan="4">' . _('Total Balances in local currency') . ':</td>
		<td class="number">' . locale_number_format($LocalTotal,$_SESSION['CompanyRecord']['decimalplaces']) . '</td></tr>';

echo '</table>';

include('includes/footer.inc');
?>
