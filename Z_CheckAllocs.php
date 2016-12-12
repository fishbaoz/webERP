<?php
/* $Id: Z_CheckAllocs.php 6941 2014-10-26 23:18:08Z daintree $*/
/*This page adds the total of allocation records and compares this to the recorded allocation total in DebtorTrans table */

include('includes/session.inc');
$Title = _('Customer Allocations != DebtorTrans.Alloc');
include('includes/header.inc');

/*First off get the DebtorTransID of all invoices where allocations dont agree to the recorded allocation */
$sql = "SELECT weberp_debtortrans.id,
		weberp_debtortrans.debtorno,
		weberp_debtortrans.transno,
		ovamount+ovgst AS totamt,
		SUM(weberp_custallocns.Amt) AS totalalloc,
		weberp_debtortrans.alloc
	FROM weberp_debtortrans INNER JOIN weberp_custallocns
	ON weberp_debtortrans.id=weberp_custallocns.transid_allocto
	WHERE weberp_debtortrans.type=10
	GROUP BY weberp_debtortrans.ID,
		weberp_debtortrans.type,
		ovamount+ovgst,
		weberp_debtortrans.alloc
	HAVING SUM(weberp_custallocns.amt) < weberp_debtortrans.alloc - 1";

$result = DB_query($sql);

if (DB_num_rows($result)==0){
	prnMsg(_('There are no inconsistencies with allocations') . ' - ' . _('all is well'),'info');
}

while ($myrow = DB_fetch_array($result)){
	$AllocToID = $myrow['id'];

	echo '<br />' . _('Allocations made against') . ' ' . $myrow['debtorno'] . ' ' . _('Invoice Number') . ': ' . $myrow['transno'];
	echo '<br />' . _('Original Invoice Total') . ': '. $myrow['totamt'];
	echo '<br />' . _('Total amount recorded as allocated against it') . ': ' . $myrow['alloc'];
	echo '<br />' . _('Total of allocation records') . ': ' . $myrow['totalalloc'];

	$sql = "SELECT type,
				transno,
				trandate,
				weberp_debtortrans.debtorno,
				reference,
				weberp_debtortrans.rate,
				ovamount+ovgst+ovfreight+ovdiscount AS totalamt,
				weberp_custallocns.amt,
				decimalplaces AS currdecimalplaces
			FROM weberp_debtortrans INNER JOIN weberp_custallocns
			ON weberp_debtortrans.id=weberp_custallocns.transid_allocfrom
			INNER JOIN weberp_debtorsmaster ON
			weberp_debtortrans.debtorno=weberp_debtorsmaster.debtorno
			INNER JOIN weberp_currencies ON
			weberp_debtorsmaster.currcode=weberp_currencies.currabrev
			WHERE weberp_custallocns.transid_allocto='" . $AllocToID . "'";

	$ErrMsg = _('The customer transactions for the selected criteria could not be retrieved because');
	$TransResult = DB_query($sql,$ErrMsg);

	echo '<table class="selection">';

	$tableheader = '<tr>
				<th>' . _('Type') . '</th>
				<th>' . _('Number') . '</th>
				<th>' . _('Reference') . '</th>
				<th>' . _('Ex Rate') . '</th>
				<th>' . _('Amount') . '</th>
				<th>' . _('Alloc') . '</th></tr>';
	echo $tableheader;

	$RowCounter = 1;
	$k = 0; //row colour counter
	$AllocsTotal = 0;

	while ($myrow1=DB_fetch_array($TransResult)) {

		if ($k==1){
			echo '<tr class="EvenTableRows">';
			$k=0;
		} else {
			echo '<tr class="OddTableRows">';
			$k++;
		}

		if ($myrow1['type']==11){
			$TransType = _('Credit Note');
		} else {
			$TransType = _('Receipt');
		}
		$CurrDecimalPlaces = $myrow1['currdecimalplaces'];

		printf( '<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td class="number">%s</td>
				<td class="number">%s</td>
				</tr>',
				$TransType,
				$myrow1['transno'],
				$myrow1['reference'],
				locale_number_format($myrow1['exrate'],4),
				locale_number_format($myrow1['totalamt'],$CurrDecimalPlaces),
				locale_number_format($myrow1['amt'],$CurrDecimalPlaces));

		$RowCounter++;
		If ($RowCounter == 12){
			$RowCounter=1;
			echo $tableheader;
		}
		//end of page full new headings if
		$AllocsTotal +=$myrow1['amt'];
	}
	//end of while loop
	echo '<tr><td colspan="6" class="number">' . locale_number_format($AllocsTotal,$CurrDecimalPlaces) . '</td></tr>';
	echo '</table>
		<br />';
}

include('includes/footer.inc');

?>