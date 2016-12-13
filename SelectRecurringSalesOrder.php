<?php
/* $Id: SelectRecurringSalesOrder.php 6941 2014-10-26 23:18:08Z daintree $*/

include('includes/session.inc');
$Title = _('Search Recurring Sales Orders');
/* webERP manual links before header.inc */
$ViewTopic= 'SalesOrders';
$BookMark = 'RecurringSalesOrders';

include('includes/header.inc');

echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '" method="post">';
echo '<div>';
echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';
echo '<p class="page_title_text"><img src="' . $RootPath . '/css/' . $Theme . '/images/customer.png" title="' .
	_('Inventory Items') . '" alt="" />' . ' ' . $Title . '</p>';

echo '<table class="selection">
		<tr>
			<td>' . _('Select recurring order templates for delivery from:') . ' </td>
			<td>' . '<select name="StockLocation">';

$sql = "SELECT weberp_locations.loccode, locationname FROM weberp_locations INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locations.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1";

$resultStkLocs = DB_query($sql);

while ($myrow=DB_fetch_array($resultStkLocs)){
	if (isset($_POST['StockLocation'])){
		if ($myrow['loccode'] == $_POST['StockLocation']){
			echo '<option selected="selected" value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
		} else {
			echo '<option value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
		}
	} elseif ($myrow['loccode']==$_SESSION['UserStockLocation']){
			echo '<option selected="selected" value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
	} else {
			echo '<option value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
	}
}

echo '</select></td>
	</tr>
	</table>';

echo '<br /><div class="centre"><input type="submit" name="SearchRecurringOrders" value="' . _('Search Recurring Orders') . '" /></div>';

if (isset($_POST['SearchRecurringOrders'])){

	$SQL = "SELECT weberp_recurringsalesorders.recurrorderno,
				weberp_debtorsmaster.name,
				weberp_currencies.decimalplaces AS currdecimalplaces,
				weberp_custbranch.brname,
				weberp_recurringsalesorders.customerref,
				weberp_recurringsalesorders.orddate,
				weberp_recurringsalesorders.deliverto,
				weberp_recurringsalesorders.lastrecurrence,
				weberp_recurringsalesorders.stopdate,
				weberp_recurringsalesorders.frequency,
SUM(weberp_recurrsalesorderdetails.unitprice*weberp_recurrsalesorderdetails.quantity*(1-weberp_recurrsalesorderdetails.discountpercent)) AS ordervalue
			FROM weberp_recurringsalesorders INNER JOIN weberp_recurrsalesorderdetails
			ON weberp_recurringsalesorders.recurrorderno = weberp_recurrsalesorderdetails.recurrorderno
			INNER JOIN weberp_debtorsmaster
			ON weberp_recurringsalesorders.debtorno = weberp_debtorsmaster.debtorno
			INNER JOIN weberp_custbranch
			ON weberp_debtorsmaster.debtorno = weberp_custbranch.debtorno
			AND weberp_recurringsalesorders.branchcode = weberp_custbranch.branchcode
			INNER JOIN weberp_currencies
			ON weberp_debtorsmaster.currcode=weberp_currencies.currabrev
			WHERE weberp_recurringsalesorders.fromstkloc = '". $_POST['StockLocation'] . "'
			GROUP BY weberp_recurringsalesorders.recurrorderno,
				weberp_debtorsmaster.name,
				weberp_currencies.decimalplaces,
				weberp_custbranch.brname,
				weberp_recurringsalesorders.customerref,
				weberp_recurringsalesorders.orddate,
				weberp_recurringsalesorders.deliverto,
				weberp_recurringsalesorders.lastrecurrence,
				weberp_recurringsalesorders.stopdate,
				weberp_recurringsalesorders.frequency";

	$ErrMsg = _('No recurring orders were returned by the SQL because');
	$SalesOrdersResult = DB_query($SQL,$ErrMsg);

	/*show a table of the orders returned by the SQL */

	echo '<br />
		<table cellpadding="2" width="90%" class="selection">';

	$tableheader = '<tr>
						<th>' . _('Modify') . '</th>
						<th>' . _('Customer') . '</th>
						<th>' . _('Branch') . '</th>
						<th>' . _('Cust Order') . ' #</th>
						<th>' . _('Last Recurrence') . '</th>
						<th>' . _('End Date') . '</th>
						<th>' . _('Times p.a.') . '</th>
						<th>' . _('Order Total') . '</th>
					</tr>';

	echo $tableheader;

	$j = 1;
	$k=0; //row colour counter
	while ($myrow=DB_fetch_array($SalesOrdersResult)) {


		if ($k==1){
			echo '<tr class="EvenTableRows">';
			$k=0;
		} else {
			echo '<tr class="OddTableRows">';;
			$k++;
		}

		$ModifyPage = $RootPath . '/RecurringSalesOrders.php?ModifyRecurringSalesOrder=' . $myrow['recurrorderno'];
		$FormatedLastRecurrence = ConvertSQLDate($myrow['lastrecurrence']);
		$FormatedStopDate = ConvertSQLDate($myrow['stopdate']);
		$FormatedOrderValue = locale_number_format($myrow['ordervalue'],$myrow['currdecimalplaces']);

		printf('<td><a href="%s">%s</a></td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td class="number">%s</td>
				</tr>',
				$ModifyPage,
				$myrow['recurrorderno'],
				$myrow['name'],
				$myrow['brname'],
				$myrow['customerref'],
				$FormatedLastRecurrence,
				$FormatedStopDate,
				$myrow['frequency'],
				$FormatedOrderValue);

		$j++;
		If ($j == 12){
			$j=1;
			echo $tableheader;
		}
	//end of page full new headings if
	}
	//end of while loop

	echo '</table>';
}
echo '</div>
      </form>';

include('includes/footer.inc');
?>