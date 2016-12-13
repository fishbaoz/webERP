<?php
/* $Id: Dashboard.php 6843 2014-08-20 06:04:47Z daintree $*/
/* Display outstanding debtors, creditors, etc */

include('includes/session.inc');
$Title = _('Dashboard');
$ViewTopic = 'GeneralLedger';// RChacon: You should be in this topic ?
$BookMark = 'Dashboard';
include('includes/header.inc');

echo '<p class="page_title_text"><img alt="" src="', $RootPath, '/css/', $Theme,
	'/images/gl.png" title="',// Icon image.
	$Title, '" /> ',// Icon title.
	$Title, '</p>';// Page title.

$Sql = "SELECT pagesecurity
		FROM weberp_scripts
		WHERE weberp_scripts.script = 'AgedDebtors.php'";
$ErrMsg = _('The security for Aging Debtors cannot be retrieved because');
$DbgMsg = _('The SQL that was used and failed was');
$Security1Result = DB_query($Sql, $ErrMsg, $DbgMsg);
$MyUserRow = DB_fetch_array($Security1Result);
$DebtorSecurity = $MyUserRow['pagesecurity'];

$Sql = "SELECT pagesecurity
		FROM weberp_scripts
		WHERE weberp_scripts.script = 'SuppPaymentRun.php'";
$ErrMsg = _('The security for upcoming payments cannot be retrieved because');
$DbgMsg = _('The SQL that was used and failed was');
$Security2Result = DB_query($Sql, $ErrMsg, $DbgMsg);
$MyUserRow = DB_fetch_array($Security2Result);
$PayeeSecurity = $MyUserRow['pagesecurity'];

$Sql = "SELECT pagesecurity
		FROM weberp_scripts
		WHERE weberp_scripts.script = 'GLAccountInquiry.php'";
$ErrMsg = _('The security for G/L Accounts cannot be retrieved because');
$DbgMsg = _('The SQL that was used and failed was');
$Security2Result = DB_query($Sql, $ErrMsg, $DbgMsg);
$MyUserRow = DB_fetch_array($Security2Result);
$CashSecurity = $MyUserRow['pagesecurity'];

$Sql = "SELECT pagesecurity
		FROM weberp_scripts
		WHERE weberp_scripts.script = 'SelectSalesOrder.php'";
$ErrMsg = _('The security for Aging Debtors cannot be retrieved because');
$DbgMsg = _('The SQL that was used and failed was');
$Security1Result = DB_query($Sql, $ErrMsg, $DbgMsg);
$MyUserRow = DB_fetch_array($Security1Result);
$OrderSecurity = $MyUserRow['pagesecurity'];

