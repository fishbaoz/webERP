<?php
/* $Id: CustomerAccount.php 7004 2014-11-24 15:56:19Z rchacon $*/
/* Shows customer account/statement on screen rather than PDF. */

include('includes/session.inc');
$Title = _('Customer Account');// Screen identification.
$ViewTopic = 'ARInquiries';// Filename in ManualContents.php's TOC.
$BookMark = 'CustomerAccount';// Anchor's id in the manual's html document.
include('includes/header.inc');

// always figure out the SQL required from the inputs available

if (!isset($_GET['CustomerID']) and !isset($_SESSION['CustomerID'])) {
	prnMsg(_('To display the account a customer must first be selected from the customer selection screen'), 'info');
	echo '<br /><div class="centre"><a href="', $RootPath, '/SelectCustomer.php">', _('Select a Customer Account to Display'), '</a></div>';
	include('includes/footer.inc');
	exit;
} else {
	if (isset($_GET['CustomerID'])) {
		$_SESSION['CustomerID'] = stripslashes($_GET['CustomerID']);
	}
	$CustomerID = $_SESSION['CustomerID'];
}
//Check if the users have proper authority
if ($_SESSION['SalesmanLogin'] != '') {
	$ViewAllowed = false;
	$sql = "SELECT salesman FROM weberp_custbranch WHERE debtorno = '" . $CustomerID . "'";
	$ErrMsg = _('Failed to retrieve sales data');
	$result = DB_query($sql,$ErrMsg);
	if(DB_num_rows($result)>0) {
		while($myrow = DB_fetch_array($result)) {
			if ($_SESSION['SalesmanLogin'] == $myrow['salesman']) {
				$ViewAllowed = true;
			}
		}
	} else {
		prnMsg(_('There is no salesman data set for this customer'),'error');
		include('includes/footer.inc');
		exit;
	}
	if (!$ViewAllowed) {
		prnMsg(_('You have no authority to review this customer account'),'error');
		include('includes/footer.inc');
		exit;
	}
}


if (!isset($_POST['TransAfterDate'])) {
	$_POST['TransAfterDate'] = Date($_SESSION['DefaultDateFormat'], Mktime(0, 0, 0, Date('m') - $_SESSION['NumberOfMonthMustBeShown'], Date('d'), Date('Y')));
}

$Transactions = array();

/*now get all the settled transactions which were allocated this month */
$ErrMsg = _('There was a problem retrieving the transactions that were settled over the course of the last month for'). ' ' . $CustomerID . ' ' . _('from the database');
if ($_SESSION['Show_Settled_LastMonth']==1) {
	$sql = "SELECT DISTINCT weberp_debtortrans.id,
						weberp_debtortrans.type,
						weberp_systypes.typename,
						weberp_debtortrans.branchcode,
						weberp_debtortrans.reference,
						weberp_debtortrans.invtext,
						weberp_debtortrans.order_,
						weberp_debtortrans.transno,
						weberp_debtortrans.trandate,
						weberp_debtortrans.ovamount+weberp_debtortrans.ovdiscount+weberp_debtortrans.ovfreight+weberp_debtortrans.ovgst AS totalamount,
						weberp_debtortrans.alloc,
						weberp_debtortrans.ovamount+weberp_debtortrans.ovdiscount+weberp_debtortrans.ovfreight+weberp_debtortrans.ovgst-weberp_debtortrans.alloc AS balance,
						weberp_debtortrans.settled
				FROM weberp_debtortrans INNER JOIN weberp_systypes
					ON weberp_debtortrans.type=weberp_systypes.typeid
				INNER JOIN weberp_custallocns
					ON (weberp_debtortrans.id=weberp_custallocns.transid_allocfrom
						OR weberp_debtortrans.id=weberp_custallocns.transid_allocto)
				WHERE weberp_custallocns.datealloc >='" . FormatDateForSQL($_POST['TransAfterDate']) . "'
				AND weberp_debtortrans.debtorno='" . $CustomerID . "'
				AND weberp_debtortrans.settled=1
				ORDER BY weberp_debtortrans.id";

	$SetldTrans=DB_query($sql, $ErrMsg);
	$NumberOfRecordsReturned = DB_num_rows($SetldTrans);
	while ($myrow=DB_fetch_array($SetldTrans)) {
		$Transactions[] =  $myrow;
	}
} else {
	$NumberOfRecordsReturned=0;
}

