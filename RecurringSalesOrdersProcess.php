<?php
/* $Id: RecurringSalesOrdersProcess.php 7021 2014-12-14 02:04:44Z tehonu $*/

/*need to allow this script to run from Cron or windows scheduler */
$AllowAnyone = true;

/* Get this puppy to run from cron (cd webERP && php -f RecurringSalesOrdersProcess.php "weberpdemo") or direct URL (RecurringSalesOrdersProcess.php?Database=weberpdemo) */
if (isset($_GET['Database'])) {
	$_SESSION['DatabaseName'] = $_GET['Database'];
	$DatabaseName = $_GET['Database'];
	$_POST['CompanyNameField'] = $_GET['Database'];
}

if (isset($argc)) {
	if (isset($argv[1])) {
		$_SESSION['DatabaseName'] = $argv[1];
		$DatabaseName = $argv[1];
		$_POST['CompanyNameField'] = $argv[1];
	}
}
include('includes/session.inc');

$Title = _('Recurring Orders Process');
/* webERP manual links before header.inc */
$ViewTopic= "SalesOrders";
$BookMark = "RecurringSalesOrders";
include('includes/header.inc');
include('includes/SQL_CommonFunctions.inc');
include('includes/GetSalesTransGLCodes.inc');
include('includes/htmlMimeMail.php');

$sql = "SELECT weberp_recurringsalesorders.recurrorderno,
			weberp_recurringsalesorders.debtorno,
	  		weberp_recurringsalesorders.branchcode,
	  		weberp_recurringsalesorders.customerref,
	  		weberp_recurringsalesorders.buyername,
	  		weberp_recurringsalesorders.comments,
	  		weberp_recurringsalesorders.orddate,
	  		weberp_recurringsalesorders.ordertype,
	  		weberp_recurringsalesorders.shipvia,
	  		weberp_recurringsalesorders.deladd1,
	  		weberp_recurringsalesorders.deladd2,
	  		weberp_recurringsalesorders.deladd3,
	  		weberp_recurringsalesorders.deladd4,
	  		weberp_recurringsalesorders.deladd5,
	  		weberp_recurringsalesorders.deladd6,
	  		weberp_recurringsalesorders.contactphone,
	  		weberp_recurringsalesorders.contactemail,
	  		weberp_recurringsalesorders.deliverto,
	  		weberp_recurringsalesorders.freightcost,
	  		weberp_recurringsalesorders.fromstkloc,
	  		weberp_recurringsalesorders.lastrecurrence,
	  		weberp_recurringsalesorders.stopdate,
	  		weberp_recurringsalesorders.frequency,
	  		weberp_recurringsalesorders.autoinvoice,
			weberp_debtorsmaster.name,
			weberp_debtorsmaster.currcode,
			weberp_salestypes.sales_type,
			weberp_custbranch.area,
			weberp_custbranch.taxgroupid,
			weberp_locations.contact,
			weberp_locations.email
		FROM weberp_recurringsalesorders INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_recurringsalesorders.fromstkloc AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canupd=1,
			weberp_debtorsmaster,
			weberp_custbranch,
			weberp_salestypes,
			weberp_locations
		WHERE weberp_recurringsalesorders.ordertype=weberp_salestypes.typeabbrev
		AND weberp_recurringsalesorders.debtorno = weberp_debtorsmaster.debtorno
		AND weberp_recurringsalesorders.debtorno = weberp_custbranch.debtorno
		AND weberp_recurringsalesorders.branchcode = weberp_custbranch.branchcode
		AND weberp_recurringsalesorders.fromstkloc=weberp_locations.loccode
		AND weberp_recurringsalesorders.ordertype=weberp_salestypes.typeabbrev
		AND (TO_DAYS(NOW()) - TO_DAYS(weberp_recurringsalesorders.lastrecurrence)) > (365/weberp_recurringsalesorders.frequency)
		AND DATE_ADD(weberp_recurringsalesorders.lastrecurrence, " . INTERVAL ('365/weberp_recurringsalesorders.frequency', 'DAY') . ") <= weberp_recurringsalesorders.stopdate";

$RecurrOrdersDueResult = DB_query($sql,_('There was a problem retrieving the recurring sales order templates. The database reported:'));

