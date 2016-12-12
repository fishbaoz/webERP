<?php

/* $Id: StockMovements.php 7329 2015-07-28 01:00:01Z tehonu $*/

include('includes/session.inc');
$Title = _('Stock Movements');
/* webERP manual links before header.inc */
$ViewTopic= "Inventory";
$BookMark = "InventoryMovement";
include('includes/header.inc');

if (isset($_GET['StockID'])){
	$StockID = trim(mb_strtoupper($_GET['StockID']));
} elseif (isset($_POST['StockID'])){
	$StockID = trim(mb_strtoupper($_POST['StockID']));
} else {
	$StockID = '';
}

$result = DB_query("SELECT description, units FROM weberp_stockmaster WHERE stockid='".$StockID."'");
$myrow = DB_fetch_row($result);
echo '<p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/inventory.png" title="' . _('Inventory') . '" alt="" /><b>' . ' ' . $StockID . ' - ' . $myrow['0'] . ' : ' . _('in units of') . ' : ' . $myrow[1] . '</b></p>';

echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '" method="post">';
echo '<div>';
echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';

if (!isset($_POST['BeforeDate']) OR !Is_Date($_POST['BeforeDate'])){
   $_POST['BeforeDate'] = Date($_SESSION['DefaultDateFormat']);
}
if (!isset($_POST['AfterDate']) OR !Is_Date($_POST['AfterDate'])){
   $_POST['AfterDate'] = Date($_SESSION['DefaultDateFormat'], Mktime(0,0,0,Date('m')-3,Date('d'),Date('y')));
}
echo '<br />
		<table class="selection">';
echo '<tr><th colspan="10">' . _('Stock Code') . ':<input type="text" name="StockID" size="21" value="' . $StockID . '" maxlength="20" />';

echo '  ' . _('From Stock Location') . ':<select name="StockLocation"> ';

$sql = "SELECT weberp_locations.loccode, locationname FROM weberp_locations
		INNER JOIN weberp_locationusers 
			ON weberp_locationusers.loccode=weberp_locations.loccode 
				AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' 
				AND weberp_locationusers.canview=1
		ORDER BY locationname
		";
$resultStkLocs = DB_query($sql);

while ($myrow=DB_fetch_array($resultStkLocs)){
	if (isset($_POST['StockLocation']) AND $_POST['StockLocation']!='All'){
		if ($myrow['loccode'] == $_POST['StockLocation']){
		     echo '<option selected="selected" value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
		} else {
		     echo '<option value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
		}
	} elseif ($myrow['loccode']==$_SESSION['UserStockLocation']){
		 echo '<option selected="selected" value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
		 $_POST['StockLocation']=$myrow['loccode'];
	} else {
		 echo '<option value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
	}
}

echo '</select></th>
	</tr>';
echo '<tr>
		<th colspan="10">' . _('Show Movements between') . ': <input type="text" name="AfterDate" class="date" alt="'.$_SESSION['DefaultDateFormat'].'" size="12" maxlength="12" value="' . $_POST['AfterDate'] . '" /> ' . _('and') . ': <input type="text" name="BeforeDate" class="date" alt="'.$_SESSION['DefaultDateFormat'].'" size="12" maxlength="12" value="' . $_POST['BeforeDate'] . '" /><input type="submit" name="ShowMoves" value="' . _('Show Stock Movements') . '" /></th>
	</tr>';

$SQLBeforeDate = FormatDateForSQL($_POST['BeforeDate']);
$SQLAfterDate = FormatDateForSQL($_POST['AfterDate']);

$sql = "SELECT weberp_stockmoves.stockid,
				weberp_systypes.typename,
				weberp_stockmoves.type,
				weberp_stockmoves.transno,
				weberp_stockmoves.trandate,
				weberp_stockmoves.userid,
				weberp_stockmoves.debtorno,
				weberp_stockmoves.branchcode,
				weberp_stockmoves.qty,
				weberp_stockmoves.reference,
				weberp_stockmoves.price,
				weberp_stockmoves.discountpercent,
				weberp_stockmoves.newqoh,
				weberp_stockmaster.decimalplaces
		FROM weberp_stockmoves
		INNER JOIN weberp_systypes ON weberp_stockmoves.type=weberp_systypes.typeid
		INNER JOIN weberp_stockmaster ON weberp_stockmoves.stockid=weberp_stockmaster.stockid
		WHERE  weberp_stockmoves.loccode='" . $_POST['StockLocation'] . "'
		AND weberp_stockmoves.trandate >= '". $SQLAfterDate . "'
		AND weberp_stockmoves.stockid = '" . $StockID . "'
		AND weberp_stockmoves.trandate <= '" . $SQLBeforeDate . "'
		AND hidemovt=0
		ORDER BY stkmoveno DESC";