if(in_array($DebtorSecurity, $_SESSION['AllowedPageSecurityTokens']) OR !isset($DebtorSecurity)) {
	echo '<br />
		<h2>', _('Overdue Customer Balances'), '</h2>
		<table class="selection">
		<thead>
			<tr>
				<th>', _('Customer'), '</th>
				<th>', _('Reference'), '</th>
				<th>', _('Trans Date'), '</th>
				<th>', _('Due Date'), '</th>
				<th>', _('Balance'), '</th>
				<th>', _('Current'), '</th>
				<th>', _('Due Now'), '</th>
				<th>', '> ', $_SESSION['PastDueDays1'], ' ', _('Days Over'), '</th>
				<th>', '> ', $_SESSION['PastDueDays2'], ' ', _('Days Over'), '</th>
			</tr>
		</thead><tbody>';
	$j = 1;
	$k = 0;// Row colour counter.
	$TotBal = 0;
	$TotCurr = 0;
	$TotDue = 0;
	$TotOD1 = 0;
	$TotOD2 = 0;
	$CurrDecimalPlaces = 2;//By default.

	if(!isset($_POST['Salesman'])) {
		$_POST['Salesman'] = '';
	}
	if($_SESSION['SalesmanLogin'] != '') {
		$_POST['Salesman'] = $_SESSION['SalesmanLogin'];
	}
	if(trim($_POST['Salesman']) != '') {
		$SalesLimit = " AND weberp_debtorsmaster.debtorno IN (SELECT DISTINCT debtorno FROM weberp_custbranch WHERE salesman = '".$_POST['Salesman']."') ";
	} else {
		$SalesLimit = '';
	}
	$Sql = "SELECT weberp_debtorsmaster.debtorno,
				weberp_debtorsmaster.name,
				weberp_currencies.currency,
				weberp_currencies.decimalplaces,
				weberp_paymentterms.terms,
				weberp_debtorsmaster.creditlimit,
				weberp_holdreasons.dissallowinvoices,
				weberp_holdreasons.reasondescription,
				SUM(
					weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
				) AS balance,
				SUM(
					CASE WHEN (weberp_paymentterms.daysbeforedue > 0)
					THEN
						CASE WHEN (TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate)) >= weberp_paymentterms.daysbeforedue
						THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
						ELSE 0 END
					ELSE
						CASE WHEN TO_DAYS(Now()) - TO_DAYS(ADDDATE(last_day(weberp_debtortrans.trandate), weberp_paymentterms.dayinfollowingmonth)) >= 0
						THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc ELSE 0 END
					END
				) AS due,
				SUM(
					CASE WHEN (weberp_paymentterms.daysbeforedue > 0)
					THEN
						CASE WHEN (TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate)) > weberp_paymentterms.daysbeforedue AND TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate) >= (weberp_paymentterms.daysbeforedue + " . $_SESSION['PastDueDays1'] . ")
						THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc ELSE 0 END
					ELSE
						CASE WHEN TO_DAYS(Now()) - TO_DAYS(ADDDATE(last_day(weberp_debtortrans.trandate), weberp_paymentterms.dayinfollowingmonth)) >= " . $_SESSION['PastDueDays1'] . "
						THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
						ELSE 0 END
					END
				) AS overdue1,
				SUM(
					CASE WHEN (weberp_paymentterms.daysbeforedue > 0)
					THEN
						CASE WHEN (TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate)) > weberp_paymentterms.daysbeforedue AND TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate) >= (weberp_paymentterms.daysbeforedue + " . $_SESSION['PastDueDays2'] . ")
						THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc ELSE 0 END
					ELSE
						CASE WHEN TO_DAYS(Now()) - TO_DAYS(ADDDATE(last_day(weberp_debtortrans.trandate), weberp_paymentterms.dayinfollowingmonth)) >= " . $_SESSION['PastDueDays2'] . "
						THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
						ELSE 0 END
					END
				) AS overdue2
				FROM weberp_debtorsmaster,
					weberp_paymentterms,
					weberp_holdreasons,
					weberp_currencies,
					weberp_debtortrans
				WHERE weberp_debtorsmaster.paymentterms = weberp_paymentterms.termsindicator
					AND weberp_debtorsmaster.currcode = weberp_currencies.currabrev
					AND weberp_debtorsmaster.holdreason = weberp_holdreasons.reasoncode
					AND weberp_debtorsmaster.debtorno = weberp_debtortrans.debtorno
					" . $SalesLimit . "
				GROUP BY weberp_debtorsmaster.debtorno,
					weberp_debtorsmaster.name,
					weberp_currencies.currency,
					weberp_paymentterms.terms,
					weberp_paymentterms.daysbeforedue,
					weberp_paymentterms.dayinfollowingmonth,
					weberp_debtorsmaster.creditlimit,
					weberp_holdreasons.dissallowinvoices,
					weberp_holdreasons.reasondescription
				HAVING
					ROUND(ABS(SUM(weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc)),weberp_currencies.decimalplaces) > 0";
	$CustomerResult = DB_query($Sql, '', '', False, False); /*dont trap errors handled below*/

	if(DB_error_no() != 0) {
		prnMsg(_('The customer details could not be retrieved by the SQL because') . ' ' . DB_error_msg(),'error');
		echo '<br /><a href="' . $RootPath . '/index.php">' . _('Back to the menu') . '</a>';
		if($debug==1) {
			echo '<br />', $Sql;
		}
		include('includes/footer.inc');
		exit;
	}

	while($AgedAnalysis = DB_fetch_array($CustomerResult,$db)) {
		if($k == 1) {
			echo '<tr class="EvenTableRows">';
			$k = 0;
		} else {
			echo '<tr class="OddTableRows">';
			$k = 1;
		}
		$CurrDecimalPlaces = $AgedAnalysis['decimalplaces'];
		$DisplayDue = locale_number_format($AgedAnalysis['due']-$AgedAnalysis['overdue1'],$CurrDecimalPlaces);
		$DisplayCurrent = locale_number_format($AgedAnalysis['balance']-$AgedAnalysis['due'],$CurrDecimalPlaces);
		$DisplayBalance = locale_number_format($AgedAnalysis['balance'],$CurrDecimalPlaces);
		$DisplayOverdue1 = locale_number_format($AgedAnalysis['overdue1']-$AgedAnalysis['overdue2'],$CurrDecimalPlaces);
		$DisplayOverdue2 = locale_number_format($AgedAnalysis['overdue2'],$CurrDecimalPlaces);
		if($DisplayDue <> 0 OR $DisplayOverdue1 <> 0 OR $DisplayOverdue2 <> 0) {
			$TotBal += $AgedAnalysis['balance'];
			$TotCurr += ($AgedAnalysis['balance']-$AgedAnalysis['due']);
			$TotDue += ($AgedAnalysis['due']-$AgedAnalysis['overdue1']);
			$TotOD1 += ($AgedAnalysis['overdue1']-$AgedAnalysis['overdue2']);
			$TotOD2 += $AgedAnalysis['overdue2'];
			echo '<td class="text" colspan="4"><b>', $AgedAnalysis['debtorno'], ' - ', $AgedAnalysis['name'], '</b></td>
					<td class="number"><b>', $DisplayBalance, '</b></td>
					<td class="number"><b>', $DisplayCurrent, '</b></td>
					<td class="number" style="color:orange;"><b>', $DisplayDue, '</b></td>
					<td class="number" style="color:red;"><b>', $DisplayOverdue1, '</b></td>
					<td class="number" style="color:red;"><b>', $DisplayOverdue2, '</b></td>
				</tr>';

			$Sql = "SELECT weberp_systypes.typename,
						weberp_debtortrans.transno,
						weberp_debtortrans.trandate,
						daysbeforedue,
						dayinfollowingmonth,
						(weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc) as balance,
						(CASE WHEN (weberp_paymentterms.daysbeforedue > 0)
							THEN
								(CASE WHEN (TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate)) >= weberp_paymentterms.daysbeforedue
								THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
								ELSE 0 END)
							ELSE
								(CASE WHEN TO_DAYS(Now()) - TO_DAYS(ADDDATE(ADDDATE(last_day(weberp_debtortrans.trandate), 1), weberp_paymentterms.dayinfollowingmonth)) >= 0
								THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
								ELSE 0 END)
						END) AS due,
						(CASE WHEN (weberp_paymentterms.daysbeforedue > 0)
							THEN
								(CASE WHEN TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate) > weberp_paymentterms.daysbeforedue AND TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate) >= (weberp_paymentterms.daysbeforedue + " . $_SESSION['PastDueDays1'] . ") THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc ELSE 0 END)
							ELSE
								(CASE WHEN (TO_DAYS(Now()) - TO_DAYS(ADDDATE(ADDDATE(last_day(weberp_debtortrans.trandate), 1), weberp_paymentterms.dayinfollowingmonth)) >= " . $_SESSION['PastDueDays1'] . ")
								THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
								ELSE 0 END)
						END) AS overdue1,
						(CASE WHEN (weberp_paymentterms.daysbeforedue > 0)
							THEN
								(CASE WHEN TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate) > weberp_paymentterms.daysbeforedue AND TO_DAYS(Now()) - TO_DAYS(weberp_debtortrans.trandate) >= (weberp_paymentterms.daysbeforedue + " . $_SESSION['PastDueDays2'] . ")
								THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
								ELSE 0 END)
							ELSE
								(CASE WHEN (TO_DAYS(Now()) - TO_DAYS(ADDDATE(ADDDATE(last_day(weberp_debtortrans.trandate), 1), weberp_paymentterms.dayinfollowingmonth)) >= " . $_SESSION['PastDueDays2'] . ")
								THEN weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc
								ELSE 0 END)
						END) AS overdue2
				   FROM weberp_debtorsmaster,
						weberp_paymentterms,
						weberp_debtortrans,
						weberp_systypes
				   WHERE weberp_systypes.typeid = weberp_debtortrans.type
						AND weberp_debtorsmaster.paymentterms = weberp_paymentterms.termsindicator
						AND weberp_debtorsmaster.debtorno = weberp_debtortrans.debtorno
						AND weberp_debtortrans.debtorno = '" . $AgedAnalysis['debtorno'] . "'
						AND ABS(weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc)>0.004";

			if($_SESSION['SalesmanLogin'] != '') {
				$Sql .= " AND weberp_debtortrans.salesperson='" . $_SESSION['SalesmanLogin'] . "'";
			}

			$DetailResult = DB_query($Sql,'','',False,False);
			if(DB_error_no() !=0) {
				prnMsg(_('The details of outstanding transactions for customer') . ' - ' . $AgedAnalysis['debtorno'] . ' ' . _('could not be retrieved because') . ' - ' . DB_error_msg(),'error');
				echo '<br /><a href="' . $RootPath . '/index.php">' . _('Back to the menu') . '</a>';
				if($debug==1) {
					echo '<br />' . _('The SQL that failed was') . '<br />' . $Sql;
				}
				include('includes/footer.inc');
				exit;
			}

			while($DetailTrans = DB_fetch_array($DetailResult)) {
				$DisplayTranDate = ConvertSQLDate($DetailTrans['trandate']);
				$DisplayBalance = locale_number_format($DetailTrans['balance'], $CurrDecimalPlaces);
				$DisplayCurrent = locale_number_format($DetailTrans['balance']-$DetailTrans['due'], $CurrDecimalPlaces);
				$DisplayDue = locale_number_format($DetailTrans['due']-$DetailTrans['overdue1'], $CurrDecimalPlaces);
				$DisplayOverdue1 = locale_number_format($DetailTrans['overdue1']-$DetailTrans['overdue2'], $CurrDecimalPlaces);
				$DisplayOverdue2 = locale_number_format($DetailTrans['overdue2'], $CurrDecimalPlaces);

				if($DetailTrans['daysbeforedue'] > 0) {
					$AddDays=$DetailTrans['daysbeforedue'] . ' days';
					if(function_exists('date_add')) {
						$DisplayDueDate = date_add(date_create($DetailTrans['trandate']), date_interval_create_from_date_string($AddDays));
					} else {
				 		$DisplayDueDate = strtotime($AddDays,strtotime($DetailTrans['trandate']));
					}

				} else {
					$AddDays=(intval($DetailTrans['dayinfollowingmonth']) - 1) . ' days';
					if(function_exists('date_add')) {
						$DisplayDueDate = date_create($DetailTrans['trandate']);
						$DisplayDueDate->modify('first day of next month');
						$DisplayDueDate = date_add($DisplayDueDate, date_interval_create_from_date_string($AddDays));
					} else {
						$DisplayDueDate = strtotime('first day of next month',strtotime($DetailTrans['trandate']));
						$DisplayDueDate = strtotime($DisplayDueDate,strtotime($AddDays));
					}

				}
				if(function_exists('date_add')) {
					$DisplayDueDate=date_format($DisplayDueDate,$_SESSION['DefaultDateFormat']);
				} else {
					$DisplayDueDate = Date($_SESSION['DefaultDateFormat'],$DisplayDueDate);
				}
				if($k == 1) {
					echo '<tr class="EvenTableRows">';
					$k = 0;
				} else {
					echo '<tr class="OddTableRows">';
					$k = 1;
				}
				echo '<td style="text-align:center">', _($DetailTrans['typename']), '</td>',// Should it be left (text field) ?
						'<td class="number">', $DetailTrans['transno'], '</td>
						<td class="centre">', $DisplayTranDate, '</td>
						<td class="centre">', $DisplayDueDate, '</td>
						<td class="number">', $DisplayBalance, '</td>
						<td class="number">', $DisplayCurrent, '</td>
						<td class="number" style="color:orange;">', $DisplayDue, '</td>
						<td class="number" style="color:red;">', $DisplayOverdue1, '</td>
						<td class="number" style="color:red;">', $DisplayOverdue2, '</td>
					</tr>';
			} //end while there are detail transactions to show
		} //has Due now or overdue
	} //end customer aged analysis while loop

	// Print totals of 'Overdue Customer Balances':
	if($k == 1) {
		echo '<tr class="EvenTableRows">';
		$k = 0;
	} else {
		echo '<tr class="OddTableRows">';
		$k = 1;
	}
	echo '<td class="text"><b>', _('Totals'), '</b></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td class="number"><b>', locale_number_format($TotBal, $CurrDecimalPlaces), '</b></td>
			<td class="number"><b>', locale_number_format($TotCurr, $CurrDecimalPlaces), '</b></td>
			<td class="number"><b>', locale_number_format($TotDue, $CurrDecimalPlaces), '</b></td>
			<td class="number" style="color:red;"><b>', locale_number_format($TotOD1, $CurrDecimalPlaces), '</b></td>
			<td class="number" style="color:red;"><b>', locale_number_format($TotOD2, $CurrDecimalPlaces), '</b></td>
		</tr>
		</tbody></table>';
} //DebtorSecurity

