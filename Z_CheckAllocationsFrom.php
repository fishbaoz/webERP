<?php
/* $Id: Z_CheckAllocationsFrom.php 6941 2014-10-26 23:18:08Z daintree $*/

include ('includes/session.inc');
$Title = _('Identify Allocation Stuff Ups');
include ('includes/header.inc');

$sql = "SELECT weberp_debtortrans.type,
		weberp_debtortrans.transno,
		weberp_debtortrans.ovamount,
		weberp_debtortrans.alloc,
		weberp_currencies.decimalplaces AS currdecimalplaces,
		SUM(weberp_custallocns.amt) AS totallocfrom
	FROM weberp_debtortrans INNER JOIN weberp_custallocns
	ON weberp_debtortrans.id=weberp_custallocns.transid_allocfrom
	INNER JOIN weberp_debtorsmaster ON
	weberp_debtortrans.debtorno=weberp_debtorsmaster.debtorno
	INNER JOIN weberp_currencies ON
	weberp_debtorsmaster.currcode=weberp_currencies.currabrev
	GROUP BY weberp_debtortrans.type,
		weberp_debtortrans.transno,
		weberp_debtortrans.ovamount,
		weberp_debtortrans.alloc,
		weberp_currencies.decimalplaces
	HAVING SUM(weberp_custallocns.amt) < -alloc";

$result =DB_query($sql);

if (DB_num_rows($result)>0){
	echo '<table>
		<tr>
			<td>' . _('Type') . '</td>
			<td>' . _('Trans No') . '</td>
			<td>' . _('Ov Amt') . '</td>
			<td>' . _('Allocated') . '</td>
			<td>' . _('Tot Allcns') . '</td>
		</tr>';

	$RowCounter =0;
	while ($myrow=DB_fetch_array($result)){


		printf ('<tr>
				<td>%s</td>
				<td>%s<td class="number">%s</td>
				<td class="number">%s</td>
				<td class="number">%s</td>
				</tr>',
				$myrow['type'],
				$myrow['transno'],
				locale_number_format($myrow['ovamount'],$myrow['currdecimalplaces']),
				locale_number_format($myrow['alloc'],$myrow['currdecimalplaces']),
				locale_number_format($myrow['totallocfrom'],$myrow['currdecimalplaces']));

		$RowCounter++;
		if ($RowCounter==20){
			echo '<tr><td>' . _('Type') . '</td>
				<td>' . _('Trans No') . '</td>
				<td>' . _('Ov Amt') . '</td>
				<td>' . _('Allocated') . '</td>
				<td>' . _('Tot Allcns') . '</td></tr>';
			$RowCounter=0;
		}
	}
	echo '</table>';
} else {
	prnMsg(_('There are no inconsistent allocations') . ' - ' . _('all is well'),'info');
}

include('includes/footer.inc');
?>