$ErrMsg = _('The stock movements for the selected criteria could not be retrieved because') . ' - ';
$DbgMsg = _('The SQL that failed was') . ' ';

$MovtsResult = DB_query($sql, $ErrMsg, $DbgMsg);

$tableheader = '<tr>
					<th>' . _('Type') . '</th>
					<th>' . _('Number') . '</th>
					<th>' . _('Date') . '</th>
					<th>' . _('User ID') . '</th>
					<th>' . _('Customer') . '</th>
					<th>' . _('Branch') . '</th>
					<th>' . _('Quantity') . '</th>
					<th>' . _('Reference') . '</th>
					<th>' . _('Price') . '</th>
					<th>' . _('Discount') . '</th>
					<th>' . _('New Qty') . '</th>
				</tr>';

echo $tableheader;

$j = 1;
$k=0; //row colour counter

while ($myrow=DB_fetch_array($MovtsResult)) {

	if ($k==1){
		echo '<tr class="EvenTableRows">';
		$k=0;
	} else {
		echo '<tr class="OddTableRows">';
		$k=1;
	}

	$DisplayTranDate = ConvertSQLDate($myrow['trandate']);

	if ($myrow['type']==10){ /*its a sales invoice allow link to show invoice it was sold on*/

		printf('<td><a target="_blank" href="%s/PrintCustTrans.php?FromTransNo=%s&amp;InvOrCredit=Invoice">%s</a></td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td class="number">%s</td>
				<td>%s</td>
				<td class="number">%s</td>
				<td class="number">%s%%</td>
				<td class="number">%s</td>
				</tr>',
				$RootPath,
				$myrow['transno'],
				$myrow['typename'],
				$myrow['transno'],
				$DisplayTranDate,
				$myrow['userid'],
				$myrow['debtorno'],
				$myrow['branchcode'],
				locale_number_format($myrow['qty'],$myrow['decimalplaces']),
				$myrow['reference'],
				locale_number_format($myrow['price'],$_SESSION['CompanyRecord']['decimalplaces']),
				locale_number_format($myrow['discountpercent']*100,2),
				locale_number_format($myrow['newqoh'],$myrow['decimalplaces']));

	} elseif ($myrow['type']==11){

		printf('<td><a target="_blank" href="%s/PrintCustTrans.php?FromTransNo=%s&amp;InvOrCredit=Credit">%s</a></td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td class="number">%s</td>
				<td>%s</td>
				<td class="number">%s</td>
				<td class="number">%s%%</td>
				<td class="number">%s</td>
				</tr>',
				$RootPath,
				$myrow['transno'],
				$myrow['typename'],
				$myrow['transno'],
				$DisplayTranDate,
				$myrow['userid'],
				$myrow['debtorno'],
				$myrow['branchcode'],
				locale_number_format($myrow['qty'],$myrow['decimalplaces']),
				$myrow['reference'],
				locale_number_format($myrow['price'],$_SESSION['CompanyRecord']['decimalplaces']),
				locale_number_format($myrow['discountpercent']*100,2),
				locale_number_format($myrow['newqoh'],$myrow['decimalplaces']));
	} else {

		printf('<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td class="number">%s</td>
				<td>%s</td>
				<td class="number">%s</td>
				<td class="number">%s%%</td>
				<td class="number">%s</td>
				</tr>',
				$myrow['typename'],
				$myrow['transno'],
				$DisplayTranDate,
				$myrow['userid'],
				$myrow['debtorno'],
				$myrow['branchcode'],
				locale_number_format($myrow['qty'],$myrow['decimalplaces']),
				$myrow['reference'],
				locale_number_format($myrow['price'],$_SESSION['CompanyRecord']['decimalplaces']),
				locale_number_format($myrow['discountpercent']*100,2),
				locale_number_format($myrow['newqoh'],$myrow['decimalplaces']));
	}
//end of page full new headings if
}
//end of while loop

echo '</table>';
echo '<div class="centre"><br /><a href="' . $RootPath . '/StockStatus.php?StockID=' . $StockID . '">' . _('Show Stock Status') . '</a>';
echo '<br /><a href="' . $RootPath . '/StockUsage.php?StockID=' . $StockID . '&amp;StockLocation=' . $_POST['StockLocation'] . '">' . _('Show Stock Usage') . '</a>';
echo '<br /><a href="' . $RootPath . '/SelectSalesOrder.php?SelectedStockItem=' . $StockID . '&amp;StockLocation=' . $_POST['StockLocation'] . '">' . _('Search Outstanding Sales Orders') . '</a>';
echo '<br /><a href="' . $RootPath . '/SelectCompletedOrder.php?SelectedStockItem=' . $StockID . '">' . _('Search Completed Sales Orders') . '</a>';

echo '</div>
      </div>
      </form>';

include('includes/footer.inc');

?>