if(in_array($PayeeSecurity, $_SESSION['AllowedPageSecurityTokens']) OR !isset($PayeeSecurity)) {
	echo '<br />
		<h2>', _('Supplier Invoices Due within 1 Month'), '</h2>
		<table class="selection">
		<thead>
			<tr>
				<th>', _('Supplier'), '</th>
				<th>', _('Invoice Date'), '</th>
				<th>', _('Invoice'), '</th>
				<th>', _('Amount Due'), '</th>
				<th>', _('Due Date'), '</th>
			</tr>
		</thead><tbody>';
	$SupplierID = '';
	$TotalPayments = 0;
	$TotalAccumDiffOnExch = 0;
	$AccumBalance = 0;

	$Sql = "SELECT weberp_suppliers.supplierid,
					weberp_currencies.decimalplaces AS currdecimalplaces,
					SUM(weberp_supptrans.ovamount + weberp_supptrans.ovgst - weberp_supptrans.alloc) AS balance
			FROM weberp_suppliers INNER JOIN weberp_paymentterms
			ON weberp_suppliers.paymentterms = weberp_paymentterms.termsindicator
			INNER JOIN weberp_supptrans
			ON weberp_suppliers.supplierid = weberp_supptrans.supplierno
			INNER JOIN weberp_systypes
			ON weberp_systypes.typeid = weberp_supptrans.type
			INNER JOIN weberp_currencies
			ON weberp_suppliers.currcode=weberp_currencies.currabrev
			WHERE weberp_supptrans.ovamount + weberp_supptrans.ovgst - weberp_supptrans.alloc !=0
			AND weberp_supptrans.hold=0
			GROUP BY weberp_suppliers.supplierid,
					weberp_currencies.decimalplaces
			HAVING SUM(weberp_supptrans.ovamount + weberp_supptrans.ovgst - weberp_supptrans.alloc) <> 0
			ORDER BY weberp_suppliers.supplierid";
	$SuppliersResult = DB_query($Sql);

	while($SuppliersToPay = DB_fetch_array($SuppliersResult)) {

		$CurrDecimalPlaces = $SuppliersToPay['currdecimalplaces'];

		$Sql = "SELECT weberp_suppliers.supplierid,
						weberp_suppliers.suppname,
						weberp_systypes.typename,
						weberp_paymentterms.terms,
						weberp_supptrans.suppreference,
						weberp_supptrans.trandate,
						weberp_supptrans.rate,
						weberp_supptrans.transno,
						weberp_supptrans.type,
						weberp_supptrans.duedate,
						(weberp_supptrans.ovamount + weberp_supptrans.ovgst - weberp_supptrans.alloc) AS balance,
						(weberp_supptrans.ovamount + weberp_supptrans.ovgst ) AS trantotal,
						weberp_supptrans.diffonexch,
						weberp_supptrans.id
				FROM weberp_suppliers
				INNER JOIN weberp_paymentterms ON weberp_suppliers.paymentterms = weberp_paymentterms.termsindicator
				INNER JOIN weberp_supptrans ON weberp_suppliers.supplierid = weberp_supptrans.supplierno
				INNER JOIN weberp_systypes ON weberp_systypes.typeid = weberp_supptrans.type
				WHERE weberp_supptrans.supplierno = '" . $SuppliersToPay['supplierid'] . "'
					AND weberp_supptrans.ovamount + weberp_supptrans.ovgst - weberp_supptrans.alloc !=0
					AND weberp_supptrans.duedate <='" . Date('Y-m-d', mktime(0,0,0, Date('n'),Date('j')+30,date('Y'))) . "'
					AND weberp_supptrans.hold = 0
				ORDER BY weberp_supptrans.supplierno,
					weberp_supptrans.type,
					weberp_supptrans.transno";

		$TransResult = DB_query($Sql,'','',false,false);
		if(DB_error_no() !=0) {
			prnMsg(_('The details of supplier invoices due could not be retrieved because') . ' - ' . DB_error_msg(),'error');
			echo '<br /><a href="' . $RootPath . '/index.php">' . _('Back to the menu') . '</a>';
			if($debug==1) {
				echo '<br />' . _('The SQL that failed was') . ' ' . $Sql;
			}
			include('includes/footer.inc');
			exit;
		}

		unset($Allocs);
		$Allocs = array();
		$AllocCounter =0;
		$k = 0; //row colour counter

		while($DetailTrans = DB_fetch_array($TransResult)) {
			if($DetailTrans['supplierid'] != $SupplierID) { /*Need to head up for a new suppliers details */
				if($k == 1) {
					echo '<tr class="EvenTableRows">';
					$k = 0;
				} else {
					echo '<tr class="OddTableRows">';
					$k = 1;
				}
				$SupplierID = $DetailTrans['supplierid'];
				$SupplierName = $DetailTrans['suppname'];
				//$AccumBalance = 0;
				$AccumDiffOnExch = 0;
				echo '<td class="text" colspan="5"><b>', $DetailTrans['supplierid'], ' - ', $DetailTrans['suppname'], ' - ', $DetailTrans['terms'], '</b></td>
					</tr>';
			}

			if($k == 1) {
				echo '<tr class="EvenTableRows">';
				$k = 0;
			} else {
				echo '<tr class="OddTableRows">';
				$k = 1;
			}
			$DisplayFormat = '';
			if((time()-(60*60*24)) > strtotime($DetailTrans['duedate'])) {
				$DisplayFormat = ' style="color:red;"';
			}
			$DislayTranDate = ConvertSQLDate($DetailTrans['trandate']);
			$AccumBalance += $DetailTrans['balance'];
			if($DetailTrans['type'] == 20) {// If Purchase Invoice:
				echo '<td style="text-align:center">', _($DetailTrans['typename']), '</td>
						<td class="centre">', $DislayTranDate, '</td>
						<td class="text"><a href="', $RootPath, '/Payments.php?&SupplierID=', $SupplierID, '&amp;Amount=', $DetailTrans['balance'], '&amp;BankTransRef=', $DetailTrans['suppreference'], '">', $DetailTrans['suppreference'], '</a></td>
						<td class="number"', $DisplayFormat, '>', locale_number_format($DetailTrans['balance'], $CurrDecimalPlaces), '</td>
						<td class="centre"', $DisplayFormat, '>', ConvertSQLDate($DetailTrans['duedate']), '</td>
					</tr>';
			} else {// If NOT Purchase Invoice (Creditors Payment):
				echo '<td style="text-align:center">', _($DetailTrans['typename']), '</td>
						<td class="centre">', $DislayTranDate, '</td>
						<td class="text"><a href="', $RootPath, '/SupplierAllocations.php?AllocTrans=', $DetailTrans['id'], '">', $DetailTrans['suppreference'], '</a></td>
						<td class="number"', $DisplayFormat, '>', locale_number_format($DetailTrans['balance'], $CurrDecimalPlaces), '</td>
						<td class="centre"', $DisplayFormat, '>', ConvertSQLDate($DetailTrans['duedate']), '</td>
					</tr>';
			}
		} /*end while there are detail transactions to show */
	} /* end while there are suppliers to retrieve transactions for */

	if($k == 1) {
		echo '<tr class="EvenTableRows">';
		$k = 0;
	} else {
		echo '<tr class="OddTableRows">';
		$k = 1;
	}
	echo '<td class="number">', _('Grand Total Payments Due'), '</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td class="number"><b>', locale_number_format($AccumBalance, $CurrDecimalPlaces), '</b></td>
			<td>&nbsp;</td>
		</tr>
		</tbody>
		</table>';
}  //PayeeSecurity