/*now get all the outstanding transaction ie Settled=0 */
$ErrMsg =  _('There was a problem retrieving the outstanding transactions for') . ' ' .	$CustomerID . ' '. _('from the database') . '.';
$sql = "SELECT weberp_debtortrans.id,
			weberp_debtortrans.type,
			weberp_systypes.typename,
			weberp_debtortrans.branchcode,
			weberp_debtortrans.reference,
			weberp_debtortrans.invtext,
			weberp_debtortrans.order_,
			weberp_debtortrans.transno,
			weberp_debtortrans.trandate,
			weberp_debtortrans.ovamount+weberp_debtortrans.ovdiscount+weberp_debtortrans.ovfreight+weberp_debtortrans.ovgst as totalamount,
			weberp_debtortrans.alloc,
			weberp_debtortrans.ovamount+weberp_debtortrans.ovdiscount+weberp_debtortrans.ovfreight+weberp_debtortrans.ovgst-weberp_debtortrans.alloc as balance,
			weberp_debtortrans.settled
		FROM weberp_debtortrans INNER JOIN weberp_systypes
			ON weberp_debtortrans.type=weberp_systypes.typeid
		WHERE weberp_debtortrans.debtorno='" . $CustomerID . "'
		AND weberp_debtortrans.settled=0";

if ($_SESSION['SalesmanLogin'] != '') {
	$sql .= " AND weberp_debtortrans.salesperson='" . $_SESSION['SalesmanLogin'] . "'";
}

$sql .= " ORDER BY weberp_debtortrans.id";

$OstdgTrans=DB_query($sql, $ErrMsg);
while ($myrow=DB_fetch_array($OstdgTrans)) {
	$Transactions[] =  $myrow;
}

$NumberOfRecordsReturned += DB_num_rows($OstdgTrans);