if (DB_num_rows($RecurrOrdersDueResult)==0){
	prnMsg(_('There are no recurring order templates that are due to have another recurring order created'),'warn');
	include('includes/footer.inc');
	exit;
}

prnMsg(_('The number of recurring orders to process is') .' : ' . DB_num_rows($RecurrOrdersDueResult),'info');

while ($RecurrOrderRow = DB_fetch_array($RecurrOrdersDueResult)){

	$EmailText ='';
	echo '<br />' . _('Recurring order') . ' ' . $RecurrOrderRow['recurrorderno'] . ' ' . _('for') . ' ' . $RecurrOrderRow['debtorno'] . ' - ' . $RecurrOrderRow['branchcode'] . ' ' . _('is being processed');

	$result = DB_Txn_Begin();

	/*the last recurrence was the date of the last time the order recurred
	the frequency is the number of times per annum that the order should recurr
	so 365 / frequency gives the number of days between recurrences */

	$DelDate = FormatDateforSQL(DateAdd(ConvertSQLDate($RecurrOrderRow['lastrecurrence']),'d',(365/$RecurrOrderRow['frequency'])));

	echo '<br />' . _('Date calculated for the next recurrence was') .': ' . $DelDate;
	$OrderNo = GetNextTransNo(30, $db);

	$HeaderSQL = "INSERT INTO weberp_salesorders (
							orderno,
							debtorno,
							branchcode,
							customerref,
							comments,
							orddate,
							ordertype,
							shipvia,
							deliverto,
							deladd1,
							deladd2,
							deladd3,
							deladd4,
							deladd5,
							deladd6,
							contactphone,
							contactemail,
							freightcost,
							fromstkloc,
							deliverydate )
						VALUES (
							'" . $OrderNo . "',
							'" . $RecurrOrderRow['debtorno'] . "',
							'" . $RecurrOrderRow['branchcode'] . "',
							'". $RecurrOrderRow['customerref'] ."',
							'". $RecurrOrderRow['comments'] ."',
							'" . $DelDate . "',
							'" . $RecurrOrderRow['ordertype'] . "',
							'" . $RecurrOrderRow['shipvia'] ."',
							'" . $RecurrOrderRow['deliverto'] . "',
							'" . $RecurrOrderRow['deladd1'] . "',
							'" . $RecurrOrderRow['deladd2'] . "',
							'" . $RecurrOrderRow['deladd3'] . "',
							'" . $RecurrOrderRow['deladd4'] . "',
							'" . $RecurrOrderRow['deladd5'] . "',
							'" . $RecurrOrderRow['deladd6'] . "',
							'" . $RecurrOrderRow['contactphone'] . "',
							'" . $RecurrOrderRow['contactemail'] . "',
							'" . $RecurrOrderRow['freightcost'] ."',
							'" . $RecurrOrderRow['fromstkloc'] ."',
							'" . $DelDate . "')";

	$ErrMsg = _('The order cannot be added because');
	$InsertQryResult = DB_query($HeaderSQL,$ErrMsg,true);

	$EmailText = _('A new order has been created from a recurring order template for customer') .' ' .  $RecurrOrderRow['debtorno'] . ' ' . $RecurrOrderRow['branchcode'] . "\n" . _('The order number is:') . ' ' . $OrderNo;

	/*need to look up RecurringOrder from the template and populate the line RecurringOrder array with the sales order details records */
	$LineItemsSQL = "SELECT weberp_recurrsalesorderdetails.stkcode,
							weberp_recurrsalesorderdetails.unitprice,
							weberp_recurrsalesorderdetails.quantity,
							weberp_recurrsalesorderdetails.discountpercent,
							weberp_recurrsalesorderdetails.narrative,
							weberp_stockmaster.taxcatid
						FROM weberp_recurrsalesorderdetails INNER JOIN weberp_stockmaster
							ON weberp_recurrsalesorderdetails.stkcode = weberp_stockmaster.stockid
						WHERE weberp_recurrsalesorderdetails.recurrorderno ='" . $RecurrOrderRow['recurrorderno'] . "'";

	$ErrMsg = _('The line items of the recurring order cannot be retrieved because');
	$LineItemsResult = DB_query($LineItemsSQL,$ErrMsg);

	$LineCounter = 0;

	if (DB_num_rows($LineItemsResult)>0) {

		$OrderTotal =0; //intialise
		$OrderLineTotal =0;
		$StartOf_LineItemsSQL = "INSERT INTO weberp_salesorderdetails (
															orderno,
															orderlineno,
															stkcode,
															unitprice,
															quantity,
															discountpercent,
															narrative)
														VALUES ('" . $OrderNo . "', ";

		while ($RecurrOrderLineRow=DB_fetch_array($LineItemsResult)) {
			$LineItemsSQL = $StartOf_LineItemsSQL .
							" '" . $LineCounter . "',
							'" . $RecurrOrderLineRow['stkcode'] . "',
							'". $RecurrOrderLineRow['unitprice'] . "',
							'" . $RecurrOrderLineRow['quantity'] . "',
							'" . floatval($RecurrOrderLineRow['discountpercent']) . "',
							'" . $RecurrOrderLineRow['narrative'] . "')";

			$Ins_LineItemResult = DB_query($LineItemsSQL,_('Could not insert the order lines from the recurring order template'),true);	/*Populating a new order line items*/
			$LineCounter ++;
		} /* line items from recurring sales order details */
	} //end if there are line items on the recurring order

	$sql = "UPDATE weberp_recurringsalesorders SET lastrecurrence = '" . $DelDate . "'
			WHERE recurrorderno='" . $RecurrOrderRow['recurrorderno'] ."'";
	$ErrMsg = _('Could not update the last recurrence of the recurring order template. The database reported the error:');
	$Result = DB_query($sql,$ErrMsg,true);

	$Result = DB_Txn_Commit();

	prnMsg(_('Recurring order was created for') . ' ' . $RecurrOrderRow['name'] . ' ' . _('with order Number') . ' ' . $OrderNo, 'success');

	if ($RecurrOrderRow['autoinvoice']==1){
		/*Only dummy item orders can have autoinvoice =1
		so no need to worry about assemblies/kitsets/controlled items*/

		/* Now Get the area where the sale is to from the branches table */

		$SQL = "SELECT area,
						defaultshipvia
				FROM weberp_custbranch
				WHERE weberp_custbranch.debtorno ='". $RecurrOrderRow['debtorno'] . "'
				AND weberp_custbranch.branchcode = '" . $RecurrOrderRow['branchcode'] . "'";

		$ErrMsg = _('Unable to determine the area where the sale is to, from the customer branches table, please select an area for this branch');
		$Result = DB_query($SQL, $ErrMsg);
		$myrow = DB_fetch_row($Result);
		$Area = $myrow[0];
		$DefaultShipVia = $myrow[1];
//		$CustTaxAuth = $myrow[2];
		DB_free_result($Result);

		$SQL = "SELECT rate
				FROM weberp_currencies INNER JOIN weberp_debtorsmaster
				ON weberp_debtorsmaster.currcode=weberp_currencies.currabrev
				WHERE debtorno='" . $RecurrOrderRow['debtorno'] . "'";
		$ErrMsg = _('The exchange rate for the customer currency could not be retrieved from the currency table because:');
		$Result = DB_query($SQL,$ErrMsg);
		$myrow = DB_fetch_row($Result);
		$CurrencyRate = $myrow[0];

		$SQL = "SELECT taxprovinceid FROM weberp_locations WHERE loccode='" . $RecurrOrderRow['fromstkloc'] ."'";
		$ErrMsg = _('Could not retrieve the tax province of the location from where the order was fulfilled because:');
		$Result = DB_query($SQL,$ErrMsg);
		$myrow=DB_fetch_row($Result);
		$DispTaxProvinceID = $myrow[0];

	/*Now Get the next invoice number - function in SQL_CommonFunctions*/
		$InvoiceNo = GetNextTransNo(10, $db);
		$PeriodNo = GetPeriod(Date($_SESSION['DefaultDateFormat']), $db);

	/*Start an SQL transaction */
		$result = DB_Txn_Begin();

		$TotalFXNetInvoice = 0;
		$TotalFXTax = 0;

		DB_data_seek($LineItemsResult,0);

		$LineCounter =0;

		while ($RecurrOrderLineRow = DB_fetch_array($LineItemsResult)) {

			$LineNetAmount = $RecurrOrderLineRow['unitprice'] * $RecurrOrderLineRow['quantity'] *(1- floatval($RecurrOrderLineRow['discountpercent']));

			/*Gets the Taxes and rates applicable to this line from the TaxGroup of the branch and TaxCategory of the item
			and the taxprovince of the dispatch location */

			$SQL = "SELECT weberp_taxgrouptaxes.calculationorder,
					weberp_taxauthorities.description,
					weberp_taxgrouptaxes.taxauthid,
					weberp_taxauthorities.taxglcode,
					weberp_taxgrouptaxes.taxontax,
					weberp_taxauthrates.taxrate
			FROM weberp_taxauthrates INNER JOIN weberp_taxgrouptaxes ON
				weberp_taxauthrates.taxauthority=weberp_taxgrouptaxes.taxauthid
				INNER JOIN weberp_taxauthorities ON
				weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid
			WHERE weberp_taxgrouptaxes.taxgroupid='" . $RecurrOrderRow['taxgroupid'] . "'
			AND weberp_taxauthrates.dispatchtaxprovince='" . $DispTaxProvinceID . "'
			AND weberp_taxauthrates.taxcatid = '" . $RecurrOrderLineRow['taxcatid'] . "'
			ORDER BY weberp_taxgrouptaxes.calculationorder";

			$ErrMsg = _('The taxes and rates for this item could not be retrieved because');
			$GetTaxRatesResult = DB_query($SQL,$ErrMsg);

			$LineTaxAmount = 0;
			$TaxTotals =array();

			while ($myrow = DB_fetch_array($GetTaxRatesResult)){
				if (!isset($TaxTotals[$myrow['taxauthid']]['FXAmount'])) {
					$TaxTotals[$myrow['taxauthid']]['FXAmount']=0;
				}
				$TaxAuthID=$myrow['taxauthid'];
				$TaxTotals[$myrow['taxauthid']]['GLCode'] = $myrow['taxglcode'];
				$TaxTotals[$myrow['taxauthid']]['TaxRate'] = $myrow['taxrate'];
				$TaxTotals[$myrow['taxauthid']]['TaxAuthDescription'] = $myrow['description'];

				if ($myrow['taxontax'] ==1){
					  $TaxAuthAmount = ($LineNetAmount+$LineTaxAmount) * $myrow['taxrate'];
					  $TaxTotals[$myrow['taxauthid']]['FXAmount'] += ($LineNetAmount+$LineTaxAmount) * $myrow['taxrate'];
				} else {
					$TaxAuthAmount =  $LineNetAmount * $myrow['taxrate'];
					$TaxTotals[$myrow['taxauthid']]['FXAmount'] += $LineNetAmount * $myrow['taxrate'];
				}

				/*Make an array of the taxes and amounts including GLcodes for later posting - need debtortransid
				so can only post once the debtor trans is posted - can only post debtor trans when all tax is calculated */
				$LineTaxes[$LineCounter][$myrow['calculationorder']] = array('TaxCalculationOrder' =>$myrow['calculationorder'],
												'TaxAuthID' =>$myrow['taxauthid'],
												'TaxAuthDescription'=>$myrow['description'],
												'TaxRate'=>$myrow['taxrate'],
												'TaxOnTax'=>$myrow['taxontax'],
												'TaxAuthAmount'=>$TaxAuthAmount);
				$LineTaxAmount += $TaxAuthAmount;

			}

			$LineNetAmount = $RecurrOrderLineRow['unitprice'] * $RecurrOrderLineRow['quantity'] *(1- floatval($RecurrOrderLineRow['discountpercent']));

			$TotalFXNetInvoice += $LineNetAmount;
			$TotalFXTax += $LineTaxAmount;

			/*Now update SalesOrderDetails for the quantity invoiced and the actual dispatch dates. */
			$SQL = "UPDATE weberp_salesorderdetails
					SET qtyinvoiced = qtyinvoiced + " . $RecurrOrderLineRow['quantity'] . ",
						actualdispatchdate = '" . $DelDate .  "',
						completed='1'
				WHERE orderno = '" . $OrderNo . "'
				AND stkcode = '" . $RecurrOrderLineRow['stkcode'] . "'";

			$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The sales order detail record could not be updated because');
			$DbgMsg = _('The following SQL to update the sales order detail record was used');
			$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

			// Insert stock movements - with unit cost
			$LocalCurrencyPrice= ($RecurrOrderLineRow['unitprice'] *(1- floatval($RecurrOrderLineRow['discountpercent'])))/ $CurrencyRate;

			// its a dummy item dummies always have nil stock (by definition so new qty on hand will be nil
			$SQL = "INSERT INTO weberp_stockmoves (
						stockid,
						type,
						transno,
						loccode,
						trandate,
						userid,
						debtorno,
						branchcode,
						price,
						prd,
						reference,
						qty,
						discountpercent,
						standardcost,
						narrative
						)
					VALUES (
						'" . $RecurrOrderLineRow['stkcode'] . "',
						'10',
						'" . $InvoiceNo . "',
						'" . $RecurrOrderRow['fromstkloc'] . "',
						'" . $DelDate . "',
						'" . $_SESSION['UserID'] . "',
						'" . $RecurrOrderRow['debtorno'] . "',
						'" . $RecurrOrderRow['branchcode'] . "',
						'" . $LocalCurrencyPrice . "',
						'" . $PeriodNo . "',
						'" . $OrderNo . "',
						'" . -$RecurrOrderLineRow['quantity'] . "',
						'" . $RecurrOrderLineRow['discountpercent'] . "',
						'0',
						'" . $RecurrOrderLineRow['narrative'] . "')";

			$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('Stock movement records could not be inserted because');
			$DbgMsg = _('The following SQL to insert the stock movement records was used');
			$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

			/*Get the ID of the StockMove... */
			$StkMoveNo = DB_Last_Insert_ID($db,'weberp_stockmoves','stkmoveno');

			/*Insert the taxes that applied to this line */
			foreach ($LineTaxes[$LineCounter] as $Tax) {

				$SQL = "INSERT INTO weberp_stockmovestaxes (stkmoveno,
									taxauthid,
									taxrate,
									taxcalculationorder,
									taxontax)
						VALUES ('" . $StkMoveNo . "',
							'" . $Tax['TaxAuthID'] . "',
							'" . $Tax['TaxRate'] . "',
							'" . $Tax['TaxCalculationOrder'] . "',
							'" . $Tax['TaxOnTax'] . "')";

				$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('Taxes and rates applicable to this invoice line item could not be inserted because');
				$DbgMsg = _('The following SQL to insert the stock movement tax detail records was used');
				$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);
			}
			/*Insert Sales Analysis records */

			$SQL="SELECT COUNT(*),
					weberp_salesanalysis.stkcategory,
					weberp_salesanalysis.area,
					weberp_salesanalysis.salesperson,
					weberp_salesanalysis.periodno,
					weberp_salesanalysis.typeabbrev,
					weberp_salesanalysis.cust,
					weberp_salesanalysis.custbranch,
					weberp_salesanalysis.stockid
				FROM weberp_salesanalysis,
					weberp_custbranch,
					weberp_stockmaster
				WHERE weberp_salesanalysis.stkcategory=weberp_stockmaster.categoryid
				AND weberp_salesanalysis.stockid=weberp_stockmaster.stockid
				AND weberp_salesanalysis.cust=weberp_custbranch.debtorno
				AND weberp_salesanalysis.custbranch=weberp_custbranch.branchcode
				AND weberp_salesanalysis.area=weberp_custbranch.area
				AND weberp_salesanalysis.salesperson=weberp_custbranch.salesman
				AND weberp_salesanalysis.typeabbrev ='" . $RecurrOrderRow['ordertype'] . "'
				AND weberp_salesanalysis.periodno='" . $PeriodNo . "'
				AND weberp_salesanalysis.cust " . LIKE . "  '" . $RecurrOrderRow['debtorno'] . "'
				AND weberp_salesanalysis.custbranch  " . LIKE . " '" . $RecurrOrderRow['branchcode'] . "'
				AND weberp_salesanalysis.stockid  " . LIKE . " '" . $RecurrOrderLineRow['stkcode'] . "'
				AND weberp_salesanalysis.budgetoractual='1'
				GROUP BY weberp_salesanalysis.stockid,
					weberp_salesanalysis.stkcategory,
					weberp_salesanalysis.cust,
					weberp_salesanalysis.custbranch,
					weberp_salesanalysis.area,
					weberp_salesanalysis.periodno,
					weberp_salesanalysis.typeabbrev,
					weberp_salesanalysis.salesperson";

			$ErrMsg = _('The count of existing Sales analysis records could not run because');
			$DbgMsg = _('SQL to count the no of sales analysis records');
			$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

			$myrow = DB_fetch_row($Result);

			if ($myrow[0]>0){  /*Update the existing record that already exists */

				$SQL = "UPDATE weberp_salesanalysis
					SET amt=amt+" . filter_number_format($RecurrOrderLineRow['unitprice'] * $RecurrOrderLineRow['quantity'] / $CurrencyRate) . ",
					qty=qty +" . $RecurrOrderLineRow['quantity'] . ",
					disc=disc+" . filter_number_format($RecurrOrderLineRow['discountpercent'] * $RecurrOrderLineRow['unitprice'] * $RecurrOrderLineRow['quantity'] / $CurrencyRate) . "
					WHERE weberp_salesanalysis.area='" . $myrow[2] . "'
					AND weberp_salesanalysis.salesperson='" . $myrow[3] . "'
					AND typeabbrev ='" . $RecurrOrderRow['ordertype'] . "'
					AND periodno = '" . $PeriodNo . "'
					AND cust  " . LIKE . " '" . $RecurrOrderRow['debtorno'] . "'
					AND custbranch  " . LIKE . "  '" . $RecurrOrderRow['branchcode'] . "'
					AND stockid  " . LIKE . " '" . $RecurrOrderLineRow['stkcode'] . "'
					AND weberp_salesanalysis.stkcategory ='" . $myrow[1] . "'
					AND budgetoractual='1'";

			} else { /* insert a new sales analysis record */

				$SQL = "INSERT INTO weberp_salesanalysis (
									typeabbrev,
									periodno,
									amt,
									cost,
									cust,
									custbranch,
									qty,
									disc,
									stockid,
									area,
									budgetoractual,
									salesperson,
									stkcategory
									)
								SELECT '" . $RecurrOrderRow['ordertype']. "',
									'" . $PeriodNo . "',
									'" . filter_number_format($RecurrOrderLineRow['unitprice'] * $RecurrOrderLineRow['quantity'] / $CurrencyRate) . "',
									0,
									'" . $RecurrOrderRow['debtorno'] . "',
									'" . $RecurrOrderRow['branchcode'] . "',
									'" . $RecurrOrderLineRow['quantity'] . "',
									'" . filter_number_format($RecurrOrderLineRow['discountpercent'] * $RecurrOrderLineRow['unitprice'] * $RecurrOrderLineRow['quantity'] / $CurrencyRate) . "',
									'" . $RecurrOrderLineRow['stkcode'] . "',
									weberp_custbranch.area,
									1,
									weberp_custbranch.salesman,
									weberp_stockmaster.categoryid
								FROM weberp_stockmaster,
									weberp_custbranch
								WHERE weberp_stockmaster.stockid = '" . $RecurrOrderLineRow['stkcode'] . "'
								AND weberp_custbranch.debtorno = '" . $RecurrOrderRow['debtorno'] . "'
								AND weberp_custbranch.branchcode='" . $RecurrOrderRow['branchcode'] . "'";
			}

			$ErrMsg = _('Sales analysis record could not be added or updated because');
			$DbgMsg = _('The following SQL to insert the sales analysis record was used');
			$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

			if ($_SESSION['CompanyRecord']['gllink_debtors']==1 AND $RecurrOrderLineRow['unitprice'] !=0){

				//Post sales transaction to GL credit sales
				$SalesGLAccounts = GetSalesGLAccount($Area, $RecurrOrderLineRow['stkcode'], $RecurrOrderRow['ordertype'], $db);

				$SQL = "INSERT INTO weberp_gltrans (
							type,
							typeno,
							trandate,
							periodno,
							account,
							narrative,
							amount
						)
					VALUES (
						'10',
						'" . $InvoiceNo . "',
						'" . $DelDate . "',
						'" . $PeriodNo . "',
						'" . $SalesGLAccounts['salesglcode'] . "',
						'" . $RecurrOrderRow['debtorno'] . " - " . $RecurrOrderLineRow['stkcode'] . " x " . $RecurrOrderLineRow['quantity'] . " @ " . $RecurrOrderLineRow['unitprice'] . "',
						'" . filter_number_format(-$RecurrOrderLineRow['unitprice'] * $RecurrOrderLineRow['quantity']/$CurrencyRate) . "'
					)";

				$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The sales GL posting could not be inserted because');
				$DbgMsg = '<br />' ._('The following SQL to insert the GLTrans record was used');
				$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

				/* Don't care about COGS because it can only be a dummy items being invoiced ... no cost of sales to mess with */

				if ($RecurrOrderLineRow['discountpercent'] !=0){

					$SQL = "INSERT INTO weberp_gltrans (
							type,
							typeno,
							trandate,
							periodno,
							account,
							narrative,
							amount
						)
						VALUES (
							'10',
							'" . $InvoiceNo . "',
							'" . $DelDate . "',
							'" . $PeriodNo . "',
							'" . $SalesGLAccounts['discountglcode'] . "',
							'" . $RecurrOrderRow['debtorno'] . " - " . $RecurrOrderLineRow['stkcode'] . ' @ ' . ($RecurrOrderLineRow['discountpercent'] * 100) . "%',
							'" . filter_number_format($RecurrOrderLineRow['unitprice'] * $RecurrOrderLineRow['quantity'] * $RecurrOrderLineRow['discountpercent']/$CurrencyRate) . "'
						)";

					$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The sales discount GL posting could not be inserted because');
					$DbgMsg = _('The following SQL to insert the GLTrans record was used');
					$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

				} /*end of if discount !=0 */

			} /*end of if sales integrated with gl */

			$LineCounter++;
		} /*end of OrderLine loop */

		$TotalInvLocalCurr = ($TotalFXNetInvoice + $TotalFXTax + $RecurrOrderRow['freightcost'])/$CurrencyRate;

		if ($_SESSION['CompanyRecord']['gllink_debtors']==1){

			/*Now post the tax to the GL at local currency equivalent */
			if ($_SESSION['CompanyRecord']['gllink_debtors']==1 AND $TaxAuthAmount !=0) {


				/*Loop through the tax authorities array to post each total to the taxauth glcode */
				foreach ($TaxTotals as $Tax){
					$SQL = "INSERT INTO weberp_gltrans (
											type,
											typeno,
											trandate,
											periodno,
											account,
											narrative,
											amount
											)
											VALUES (
											10,
											'" . $InvoiceNo . "',
											'" . $DelDate. "',
											'" . $PeriodNo . "',
											'" . $Tax['GLCode'] . "',
											'" . $RecurrOrderRow['debtorno'] . "-" . $Tax['TaxAuthDescription'] . "',
											'" . filter_number_format(-$Tax['FXAmount']/$CurrencyRate) . "'
											)";

					$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The tax GL posting could not be inserted because');
					$DbgMsg = _('The following SQL to insert the tax GLTrans record was used');
					$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);
				}
			}

			/*Post debtors transaction to GL debit debtors, credit freight re-charged and credit sales */
			if (($TotalInvLocalCurr) !=0) {
				$SQL = "INSERT INTO weberp_gltrans (
										type,
										typeno,
										trandate,
										periodno,
										account,
										narrative,
										amount
										)
									VALUES (
										'10',
										'" . $InvoiceNo . "',
										'" . $DelDate . "',
										'" . $PeriodNo . "',
										'" . $_SESSION['CompanyRecord']['debtorsact'] . "',
										'" . $RecurrOrderRow['debtorno'] . "',
										'" . filter_number_format($TotalInvLocalCurr) . "'
									)";

				$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The total debtor GL posting could not be inserted because');
				$DbgMsg = _('The following SQL to insert the total debtors control GLTrans record was used');
				$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);
			}

			/*Could do with setting up a more flexible freight posting schema that looks at the sales type and area of the customer branch to determine where to post the freight recovery */

			if ($RecurrOrderRow['freightcost'] !=0) {
				$SQL = "INSERT INTO weberp_gltrans (
											type,
											typeno,
											trandate,
											periodno,
											account,
											narrative,
											amount)
									VALUES (
										10,
										'" . $InvoiceNo . "',
										'" . $DelDate . "',
										'" . $PeriodNo . "',
										'" . $_SESSION['CompanyRecord']['freightact'] . "',
										'" . $RecurrOrderRow['debtorno'] . "',
										'" . filter_number_format(-$RecurrOrderRow['freightcost']/$CurrencyRate) . "'
									)";

				$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The freight GL posting could not be inserted because');
				$DbgMsg = _('The following SQL to insert the GLTrans record was used');
				$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);
			}
		} /*end of if Sales and GL integrated */

	/*Update order header for invoice charged on */
		$SQL = "UPDATE weberp_salesorders SET comments = CONCAT(comments,' Inv ','" . $InvoiceNo . "') WHERE orderno= '" . $OrderNo . "'";

		$ErrMsg = _('CRITICAL ERROR') . ' ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The sales order header could not be updated with the invoice number');
		$DbgMsg = _('The following SQL to update the sales order was used');
		$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

	/*Now insert the DebtorTrans */

		$SQL = "INSERT INTO weberp_debtortrans (
										transno,
										type,
										debtorno,
										branchcode,
										trandate,
										inputdate,
										prd,
										reference,
										tpe,
										order_,
										ovamount,
										ovgst,
										ovfreight,
										rate,
										invtext,
										shipvia)
									VALUES (
										'". $InvoiceNo . "',
										10,
										'" . $RecurrOrderRow['debtorno'] . "',
										'" . $RecurrOrderRow['branchcode'] . "',
										'" . $DelDate . "',
										'" . date('Y-m-d H-i-s') . "',
										'" . $PeriodNo . "',
										'" . $RecurrOrderRow['customerref'] . "',
										'" . $RecurrOrderRow['sales_type'] . "',
										'" . $OrderNo . "',
										'" . filter_number_format($TotalFXNetInvoice) . "',
										'" . filter_number_format($TotalFXTax) . "',
										'" . filter_number_format($RecurrOrderRow['freightcost']) . "',
										'" . filter_number_format($CurrencyRate) . "',
										'" . $RecurrOrderRow['comments'] . "',
										'" . $RecurrOrderRow['shipvia'] . "')";

		$ErrMsg =_('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The debtor transaction record could not be inserted because');
		$DbgMsg = _('The following SQL to insert the debtor transaction record was used');
		$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

		$DebtorTransID = DB_Last_Insert_ID($db,'weberp_debtortrans','id');


		$SQL = "INSERT INTO weberp_debtortranstaxes (debtortransid,
							taxauthid,
							taxamount)
				VALUES ('" . $DebtorTransID . "',
					'" . $TaxAuthID . "',
					'" . filter_number_format($Tax['FXAmount']/$CurrencyRate) . "')";

		$ErrMsg =_('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The debtor transaction taxes records could not be inserted because');
		$DbgMsg = _('The following SQL to insert the debtor transaction taxes record was used');
 		$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

		$Result = DB_Txn_Commit();

		prnMsg(_('Invoice number'). ' '. $InvoiceNo .' '. _('processed'),'success');

		$EmailText .= "\n" . _('This recurring order was set to produce the invoice automatically on invoice number') . ' ' . $InvoiceNo;
	} /*end if the recurring order is set to auto invoice */

	if (IsEmailAddress($RecurrOrderRow['email'])){
		$mail = new htmlMimeMail();
		$mail->setText($EmailText);
		$mail->setSubject(_('Recurring Order Created Advice'));
		if($_SESSION['SmtpSetting']==0){
			$mail->setFrom($_SESSION['CompanyRecord']['coyname'] . "<" . $_SESSION['CompanyRecord']['email'] . ">");
		
			$result = $mail->send(array($RecurrOrderRow['email']));
		}else{
			$result = SendmailBySmtp($mail,array($RecurrOrderRow['email']));

		}
		unset($mail);
	} else {
		prnMsg(_('No email advice was sent for this order because the location has no email contact defined with a valid email address'),'warn');
	}

}/*end while there are recurring orders due to have a new order created */

include('includes/footer.inc');
?>
