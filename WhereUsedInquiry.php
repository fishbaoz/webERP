<?php

/* $Id: WhereUsedInquiry.php 7093 2015-01-22 20:15:40Z vvs2012 $*/

include('includes/session.inc');
$Title = _('Where Used Inquiry');
include('includes/header.inc');

if (isset($_GET['StockID'])){
	$StockID = trim(mb_strtoupper($_GET['StockID']));
} elseif (isset($_POST['StockID'])){
	$StockID = trim(mb_strtoupper($_POST['StockID']));
}

echo '<a href="' . $RootPath . '/SelectProduct.php">' . _('Back to Items') . '</a>
	<br />
	<p class="page_title_text">
		<img src="'.$RootPath.'/css/'.$Theme.'/images/magnifier.png" title="' . _('Search') . '" alt="" />' . ' ' . $Title . '
	</p>';
if (isset($StockID)){
	$result = DB_query("SELECT description,
								units,
								mbflag
						FROM weberp_stockmaster
						WHERE stockid='".$StockID."'");
	$myrow = DB_fetch_row($result);
	if (DB_num_rows($result)==0){
		prnMsg(_('The item code entered') . ' - ' . $StockID . ' ' . _('is not set up as an item in the system') . '. ' . _('Re-enter a valid item code or select from the Select Item link above'),'error');
		include('includes/footer.inc');
		exit;
	}
	echo '<br />
		<div class="centre"><h3>' . $StockID . ' - ' . $myrow[0] . '  (' . _('in units of') . ' ' . $myrow[1] . ')</h3></div>';
}

echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '" method="post">
	<div class="centre">
		<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';

if (isset($StockID)) {
	echo _('Enter an Item Code') . ': <input type="text" required="required" data-type="no-illegal-chars" title="'._('Illegal characters and blank is not allowed').'" name="StockID" autofocus="autofocus" size="21" maxlength="20" value="' . $StockID . '" placeholder="'._('No illegal characters allowed').'" />';
} else {
	echo _('Enter an Item Code') . ': <input type="text" required="required" data-type="no-illegal-chars"  title="'._('Illegal characters and blank is not allowed').'" name="StockID" autofocus="autofocus" size="21" maxlength="20" placeholder="'._('No illegal characters allowed').'" />';
}

echo '<input type="submit" name="ShowWhereUsed" value="' . _('Show Where Used') . '" />
		<br />
	</div>';

if (isset($StockID)) {

	$SQL = "SELECT weberp_bom.*,
				weberp_stockmaster.description,
				weberp_stockmaster.discontinued
			FROM weberp_bom INNER JOIN weberp_stockmaster
			ON weberp_bom.parent = weberp_stockmaster.stockid
			INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_bom.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
			WHERE component='" . $StockID . "'
                AND weberp_bom.effectiveafter <= '" . date('Y-m-d') . "'
                AND weberp_bom.effectiveto > '" . date('Y-m-d') . "'
			ORDER BY weberp_stockmaster.discontinued, weberp_bom.parent";

	$ErrMsg = _('The parents for the selected part could not be retrieved because');;
	$result = DB_query($SQL,$ErrMsg);
	if (DB_num_rows($result)==0){
		prnMsg(_('The selected item') . ' ' . $StockID . ' ' . _('is not used as a component of any other parts'),'error');
	} else {

		echo '<table width="97%" class="selection">
				<tr>
					<th class="ascending">' . _('Used By') . '</th>
					<th class="ascending">' . _('Status') . '</th>
					<th class="ascending">' . _('Work Centre') . '</th>
					<th class="ascending">' . _('Location') . '</th>
					<th class="ascending">' . _('Quantity Required') . '</th>
					<th class="ascending">' . _('Effective After') . '</th>
					<th class="ascending">' . _('Effective To') . '</th>
				</tr>';
		$k=0;
		while ($myrow=DB_fetch_array($result)) {

			if ($k==1){
				echo '<tr class="EvenTableRows">';
				$k=0;
			} else {
				echo '<tr class="OddTableRows">';;
				$k=1;
			}
			if ($myrow['discontinued'] == 1){
				$Status = _('Obsolete');
			}else{
				$Status = _('Current');
			}
			echo '<td><a target="_blank" href="' . $RootPath . '/BOMInquiry.php?StockID=' . $myrow['parent'] . '" alt="' . _('Show Bill Of Material') . '">' . $myrow['parent']. ' - ' . $myrow['description']. '</a></td>
					<td>' . $Status. '</td>
					<td>' . $myrow['workcentreadded']. '</td>
					<td>' . $myrow['loccode']. '</td>
					<td class="number">' . locale_number_format($myrow['quantity'],'Variable') . '</td>
					<td>' . ConvertSQLDate($myrow['effectiveafter']) . '</td>
					<td>' . ConvertSQLDate($myrow['effectiveto']) . '</td>
                </tr>';

			//end of page full new headings if
		}
		echo '</table>';
	}
} // StockID is set
echo '</form>';
include('includes/footer.inc');
?>