$SQL = "SELECT weberp_debtorsmaster.name,
			weberp_debtorsmaster.address1,
			weberp_debtorsmaster.address2,
			weberp_debtorsmaster.address3,
			weberp_debtorsmaster.address4,
			weberp_debtorsmaster.address5,
			weberp_debtorsmaster.address6,
			weberp_currencies.currency,
			weberp_currencies.decimalplaces,
			weberp_paymentterms.terms,
			weberp_debtorsmaster.creditlimit,
			weberp_holdreasons.dissallowinvoices,
			weberp_holdreasons.reasondescription,
			SUM(weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight +
			weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc) AS balance,
			SUM(CASE WHEN weberp_paymentterms.daysbeforedue > 0 THEN
				CASE WHEN (TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate)) >=
				weberp_paymentterms.daysbeforedue
				THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight +
				weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
				ELSE 0 END
			ELSE
				CASE WHEN TO_DAYS(Now()) - TO_DAYS(DATE_ADD(DATE_ADD(weberp_debtortrans.trandate, " . interval('1', 'MONTH') . "), " . interval('(weberp_paymentterms.dayinfollowingmonth - DAYOFMONTH(weberp_debtortrans.trandate))','DAY') . ")) >= 0
				THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight +
				weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
				ELSE 0 END
			END) AS due,
			Sum(CASE WHEN weberp_paymentterms.daysbeforedue > 0 THEN
				CASE WHEN TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate) > weberp_paymentterms.daysbeforedue
				AND TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate) >=
				(weberp_paymentterms.daysbeforedue + " . $_SESSION['PastDueDays1'] . ")
				THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight +
				weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
				ELSE 0 END
			ELSE
				CASE WHEN (TO_DAYS(Now()) - TO_DAYS(DATE_ADD(DATE_ADD(weberp_debtortrans.trandate, " . interval('1','MONTH') . "), " . interval('(weberp_paymentterms.dayinfollowingmonth - DAYOFMONTH(weberp_debtortrans.trandate))','DAY') .")) >= " . $_SESSION['PastDueDays1'] . ")
				THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight +
				weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
				ELSE 0 END
			END) AS overdue1,
			Sum(CASE WHEN weberp_paymentterms.daysbeforedue > 0 THEN
				CASE WHEN TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate) > weberp_paymentterms.daysbeforedue
				AND TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate) >= (weberp_paymentterms.daysbeforedue +
				" . $_SESSION['PastDueDays2'] . ")
				THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight +
				weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
				ELSE 0 END
			ELSE
				CASE WHEN (TO_DAYS(Now()) - TO_DAYS(DATE_ADD(DATE_ADD(weberp_debtortrans.trandate, " . interval('1','MONTH') . "), " .
				interval('(weberp_paymentterms.dayinfollowingmonth - DAYOFMONTH(weberp_debtortrans.trandate))','DAY') . "))
				>= " . $_SESSION['PastDueDays2'] . ")
				THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight +
				weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
				ELSE 0 END
			END) AS overdue2
		FROM weberp_debtorsmaster INNER JOIN weberp_paymentterms
			ON weberp_debtorsmaster.paymentterms = weberp_paymentterms.termsindicator
		INNER JOIN weberp_currencies
			ON weberp_debtorsmaster.currcode = weberp_currencies.currabrev
		INNER JOIN weberp_holdreasons
			ON weberp_debtorsmaster.holdreason = weberp_holdreasons.reasoncode
		INNER JOIN weberp_debtortrans
			ON weberp_debtorsmaster.debtorno = weberp_debtortrans.debtorno
		WHERE
			weberp_debtorsmaster.debtorno = '" . $CustomerID . "'";

if ($_SESSION['SalesmanLogin'] != '') {
	$sql .= " AND weberp_debtortrans.salesperson='" . $_SESSION['SalesmanLogin'] . "'";
}

$SQL .= " GROUP BY
			weberp_debtorsmaster.name,
			weberp_debtorsmaster.address1,
			weberp_debtorsmaster.address2,
			weberp_debtorsmaster.address3,
			weberp_debtorsmaster.address4,
			weberp_debtorsmaster.address5,
			weberp_debtorsmaster.address6,
			weberp_currencies.decimalplaces,
			weberp_currencies.currency,
			weberp_paymentterms.terms,
			weberp_paymentterms.daysbeforedue,
			weberp_paymentterms.dayinfollowingmonth,
			weberp_debtorsmaster.creditlimit,
			weberp_holdreasons.dissallowinvoices,
			weberp_holdreasons.reasondescription";

$ErrMsg = _('The customer details could not be retrieved by the SQL because');
$CustomerResult = DB_query($SQL, $ErrMsg);

$CustomerRecord = DB_fetch_array($CustomerResult);

echo '<div class="noprint toplink">
		<a href="', $RootPath, '/SelectCustomer.php">', _('Back to Customer Screen'), '</a>
	</div>';

echo '<table width="100%">
		<tr><th colspan="2">', _('Customer Statement For'), ': ', stripslashes($CustomerID), ' - ', $CustomerRecord['name'], '</th></tr>
		<tr><td colspan="2">', $CustomerRecord['address1'], '</td></tr>';
if($CustomerRecord['address2']!='') {// If not empty, output this line.
	echo '<tr><td colspan="2">', $CustomerRecord['address2'], '</td></tr>';
}
if($CustomerRecord['address3']!='') {// If not empty, output this line.
	echo '<tr><td colspan="2">', $CustomerRecord['address3'], '</td></tr>';
}
echo '	<tr><td colspan="2">', $CustomerRecord['address4'], '</td></tr>
		<tr><td colspan="2">', $CustomerRecord['address5'], ' ', $CustomerRecord['address6'], '</td></tr>
		<tr><th>', _('All amounts stated in'), ':</th><td>', $CustomerRecord['currency'], '</td></tr>
		<tr><th>', _('Terms'), ':</th><td>', $CustomerRecord['terms'], '</th></tr>
		<tr><th>', _('Credit Limit'), ':</th><td>', locale_number_format($CustomerRecord['creditlimit'], 0), '</td></tr>
		<tr><th>', _('Credit Status'), ':</th><td>', $CustomerRecord['reasondescription'], '</td></tr>
	</table>';

if ($CustomerRecord['dissallowinvoices'] != 0) {
	echo '<br /><b><font color="red" size="4">', _('ACCOUNT ON HOLD'), '</font></b><br />';
}
echo '<br /><form onSubmit="return VerifyForm(this);" action="', htmlspecialchars($_SERVER['PHP_SELF'], ENT_QUOTES, 'UTF-8'), '" method="post" class="centre noprint">
		<input name="FormID" type="hidden" value="', $_SESSION['FormID'], '" />',
		_('Show all transactions after'), ':<input alt="', $_SESSION['DefaultDateFormat'], '" class="date" id="datepicker" maxlength="10" minlength="0" name="TransAfterDate" required="required" size="12" tabindex="1" type="text" value="', $_POST['TransAfterDate'], '" />',
		'<input name="Refresh Inquiry" tabindex="3" type="submit" value="', _('Refresh Inquiry'), '" />
	</form>';

/* Show a table of the invoices returned by the SQL. */

echo '<br /><table class="selection">
	<thead>
		<tr>
			<th class="ascending">', _('Type'), '</th>
			<th class="ascending">', _('Number'), '</th>
			<th class="ascending">', _('Date'), '</th>
			<th>', _('Branch'), '</th>
			<th class="ascending">', _('Reference'), '</th>
			<th>', _('Comments'), '</th>
			<th>', _('Order'), '</th>
			<th>', _('Charges'), '</th>
			<th>', _('Credits'), '</th>
			<th>', _('Allocated'), '</th>
			<th>', _('Balance'), '</th>
			<th class="noprint" colspan="4">&nbsp;</th>
		</tr>
	</thead><tbody>';

$k = 0; //row colour counter
$OutstandingOrSettled = '';
if ($_SESSION['InvoicePortraitFormat'] == 1) { //Invoice/credits in portrait
	$PrintCustomerTransactionScript = 'PrintCustTransPortrait.php';
} else { //produce pdfs in landscape
	$PrintCustomerTransactionScript = 'PrintCustTrans.php';
}
foreach ($Transactions as $MyRow) {

	if ($MyRow['settled']==1 AND $OutstandingOrSettled=='') {
		echo '<tr><th colspan="11">', _('TRANSACTIONS SETTLED SINCE'), ' ', $_POST['TransAfterDate'], '</th><th class="noprint" colspan="4">&nbsp;</th></tr>';
		$OutstandingOrSettled='Settled';
	} elseif (($OutstandingOrSettled=='Settled' OR $OutstandingOrSettled=='') AND $MyRow['settled']==0) {
		echo '<tr><th colspan="11">', _('OUTSTANDING TRANSACTIONS'), ' ', $_POST['TransAfterDate'], '</th><th class="noprint" colspan="4">&nbsp;</th></tr>';
		$OutstandingOrSettled='Outstanding';
	}

	if ($k == 1) {
		echo '<tr class="EvenTableRows">';
		$k = 0;
	} else {
		echo '<tr class="OddTableRows">';
		$k = 1;
	}


	$FormatedTranDate = ConvertSQLDate($MyRow['trandate']);


	if ($MyRow['type']==10) { //its an invoice
		echo '<td>', _($MyRow['typename']), '</td>
			<td class="number">', $MyRow['transno'], '</td>
			<td>', ConvertSQLDate($MyRow['trandate']), '</td>
			<td>', $MyRow['branchcode'], '</td>
			<td>', $MyRow['reference'], '</td>
			<td style="width:200px">', $MyRow['invtext'], '</td>
			<td class="number">', $MyRow['order_'], '</td>
			<td class="number">', locale_number_format($MyRow['totalamount'], $CustomerRecord['decimalplaces']), '</td>
			<td>&nbsp;</td>
			<td class="number">', locale_number_format($MyRow['alloc'], $CustomerRecord['decimalplaces']), '</td>
			<td class="number">', locale_number_format($MyRow['balance'], $CustomerRecord['decimalplaces']), '</td>
			<td class="noprint" title="', _('Click to preview the invoice'), '">
				<a href="', $RootPath, '/PrintCustTrans.php?FromTransNo=', $MyRow['transno'], '&amp;InvOrCredit=Invoice"><img alt="" src="', $RootPath, '/css/', $Theme, '/images/preview.png" /> ', _('HTML'), '</a>
			</td>
			<td class="noprint" title="', _('Click for PDF'), '">
				<a href="', $RootPath, '/', $PrintCustomerTransactionScript, '?FromTransNo=', $MyRow['transno'], '&amp;InvOrCredit=Invoice&amp;PrintPDF=True"><img alt="" src="', $RootPath, '/css/', $Theme, '/images/pdf.png" /> ', _('PDF'), '</a>
			</td>
			<td class="noprint" title="', _('Click to email the invoice'), '">
				<a href="', $RootPath, '/EmailCustTrans.php?FromTransNo=', $MyRow['transno'], '&amp;InvOrCredit=Invoice"><img alt="" src="', $RootPath, '/css/', $Theme, '/images/email.png" />', _('Email'), '</a>
			</td>
			<td class="noprint">&nbsp;</td>
		</tr>';

	} elseif ($MyRow['type'] == 11) {
		echo '<td>', _($MyRow['typename']), '</td>
				<td class="number">', $MyRow['transno'], '</td>
				<td>', ConvertSQLDate($MyRow['trandate']), '</td>
				<td>', $MyRow['branchcode'], '</td>
				<td>', $MyRow['reference'], '</td>
				<td style="width:200px">', $MyRow['invtext'], '</td>
				<td class="number">', $MyRow['order_'], '</td>
				<td>&nbsp;</td>
				<td class="number">', locale_number_format($MyRow['totalamount'], $CustomerRecord['decimalplaces']), '</td>
				<td class="number">', locale_number_format($MyRow['alloc'], $CustomerRecord['decimalplaces']), '</td>
				<td class="number">', locale_number_format($MyRow['balance'], $CustomerRecord['decimalplaces']), '</td>
				<td class="noprint" title="', _('Click to preview the credit note'), '">
					<a href="', $RootPath, '/PrintCustTrans.php?FromTransNo=', $MyRow['transno'], '&amp;InvOrCredit=Credit"><img alt="" src="', $RootPath, '/css/', $Theme, '/images/preview.png" />', _('HTML'), '</a>
				</td>
				<td class="noprint" title="', _('Click for PDF'), '">
					<a href="', $RootPath, '/', $PrintCustomerTransactionScript, '?FromTransNo=', $MyRow['transno'], '&amp;InvOrCredit=Credit&amp;PrintPDF=True"><img alt="" src="', $RootPath, '/css/', $Theme, '/images/pdf.png" />', _('PDF'), '</a>
				</td>
				<td class="noprint" title="', _('Click to email the credit note'), '">
					<a href="', $RootPath, '/EmailCustTrans.php?FromTransNo=', $MyRow['transno'], '&amp;InvOrCredit=Credit"><img alt="" src="', $RootPath, '/css/', $Theme, '/images/email.png" />', _('Email'), '</a>
				</td>
				<td class="noprint" title="', _('Click to allocate funds'), '">
					<a href="', $RootPath, '/CustomerAllocations.php?AllocTrans=', $MyRow['id'], '"><img alt="" src="', $RootPath, '/css/', $Theme, '/images/allocation.png" />', _('Allocation'), '</a>
				</td>
			</tr>';

	} elseif ($MyRow['type'] == 12 and $MyRow['totalamount'] < 0) {
		/* Show transactions where:
		 * - Is receipt
		 */
		echo '<td>', _($MyRow['typename']), '</td>
				<td class="number">', $MyRow['transno'], '</td>
				<td>', ConvertSQLDate($MyRow['trandate']), '</td>
				<td>', $MyRow['branchcode'], '</td>
				<td>', $MyRow['reference'], '</td>
				<td style="width:200px">', $MyRow['invtext'], '</td>
				<td class="number">', $MyRow['order_'], '</td>
				<td>&nbsp;</td>
				<td class="number">', locale_number_format($MyRow['totalamount'], $CustomerRecord['decimalplaces']), '</td>
				<td class="number">', locale_number_format($MyRow['alloc'], $CustomerRecord['decimalplaces']), '</td>
				<td class="number">', locale_number_format($MyRow['balance'], $CustomerRecord['decimalplaces']), '</td>
				<td class="noprint" title="', _('Click to allocate funds'), '">
					<a href="', $RootPath, '/CustomerAllocations.php?AllocTrans=', $MyRow['id'], '"><img alt="" src="', $RootPath, '/css/', $Theme, '/images/allocation.png" />', _('Allocation'), '</a>
				</td>
				<td class="noprint">&nbsp;</td>
				<td class="noprint">&nbsp;</td>
				<td class="noprint">&nbsp;</td>
			</tr>';

	} elseif ($MyRow['type'] == 12 and $MyRow['totalamount'] > 0) {
		/* Show transactions where:
		* - Is a negative receipt
		* - User cannot view GL transactions
		*/
		echo '<td>', _($MyRow['typename']), '</td>
				<td class="number">', $MyRow['transno'], '</td>
				<td>', ConvertSQLDate($MyRow['trandate']), '</td>
				<td>', $MyRow['branchcode'], '</td>
				<td>', $MyRow['reference'], '</td>
				<td style="width:200px">', $MyRow['invtext'], '</td>
				<td class="number">', $MyRow['order_'], '</td>
				<td class="number">', locale_number_format($MyRow['totalamount'], $CustomerRecord['decimalplaces']), '</td>
				<td>&nbsp;</td>
				<td class="number">', locale_number_format($MyRow['alloc'], $CustomerRecord['decimalplaces']), '</td>
				<td class="number">', locale_number_format($MyRow['balance'], $CustomerRecord['decimalplaces']), '</td>
				<td class="noprint">&nbsp;</td>
				<td class="noprint">&nbsp;</td>
				<td class="noprint">&nbsp;</td>
				<td class="noprint">&nbsp;</td>
			</tr>';
	}
}
//end of while loop

echo '</tbody></table>
	<br />
	<table class="selection" width="70%">
		<tr>
			<th style="width:20%">', _('Total Balance'), '</th>
			<th style="width:20%">', _('Current'), '</th>
			<th style="width:20%">', _('Now Due'), '</th>
			<th style="width:20%">', $_SESSION['PastDueDays1'], '-', $_SESSION['PastDueDays2'], ' ', _('Days Overdue'), '</th>
			<th style="width:20%">', _('Over'), ' ', $_SESSION['PastDueDays2'], ' ', _('Days Overdue'), '</th>
		</tr>
		<tr>
			<td class="number">', locale_number_format($CustomerRecord['balance'], $CustomerRecord['decimalplaces']), '</td>
			<td class="number">', locale_number_format(($CustomerRecord['balance'] - $CustomerRecord['due']), $CustomerRecord['decimalplaces']), '</td>
			<td class="number">', locale_number_format(($CustomerRecord['due'] - $CustomerRecord['overdue1']), $CustomerRecord['decimalplaces']), '</td>
			<td class="number">', locale_number_format(($CustomerRecord['overdue1'] - $CustomerRecord['overdue2']), $CustomerRecord['decimalplaces']), '</td>
			<td class="number">', locale_number_format($CustomerRecord['overdue2'], $CustomerRecord['decimalplaces']), '</td>
		</tr>
	</table>';

include('includes/footer.inc');
?>