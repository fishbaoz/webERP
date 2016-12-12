<?php
/* $Id: Z_CheckGLTransBalance.php 7564 2016-07-03 06:58:29Z daintree $*/

include('includes/session.inc');
$Title=_('Check Period Sales Ledger Control Account');
include('includes/header.inc');

echo '<table>';

$Header = '<tr>
			<th>' . _('Type') . '</th>
			<th>' . _('Number') . '</th>
			<th>' . _('Period') . '</th>
			<th>' . _('Difference') . '</th>
		</tr>';

echo $Header;

$sql = "SELECT weberp_gltrans.type,
			weberp_systypes.typename,
			weberp_gltrans.typeno,
			periodno,
			SUM(amount) AS nettot
		FROM weberp_gltrans
			INNER JOIN weberp_chartmaster ON
			weberp_gltrans.account=weberp_chartmaster.accountcode
			INNER JOIN weberp_systypes ON weberp_gltrans.type = weberp_systypes.typeid
		GROUP BY weberp_gltrans.type,
			weberp_systypes.typename,
			typeno,
			periodno
		HAVING ABS(SUM(amount))>= " . 1/pow(10,$_SESSION['CompanyRecord']['decimalplaces']) . "
		ORDER BY weberp_gltrans.counterindex";

$OutOfWackResult = DB_query($sql);


$RowCounter =0;

while ($OutOfWackRow = DB_fetch_array($OutOfWackResult)){

	if ($RowCounter==18){
		$RowCounter=0;
		echo $Header;
	} else {
		$RowCounter++;
	}
	echo '<tr>
	<td><a href="' . $RootPath . '/GLTransInquiry.php?TypeID=' . $OutOfWackRow['type'] . '&TransNo=' . $OutOfWackRow['typeno'] . '">' . $OutOfWackRow['typename'] . '</a></td>
	<td class="number">' . $OutOfWackRow['typeno'] . '</td>
	<td class="number">' . $OutOfWackRow['periodno'] . '</td>
	<td class="number">' . locale_number_format($OutOfWackRow['nettot'],$_SESSION['CompanyRecord']['decimalplaces']) . '</td>
	</tr>';

}
echo '</table>';

include('includes/footer.inc');
?>