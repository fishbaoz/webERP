<?php
/* $Id: StockLocMovements.php 6941 2014-10-26 23:18:08Z daintree $*/

include('includes/session.inc');

$Title = _('All Stock Movements By Location');

include('includes/header.inc');

echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '" method="post">';
echo '<div>';
echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';

echo '<p class="page_title_text"><img src="' . $RootPath . '/css/' . $Theme . '/images/magnifier.png" title="' . _('Search') .
	'" alt="" />' . ' ' . $Title . '</p>';

echo '<table class="selection">
     <tr>
         <td>  ' . _('From Stock Location') . ':<select name="StockLocation"> ';

$sql = "SELECT weberp_locations.loccode, locationname FROM weberp_locations
			INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locations.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1";
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

echo '</select>';

if (!isset($_POST['BeforeDate']) OR !Is_Date($_POST['BeforeDate'])){
   $_POST['BeforeDate'] = Date($_SESSION['DefaultDateFormat']);
}
if (!isset($_POST['AfterDate']) OR !Is_Date($_POST['AfterDate'])){
   $_POST['AfterDate'] = Date($_SESSION['DefaultDateFormat'], Mktime(0,0,0,Date('m')-1,Date('d'),Date('y')));
}
echo ' ' . _('Show Movements before') . ': <input type="text" name="BeforeDate" size="12" maxlength="12" value="' . $_POST['BeforeDate'] . '" />';
echo ' ' . _('But after') . ': <input type="text" name="AfterDate" size="12" maxlength="12" value="' . $_POST['AfterDate'] . '" />';
echo '</td>
     </tr>
     </table>
     <br />';
echo '<div class="centre">
           <input type="submit" name="ShowMoves" value="' . _('Show Stock Movements') . '" />
     </div>
     <br />';


$SQLBeforeDate = FormatDateForSQL($_POST['BeforeDate']);
$SQLAfterDate = FormatDateForSQL($_POST['AfterDate']);

$sql = "SELECT weberp_stockmoves.stockid,
        		weberp_systypes.typename,
        		weberp_stockmoves.type,
        		weberp_stockmoves.transno,
        		weberp_stockmoves.trandate,
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
        	AND weberp_stockmoves.trandate <= '" . $SQLBeforeDate . "'
        	AND hidemovt=0
        	ORDER BY stkmoveno DESC";

$ErrMsg = _('The stock movements for the selected criteria could not be retrieved because');
$MovtsResult = DB_query($sql,$ErrMsg);

echo '<table cellpadding="5" cellspacing="4 "class="selection">';
$tableheader = '<tr>
            		<th>' . _('Item Code') . '</th>
            		<th>' . _('Type') . '</th>
            		<th>' . _('Trans No') . '</th>
            		<th>' . _('Date') . '</th>
            		<th>' . _('Customer') . '</th>
            		<th>' . _('Quantity') . '</th>
            		<th>' . _('Reference') . '</th>
            		<th>' . _('Price') . '</th>
            		<th>' . _('Discount') . '</th>
            		<th>' . _('Quantity on Hand') . '</th>
           		</tr>';
echo $tableheader;

$j = 1;
$k=0; //row colour counter

while ($myrow=DB_fetch_array($MovtsResult)) {

	if ($k==1){
		echo '<tr class="OddTableRows">';
		$k=0;
	} else {
		echo '<tr class="EvenTableRows">';
		$k=1;
	}

	$DisplayTranDate = ConvertSQLDate($myrow['trandate']);


		printf('<td><a target="_blank" href="' . $RootPath . '/StockStatus.php?StockID=%s">%s</a></td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td class="number">%s</td>
				<td>%s</td>
				<td class="number">%s</td>
				<td class="number">%s</td>
				<td class="number">%s</td>
				</tr>',
				mb_strtoupper($myrow['stockid']),
				mb_strtoupper($myrow['stockid']),
				$myrow['typename'],
				$myrow['transno'],
				$DisplayTranDate,
				$myrow['debtorno'],
				locale_number_format($myrow['qty'],
				$myrow['decimalplaces']),
				$myrow['reference'],
				locale_number_format($myrow['price'],$_SESSION['CompanyRecord']['decimalplaces']),
				locale_number_format($myrow['discountpercent']*100,2),
				locale_number_format($myrow['newqoh'],$myrow['decimalplaces']));
	$j++;
	If ($j == 16){
		$j=1;
		echo $tableheader;
	}
//end of page full new headings if
}
//end of while loop

echo '</table>';
echo '</div>
      </form>';

include('includes/footer.inc');

?>