if(in_array($CashSecurity, $_SESSION['AllowedPageSecurityTokens']) OR !isset($CashSecurity)) {
	include('includes/GLPostings.inc');
	echo '<br />
		<h2>', _('Bank and Credit Card Balances'), '</h2>
		<table class="selection">',
/*		'<thead>',*/ // Need to update the sorting javascript.
			'<tr>
				<th class="ascending">', _('GL Account'), '</th>
				<th class="ascending">', _('Account Name'), '</th>
				<th class="ascending">', _('Balance'), '</th>
			</tr>'
/*,		'</thead><tbody>'*/;// Need to update the sorting javascript.
	$FirstPeriodSelected = GetPeriod(date($_SESSION['DefaultDateFormat']), $db);
	$LastPeriodSelected = GetPeriod(date($_SESSION['DefaultDateFormat']), $db);
	$SelectedPeriod=$LastPeriodSelected;

	$Sql = "SELECT weberp_bankaccounts.accountcode,
					weberp_bankaccounts.bankaccountcode,
					weberp_chartmaster.accountname,
					bankaccountname
			FROM weberp_bankaccounts INNER JOIN weberp_chartmaster
			ON weberp_bankaccounts.accountcode = weberp_chartmaster.accountcode";

	$ErrMsg = _('The bank accounts set up could not be retrieved because');
	$DbgMsg = _('The SQL used to retrieve the bank account details was') . '<br />' . $Sql;
	$result1 = DB_query($Sql,$ErrMsg,$DbgMsg);

	$k = 0; //row colour counter

	while($myrow = DB_fetch_array($result1)) {
		if($k == 1) {
			echo '<tr class="EvenTableRows">';
			$k = 0;
		} else {
			echo '<tr class="OddTableRows">';
			$k = 1;
		}
		/*Is the account a balance sheet or a profit and loss account */
		$result = DB_query("SELECT pandl
						FROM weberp_accountgroups
						INNER JOIN weberp_chartmaster ON weberp_accountgroups.groupname=weberp_chartmaster.group_
						WHERE weberp_chartmaster.accountcode='" . $myrow['accountcode'] ."'");
		$PandLRow = DB_fetch_row($result);
		if($PandLRow[0]==1) {
			$PandLAccount = True;
		} else {
			$PandLAccount = False; /*its a balance sheet account */
		}

		$Sql= "SELECT counterindex,
						type,
						typename,
						weberp_gltrans.typeno,
						trandate,
						narrative,
						amount,
						periodno,
						weberp_gltrans.tag,
						tagdescription
					FROM weberp_gltrans INNER JOIN weberp_systypes
					ON weberp_systypes.typeid=weberp_gltrans.type
					LEFT JOIN weberp_tags
					ON weberp_gltrans.tag = weberp_tags.tagref
					WHERE weberp_gltrans.account = '" . $myrow['accountcode'] . "'
					AND posted=1
					AND periodno>='" . $FirstPeriodSelected . "'
					AND periodno<='" . $LastPeriodSelected . "'
					ORDER BY periodno, weberp_gltrans.trandate, counterindex";
		$TransResult = DB_query($Sql,$ErrMsg);
		if($PandLAccount==True) {
			$RunningTotal = 0;
		} else {// added to fix bug with Brought Forward Balance always being zero
			$Sql = "SELECT bfwd,
						actual,
						period
					FROM weberp_chartdetails
					WHERE weberp_chartdetails.accountcode='" . $myrow['accountcode'] . "'
					AND weberp_chartdetails.period='" . $FirstPeriodSelected . "'";

			$ErrMsg = _('The chart details for account') . ' ' . $myrow['accountcode'] . ' ' . _('could not be retrieved');
			$ChartDetailsResult = DB_query($Sql,$ErrMsg);
			$ChartDetailRow = DB_fetch_array($ChartDetailsResult);
			$RunningTotal = $ChartDetailRow['bfwd'];
		}
		$PeriodTotal = 0;
		$PeriodNo = -9999;
		while($myrow2=DB_fetch_array($TransResult)) {
			if($myrow2['periodno']!=$PeriodNo) {
				if($PeriodNo!=-9999) { //ie its not the first time around
					/*Get the ChartDetails balance b/fwd and the actual movement in the account for the period as recorded in the chart details - need to ensure integrity of transactions to the chart detail movements. Also, for a balance sheet account it is the balance carried forward that is important, not just the transactions*/

					$Sql = "SELECT bfwd,
							actual,
							period
						FROM weberp_chartdetails
						WHERE weberp_chartdetails.accountcode='" . $myrow['accountcode'] . "'
						AND weberp_chartdetails.period='" . $PeriodNo . "'";
					$ErrMsg = _('The chart details for account') . ' ' . $myrow['accountcode'] . ' ' . _('could not be retrieved');
					$ChartDetailsResult = DB_query($Sql,$ErrMsg);
					$ChartDetailRow = DB_fetch_array($ChartDetailsResult);
					if($PeriodTotal < 0 ) { //its a credit balance b/fwd
						if($PandLAccount==True) {
							$RunningTotal = 0;
						}
					} else { //its a debit balance b/fwd
						if($PandLAccount==True) {
							$RunningTotal = 0;
						}
					}
				}
				$PeriodNo = $myrow2['periodno'];
				$PeriodTotal = 0;
			}
			$RunningTotal += $myrow2['amount'];
			$PeriodTotal += $myrow2['amount'];
		}
		$DisplayBalance=locale_number_format(($RunningTotal),$_SESSION['CompanyRecord']['decimalplaces']);
		echo	'<td class="text">', $myrow['accountcode'], ' - ', $myrow['accountname'], '</td>
				<td class="text">', $myrow['bankaccountname'], '</td>
				<td class="number">', $DisplayBalance, '</td>
			</tr>';
	} //each bank account
	echo /*'</tbody>',*/// Need to update the sorting javascript.
		'</table>';
} //CashSecurity

if(in_array($OrderSecurity, $_SESSION['AllowedPageSecurityTokens']) OR !isset($OrderSecurity)) {
	echo '<br />
		<h2>', _('Outstanding Orders'), '</h2>
		<table class="selection">
		<thead>',
			'<tr>
				<th>', _('View Order'), '</th>
				<th>', _('Customer'), '</th>
				<th>', _('Branch'), '</th>
				<th>', _('Cust Order'), ' #</th>
				<th>', _('Order Date'), '</th>
				<th>', _('Req Del Date'), '</th>
				<th>', _('Delivery To'), '</th>
				<th>', _('Order Total'), ' ', _('in'), ' ', $_SESSION['CompanyRecord']['currencydefault'], '</th>
			</tr>
		</thead><tbody>';

	$Sql = "SELECT weberp_salesorders.orderno,
						weberp_debtorsmaster.name,
						weberp_custbranch.brname,
						weberp_salesorders.customerref,
						weberp_salesorders.orddate,
						weberp_salesorders.deliverto,
						weberp_salesorders.deliverydate,
						weberp_salesorders.printedpackingslip,
						weberp_salesorders.poplaced,
						SUM(weberp_salesorderdetails.unitprice*weberp_salesorderdetails.quantity*(1-weberp_salesorderdetails.discountpercent)/weberp_currencies.rate) AS ordervalue
					FROM weberp_salesorders INNER JOIN weberp_salesorderdetails
						ON weberp_salesorders.orderno = weberp_salesorderdetails.orderno
						INNER JOIN weberp_debtorsmaster
						ON weberp_salesorders.debtorno = weberp_debtorsmaster.debtorno
						INNER JOIN weberp_custbranch
						ON weberp_debtorsmaster.debtorno = weberp_custbranch.debtorno
						AND weberp_salesorders.branchcode = weberp_custbranch.branchcode
						INNER JOIN weberp_currencies
						ON weberp_debtorsmaster.currcode = weberp_currencies.currabrev
					WHERE weberp_salesorderdetails.completed=0
					AND weberp_salesorders.quotation =0
					GROUP BY weberp_salesorders.orderno,
						weberp_debtorsmaster.name,
						weberp_custbranch.brname,
						weberp_salesorders.customerref,
						weberp_salesorders.orddate,
						weberp_salesorders.deliverto,
						weberp_salesorders.deliverydate,
						weberp_salesorders.printedpackingslip
					ORDER BY weberp_salesorders.orddate DESC, weberp_salesorders.orderno";
	$ErrMsg = _('No orders or quotations were returned by the SQL because');
	$SalesOrdersResult = DB_query($Sql,$ErrMsg);

	/*show a table of the orders returned by the SQL */
	if(DB_num_rows($SalesOrdersResult)>0) {
		$k = 0; //row colour counter
		$OrdersTotal = 0;
		$FontColor = '';

		while($MyRow=DB_fetch_array($SalesOrdersResult)) {
			$OrderDate = ConvertSQLDate($MyRow['orddate']);
			$FormatedDelDate = ConvertSQLDate($MyRow['deliverydate']);
			$FormatedOrderValue = locale_number_format($MyRow['ordervalue'],$_SESSION['CompanyRecord']['decimalplaces']);
			if(DateDiff(Date($_SESSION['DefaultDateFormat']), $OrderDate, 'd') > 5) {
				$FontColor = ' style="color:green; font-weight:bold"';
			}
			if($k == 1) {
				echo '<tr class="EvenTableRows">';
				$k = 0;
			} else {
				echo '<tr class="OddTableRows">';
				$k = 1;
			}
			echo	'<td class="number"><a href="', $RootPath, '/OrderDetails.php?OrderNumber=', $MyRow['orderno'], '" target="_blank">', $MyRow['orderno'], '</a></td>
					<td class="text"', $FontColor, '>', $MyRow['name'], '</td>
					<td class="text"', $FontColor, '>', $MyRow['brname'], '</td>
					<td class="number"', $FontColor, '>', $MyRow['customerref'], '</td>
					<td class="centre"', $FontColor, '>', $OrderDate, '</td>
					<td class="centre"', $FontColor, '>', $FormatedDelDate, '</td>
					<td class="text"', $FontColor, '>', html_entity_decode($MyRow['deliverto'], ENT_QUOTES, 'UTF-8'), '</td>
					<td class="number"', $FontColor , '>', $FormatedOrderValue, '</td>
				</tr>';
			$OrdersTotal += $MyRow['ordervalue'];
		}// END while($MyRow=DB_fetch_array($SalesOrdersResult))

		echo	'<tr>
					<td class="number" colspan="7"><b>', _('Total Order(s) Value in'), ' ', $_SESSION['CompanyRecord']['currencydefault'], ' :</b></td>
					<td class="number"><b>', locale_number_format($OrdersTotal,$_SESSION['CompanyRecord']['decimalplaces']), '</b></td>
				</tr>
			</tbody></table>';

	} //rows > 0
} //OrderSecurity
include('includes/footer.inc');
?>
