<?php

/* $Id: POReport.php 7256 2015-04-01 11:24:48Z exsonqu $ */

// POReport.php
// Inquiry on Purchase Orders
// If Date Type is Order, the main file is weberp_purchorderdetails
// If Date Type is Delivery, the main file is weberp_grns

include('includes/session.inc');
$Title = _('Purchase Order Report');
include('includes/header.inc');

# Sets default date range for current month
if (!isset($_POST['FromDate'])){
	$_POST['FromDate']=Date($_SESSION['DefaultDateFormat'], mktime(0,0,0,Date('m'),1,Date('Y')));
}
if (!isset($_POST['ToDate'])){
	$_POST['ToDate'] = Date($_SESSION['DefaultDateFormat']);
}

if (isset($_POST['submit']) or isset($_POST['submitcsv'])) {
	if (isset($_POST['PartNumber'])){
		$PartNumber = trim(mb_strtoupper($_POST['PartNumber']));
	} elseif (isset($_GET['PartNumber'])){
		$PartNumber = trim(mb_strtoupper($_GET['PartNumber']));
	}

	# Part Number operator - either LIKE or =
	$PartNumberOp = $_POST['PartNumberOp'];

	if (isset($_POST['SupplierId'])){
		$SupplierId = trim(mb_strtoupper($_POST['SupplierId']));
	} elseif (isset($_GET['SupplierId'])){
		$SupplierId = trim(mb_strtoupper($_GET['SupplierId']));
	}

	$SupplierIdOp = $_POST['SupplierIdOp'];

	$SupplierNameOp = $_POST['SupplierNameOp'];

	// Save $_POST['SummaryType'] in $SaveSummaryType because change $_POST['SummaryType'] when
	// create $sql
	$SaveSummaryType = $_POST['SummaryType'];
}

if (isset($_POST['SupplierName'])){
	$SupplierName = trim(mb_strtoupper($_POST['SupplierName']));
} elseif (isset($_GET['SupplierName'])){
	$SupplierName = trim(mb_strtoupper($_GET['SupplierName']));
}

// Had to add supplierid to SummaryType when do summary by name because there could be several accounts
// with the same name. Tried passing 'suppname,supplierid' in form, but it only read 'suppname'
if (isset($_POST['SummaryType']) and $_POST['SummaryType'] == 'suppname') {
	$_POST['SummaryType'] = "suppname, weberp_suppliers.supplierid";
}

if (isset($_POST['submit'])) {
	echo '<p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/maintenance.png" title="' . _('Search') .
		'" alt="" />' . ' ' . $Title . '</p>';
	submit($db,$PartNumber,$PartNumberOp,$SupplierId,$SupplierIdOp,$SupplierName,$SupplierNameOp,$SaveSummaryType);
} else if (isset($_POST['submitcsv'])) {
	echo '<p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/maintenance.png" title="' . _('Search') .
		'" alt="" />' . ' ' . $Title . '</p>';
	submitcsv($db,$PartNumber,$PartNumberOp,$SupplierId,$SupplierIdOp,$SupplierName,$SupplierNameOp,$SaveSummaryType);
} else {
	echo '<p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/maintenance.png" title="' . _('Search') .
		'" alt="" />' . $Title . '</p>';
	display($db);
}


//####_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT####
function submit(&$db,$PartNumber,$PartNumberOp,$SupplierId,$SupplierIdOp,$SupplierName,$SupplierNameOp,$SaveSummaryType) {

	global $RootPath;
	//initialize no input errors
	$InputError = 0;

	/* actions to take once the user has clicked the submit button
	ie the page has called itself with some user input */

	//first off validate inputs sensible

	if (!Is_Date($_POST['FromDate'])) {
		$InputError = 1;
		prnMsg(_('Invalid From Date'),'error');
	}
	if (!Is_Date($_POST['ToDate'])) {
		$InputError = 1;
		prnMsg(_('Invalid To Date'),'error');
	}

	# Add more to WHERE statement, if user entered something for the part number,supplierid, name
	$WherePart = ' ';
	if (mb_strlen($PartNumber) > 0 && $PartNumberOp == 'LIKE') {
		$PartNumber = $PartNumber . '%';
	} else {
		$PartNumberOp = '=';
	}
	if (mb_strlen($PartNumber) > 0) {
		$WherePart = " AND weberp_purchorderdetails.itemcode " . $PartNumberOp . " '" . $PartNumber . "'  ";
	} else {
		$WherePart=' ';
	}

	$WhereSupplierID = ' ';
	if ($SupplierIdOp == 'LIKE') {
		$SupplierId = $SupplierId . '%';
	} else {
		$SupplierIdOp = '=';
	}
	if (mb_strlen($SupplierId) > 0) {
		$WhereSupplierID = " AND weberp_purchorders.supplierno " . $SupplierIdOp . " '" . $SupplierId . "'  ";
	} else {
		$WhereSupplierID=' ';
	}

	$WhereSupplierName = ' ';
	if (mb_strlen($SupplierName) > 0 AND $SupplierNameOp == 'LIKE') {
		$SupplierName = $SupplierName . '%';
	} else {
		$SupplierNameOp = '=';
	}
	if (mb_strlen($SupplierName) > 0) {
		$WhereSupplierName = " AND weberp_suppliers.suppname " . $SupplierNameOp . " '" . $SupplierName . "'  ";
	} else {
		$WhereSupplierName=' ';
	}

	if (mb_strlen($_POST['OrderNo']) > 0) {
		$WhereOrderNo = " AND weberp_purchorderdetails.orderno = '" . $_POST['OrderNo'] . "'  ";
	} else {
		$WhereOrderNo=' ';
	}

	$WhereLineStatus = ' ';
	# Had to use IF statement instead of comparing 'linestatus' to $_POST['LineStatus']
	#in WHERE clause because the WHERE clause didn't recognize
	# that had used the IF statement to create a field called linestatus
	if ($_POST['LineStatus'] != 'All') {
		if ($_POST['DateType'] == 'Order') {
			$WhereLineStatus = " AND IF(weberp_purchorderdetails.quantityord = weberp_purchorderdetails.qtyinvoiced ||
			  weberp_purchorderdetails.completed = 1,'Completed','Open') = '" . $_POST['LineStatus'] . "'";
		 } else {
			$WhereLineStatus = " AND IF(weberp_grns.qtyrecd - weberp_grns.quantityinv <> 0,'Open','Completed') = '"
			. $_POST['LineStatus'] . "'";
		 }
	}


	$WhereCategory = ' ';
	if ($_POST['Category'] != 'All') {
		$WhereCategory = " AND weberp_stockmaster.categoryid = '" . $_POST['Category'] . "'";
	}

	if ($InputError !=1) {
		$FromDate = FormatDateForSQL($_POST['FromDate']);
		$ToDate = FormatDateForSQL($_POST['ToDate']);
		if ($_POST['ReportType'] == 'Detail') {
			if ($_POST['DateType'] == 'Order') {
				$sql = "SELECT weberp_purchorderdetails.orderno,
							   weberp_purchorderdetails.itemcode,
							   weberp_purchorderdetails.deliverydate,
							   weberp_purchorders.supplierno,
							   weberp_purchorders.orddate,
							   weberp_purchorderdetails.quantityord,
							   weberp_purchorderdetails.quantityrecd,
							   weberp_purchorderdetails.qtyinvoiced,
							   (weberp_purchorderdetails.quantityord * weberp_purchorderdetails.unitprice) as extprice,
							   (weberp_purchorderdetails.quantityord * weberp_purchorderdetails.stdcostunit) as extcost,
							   IF(weberp_purchorderdetails.quantityord = weberp_purchorderdetails.qtyinvoiced ||
								  weberp_purchorderdetails.completed = 1,'Completed','Open') as linestatus,
							   weberp_suppliers.suppname,
							   weberp_stockmaster.decimalplaces,
							   weberp_stockmaster.description
							   FROM weberp_purchorderdetails
						LEFT JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
						LEFT JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
						LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
						WHERE weberp_purchorders.orddate >='$FromDate'
						 AND weberp_purchorders.orddate <='$ToDate'
						$WherePart
						$WhereSupplierID
						$WhereSupplierName
						$WhereOrderNo
						$WhereLineStatus
						$WhereCategory
						ORDER BY " . $_POST['SortBy'];
			} else {
				// Selects by delivery date from weberp_grns
				$sql = "SELECT weberp_purchorderdetails.orderno,
							   weberp_purchorderdetails.itemcode,
							   weberp_grns.deliverydate,
							   weberp_purchorders.supplierno,
							   weberp_purchorders.orddate,
							   weberp_purchorderdetails.quantityord as quantityrecd,
							   weberp_grns.qtyrecd as quantityord,
							   weberp_grns.quantityinv as qtyinvoiced,
							   (weberp_grns.qtyrecd * weberp_purchorderdetails.unitprice) as extprice,
							   (weberp_grns.qtyrecd * weberp_grns.stdcostunit) as extcost,
							   IF(weberp_grns.qtyrecd - weberp_grns.quantityinv <> 0,'Open','Completed') as linestatus,
							   weberp_suppliers.suppname,
							   weberp_stockmaster.decimalplaces,
							   weberp_stockmaster.description
							   FROM weberp_grns
						LEFT JOIN weberp_purchorderdetails ON weberp_grns.podetailitem = weberp_purchorderdetails.podetailitem
						LEFT JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
						LEFT JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
						LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
						WHERE weberp_grns.deliverydate >='$FromDate'
						 AND weberp_grns.deliverydate <='$ToDate'
						$WherePart
						$WhereSupplierID
						$WhereSupplierName
						$WhereOrderNo
						$WhereLineStatus
						$WhereCategory
						ORDER BY " . $_POST['SortBy'];
			}
		} else {
			// sql for Summary report
			$orderby = $_POST['SummaryType'];
			// The following is because the 'extprice' summary is a special case - with the other
			// summaries, you group and order on the same field; with 'extprice', you are actually
			// grouping on the stkcode and ordering by extprice descending
			if ($_POST['SummaryType'] == 'extprice') {
				$_POST['SummaryType'] = 'itemcode';
				$orderby = 'extprice DESC';
			}
			if ($_POST['DateType'] == 'Order') {
				if ($_POST['SummaryType'] == 'extprice' || $_POST['SummaryType'] == 'itemcode') {
					$sql = "SELECT weberp_purchorderdetails.itemcode,
								   SUM(weberp_purchorderdetails.quantityord) as quantityord,
								   SUM(weberp_purchorderdetails.qtyinvoiced) as qtyinvoiced,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.stdcostunit) as extcost,
								   weberp_stockmaster.decimalplaces,
								   weberp_stockmaster.description
								   FROM weberp_purchorderdetails
							LEFT JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							LEFT JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							LEFT JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_purchorders.orddate >='$FromDate'
							 AND weberp_purchorders.orddate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							',weberp_stockmaster.decimalplaces,
							  weberp_stockmaster.description
							ORDER BY ' . $orderby;
				} elseif ($_POST['SummaryType'] == 'orderno') {
					$sql = "SELECT weberp_purchorderdetails.orderno,
								   weberp_purchorders.supplierno,
								   SUM(weberp_purchorderdetails.quantityord) as quantityord,
								   SUM(weberp_purchorderdetails.qtyinvoiced) as qtyinvoiced,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.stdcostunit) as extcost,
								   weberp_suppliers.suppname
								   FROM weberp_purchorderdetails
							LEFT JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							LEFT JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							LEFT JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_purchorders.orddate >='$FromDate'
							 AND weberp_purchorders.orddate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							',weberp_purchorders.supplierno,
							  weberp_suppliers.suppname
							ORDER BY ' . $orderby;
				} elseif ($_POST['SummaryType'] == 'supplierno' || $_POST['SummaryType'] == 'suppname,weberp_suppliers.supplierid') {
					$sql = "SELECT weberp_purchorders.supplierno,
								   SUM(weberp_purchorderdetails.quantityord) as quantityord,
								   SUM(weberp_purchorderdetails.qtyinvoiced) as qtyinvoiced,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.stdcostunit) as extcost,
								   weberp_suppliers.suppname
								   FROM weberp_purchorderdetails
							LEFT JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							LEFT JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							LEFT JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_purchorders.orddate >='$FromDate'
							 AND weberp_purchorders.orddate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							",weberp_purchorders.supplierno,
							  weberp_suppliers.suppname
							ORDER BY " . $orderby;
				} elseif ($_POST['SummaryType'] == 'month') {
					$sql = "SELECT EXTRACT(YEAR_MONTH from weberp_purchorders.orddate) as month,
								   CONCAT(MONTHNAME(weberp_purchorders.orddate),' ',YEAR(weberp_purchorders.orddate)) as monthname,
								   SUM(weberp_purchorderdetails.quantityord) as quantityord,
								   SUM(weberp_purchorderdetails.qtyinvoiced) as qtyinvoiced,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.stdcostunit) as extcost
								   FROM weberp_purchorderdetails
							LEFT JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							LEFT JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							LEFT JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_purchorders.orddate >='$FromDate'
							 AND weberp_purchorders.orddate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							", monthname
							ORDER BY " . $orderby;
				} elseif ($_POST['SummaryType'] == 'categoryid') {
					$sql = "SELECT SUM(weberp_purchorderdetails.quantityord) as quantityord,
								   SUM(weberp_purchorderdetails.qtyinvoiced) as qtyinvoiced,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.stdcostunit) as extcost,
								   weberp_stockmaster.categoryid,
								   weberp_stockcategory.categorydescription
								   FROM weberp_purchorderdetails
							LEFT JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							LEFT JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							LEFT JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_purchorders.orddate >='$FromDate'
							 AND weberp_purchorders.orddate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							", categorydescription
							ORDER BY " . $orderby;
				}
			} else {
					// Selects by delivery date from weberp_grns
				if ($_POST['SummaryType'] == 'extprice' || $_POST['SummaryType'] == 'itemcode') {
					$sql = "SELECT weberp_purchorderdetails.itemcode,
								   SUM(weberp_grns.qtyrecd) as quantityord,
								   SUM(weberp_grns.quantityinv) as qtyinvoiced,
								   SUM(weberp_grns.qtyrecd * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_grns.qtyrecd * weberp_grns.stdcostunit) as extcost,
								   weberp_stockmaster.description
								   FROM weberp_grns
							LEFT JOIN weberp_purchorderdetails ON weberp_grns.podetailitem = weberp_purchorderdetails.podetailitem
							LEFT JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							LEFT JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							LEFT JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_grns.deliverydate >='$FromDate'
							 AND weberp_grns.deliverydate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							", weberp_stockmaster.description
							ORDER BY " . $orderby;
				} elseif ($_POST['SummaryType'] == 'orderno') {
					$sql = "SELECT weberp_purchorderdetails.orderno,
								   weberp_purchorders.supplierno,
								   SUM(weberp_grns.qtyrecd) as quantityord,
								   SUM(weberp_grns.quantityinv) as qtyinvoiced,
								   SUM(weberp_grns.qtyrecd * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_grns.qtyrecd * weberp_grns.stdcostunit) as extcost,
								   weberp_suppliers.suppname
								   FROM weberp_grns
							LEFT JOIN weberp_purchorderdetails ON weberp_grns.podetailitem = weberp_purchorderdetails.podetailitem
							LEFT JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							LEFT JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							LEFT JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_grns.deliverydate >='$FromDate'
							 AND weberp_grns.deliverydate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							', weberp_purchorders.supplierno,
							   weberp_suppliers.suppname
							ORDER BY ' . $orderby;
				} elseif ($_POST['SummaryType'] == 'supplierno' || $_POST['SummaryType'] == 'suppname,weberp_suppliers.supplierid') {
					$sql = "SELECT weberp_purchorders.supplierno,
								   SUM(weberp_grns.qtyrecd) as quantityord,
								   SUM(weberp_grns.quantityinv) as qtyinvoiced,
								   SUM(weberp_grns.qtyrecd * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_grns.qtyrecd * weberp_grns.stdcostunit) as extcost,
								   weberp_suppliers.suppname
								   FROM weberp_grns
							LEFT JOIN weberp_purchorderdetails ON weberp_grns.podetailitem = weberp_purchorderdetails.podetailitem
							LEFT JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							LEFT JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							LEFT JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_grns.deliverydate >='$FromDate'
							 AND weberp_grns.deliverydate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							', weberp_purchorders.supplierno,
							   weberp_suppliers.suppname
							ORDER BY ' . $orderby;
				} elseif ($_POST['SummaryType'] == 'month') {
					$sql = "SELECT EXTRACT(YEAR_MONTH from weberp_purchorders.orddate) as month,
								   CONCAT(MONTHNAME(weberp_purchorders.orddate),' ',YEAR(weberp_purchorders.orddate)) as monthname,
								   SUM(weberp_grns.qtyrecd) as quantityord,
								   SUM(weberp_grns.quantityinv) as qtyinvoiced,
								   SUM(weberp_grns.qtyrecd * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_grns.qtyrecd * weberp_grns.stdcostunit) as extcost
								   FROM weberp_grns
							LEFT JOIN weberp_purchorderdetails ON weberp_grns.podetailitem = weberp_purchorderdetails.podetailitem
							LEFT JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							LEFT JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							LEFT JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_grns.deliverydate >='$FromDate'
							 AND weberp_grns.deliverydate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							',monthname
							ORDER BY ' . $orderby;
				} elseif ($_POST['SummaryType'] == 'categoryid') {
					$sql = "SELECT weberp_stockmaster.categoryid,
								   weberp_stockcategory.categorydescription,
								   SUM(weberp_grns.qtyrecd) as quantityord,
								   SUM(weberp_grns.quantityinv) as qtyinvoiced,
								   SUM(weberp_grns.qtyrecd * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_grns.qtyrecd * weberp_grns.stdcostunit) as extcost
								   FROM weberp_grns
							LEFT JOIN weberp_purchorderdetails ON weberp_grns.podetailitem = weberp_purchorderdetails.podetailitem
							LEFT JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							LEFT JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							LEFT JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_grns.deliverydate >='$FromDate'
							 AND weberp_grns.deliverydate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							",categorydescription
							ORDER BY " . $orderby;
				}
			}
		} // End of if ($_POST['ReportType']
		//echo "<br/>$sql<br/>";
		$ErrMsg = _('The SQL to find the parts selected failed with the message');
		$result = DB_query($sql,$ErrMsg);
		$ctr = 0;
		$TotalQty = 0;
		$TotalExtCost = 0;
		$TotalExtPrice = 0;
		$TotalInvQty = 0;

		// Create array for summary type to display in header. Access it with $SaveSummaryType
		$Summary_Array['orderno'] =  _('Order Number');
		$Summary_Array['itemcode'] =  _('Part Number');
		$Summary_Array['extprice'] =  _('Extended Price');
		$Summary_Array['supplierno'] =  _('Customer Number');
		$Summary_Array['suppname'] =  _('Customer Name');
		$Summary_Array['month'] =  _('Month');
		$Summary_Array['categoryid'] =  _('Stock Category');

		// Create array for sort for detail report to display in header
		$Detail_Array['weberp_purchorderdetails.orderno'] = _('Order Number');
		$Detail_Array['weberp_purchorderdetails.itemcode'] = _('Part Number');
		$Detail_Array['weberp_suppliers.supplierid,weberp_purchorderdetails.orderno'] = _('Supplier Number');
		$Detail_Array['weberp_suppliers.suppname,weberp_suppliers.supplierid,weberp_purchorderdetails.orderno'] = _('Supplier Name');

		// Display Header info
		echo '<table class="selection">';
		if ($_POST['ReportType'] == 'Summary') {
			$SortBy_Display = $Summary_Array[$SaveSummaryType];
		} else {
			$SortBy_Display = $Detail_Array[$_POST['SortBy']];
		}
		echo '<tr><th colspan="2">' . _('Header Details') . '</th></tr>';
		echo '<tr><td>' . _('Purchase Order Report') . '</td>
					<td>' . $_POST['ReportType'] . ' ' . _('By') . ' '.$SortBy_Display  . '</td></tr>';
		echo '<tr><td>' . _('Date Type') . '</td>
				<td>' . $_POST['DateType'] . '</td></tr>';
		echo '<tr><td>' . _('Date Range') . '</td>
				<td>' . $_POST['FromDate'] . ' ' . _('To') . ' ' .  $_POST['ToDate'] . '</td></tr>';
		if (mb_strlen(trim($PartNumber)) > 0) {
			echo '<tr><td>' . _('Part Number') . '</td>
					<td>' . $_POST['PartNumberOp'] . ' ' . $_POST['PartNumber'] . '</td></tr>';
		}
		if (mb_strlen(trim($_POST['SupplierId'])) > 0) {
			echo '<tr><td>' . _('Supplier Number') . '</td>
					<td>' . $_POST['SupplierIdOp'] . ' ' . $_POST['SupplierId'] . '</td></tr>';
		}
		if (mb_strlen(trim($_POST['SupplierName'])) > 0) {
			echo '<tr><td>' . _('Supplier Name') . '</td>
					<td>' . $_POST['SupplierNameOp'] . ' ' . $_POST['SupplierName'] . '</td></tr>';
		}
		echo '<tr><td>' . _('Line Item Status') . '</td>
				<td>' . $_POST['LineStatus'] . '</td></tr>';
		echo '<tr><td>' . _('Stock Category') . '</td>
				<td>' . $_POST['Category'] . '</td></tr></table>';

		if ($_POST['ReportType'] == 'Detail') {
			echo '<br /><table class="selection" width="98%">';
			if ($_POST['DateType'] == 'Order') {
				echo '<tr><th>' . _('Order No') . '</th>
						<th>' . _('Part Number') . '</th>
						<th>' . _('Order Date') . '</th>
						<th>' . _('Supplier No') . '</th>
						<th>' . _('Supplier Name') . '</th>
						<th>' . _('Order Qty') . '</th>
						<th>' . _('Qty Received') . '</th>
						<th>' . _('Extended Cost') . '</th>
						<th>' . _('Extended Price') . '</th>
						<th>' . _('Invoiced Qty') . '</th>
						<th>' . _('Line Status') . '</th>
						<th>' . _('Item Due') . '</th>
						<th>' . _('Part Description') . '</th>
						</tr>';

				$linectr = 0;
				$k = 0;
				while ($myrow = DB_fetch_array($result)) {
					if ($k==1){
						echo '<tr class="EvenTableRows">';
						$k=0;
					} else {
						echo '<tr class="OddTableRows">';
						$k++;
					}
					$linectr++;
				   // Detail for both DateType of Order
					printf('<td><a href="'. $RootPath . '/PO_OrderDetails.php?OrderNo=%s">%s</a></td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td class="number">%s</td>
							<td class="number">%s</td>
							<td class="number">%s</td>
							<td class="number">%s</td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							</tr>',
							$myrow['orderno'],
							$myrow['orderno'],
							$myrow['itemcode'],
							ConvertSQLDate($myrow['orddate']),
							$myrow['supplierno'],
							$myrow['suppname'],
							locale_number_format($myrow['quantityord'],$myrow['decimalplaces']),
							locale_number_format($myrow['quantityrecd'],$myrow['decimalplaces']),
							locale_number_format($myrow['extcost'],2),
							locale_number_format($myrow['extprice'],2),
							locale_number_format($myrow['qtyinvoiced'],$myrow['decimalplaces']),
							$myrow['linestatus'],
							ConvertSQLDate($myrow['deliverydate']),
							$myrow['description']);
							$LastDecimalPlaces = $myrow['decimalplaces'];
							$TotalQty += $myrow['quantityord'];
							$TotalExtCost += $myrow['extcost'];
							$TotalExtPrice += $myrow['extprice'];
							$TotalInvQty += $myrow['qtyinvoiced'];
				} //END WHILE LIST LOOP
				// Print totals
					printf('<tr>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td class="number">%s</td>
							<td class="number">%s</td>
							<td class="number">%s</td>
							<td class="number">%s</td>
							<td>%s</td>
							<td>%s</td>
							</tr>',
							_('Totals'),
							_('Lines - ') . $linectr,
							' ',
							' ',
							' ',
							locale_number_format($TotalQty,2),
							locale_number_format($TotalExtCost,2),
							locale_number_format($TotalExtPrice,2),
							locale_number_format($TotalInvQty,2),
							' ',
							' ');
			} else {
			  // Header for Date Type of Delivery Date
				echo '<tr>
						<th>' . _('Order No') . '</th>
						<th>' . _('Part Number') . '</th>
						<th>' . _('Order Date') . '</th>
						<th>' . _('Supplier No') . '</th>
						<th>' . _('Supplier Name') . '</th>
						<th>' . _('Order Qty') . '</th>
						<th>' . _('Received')  . '</th>
						<th>' . _('Extended Cost') . '</th>
						<th>' . _('Extended Price') . '</th>
						<th>' . _('Invoiced Qty') . '</th>
						<th>' . _('Line Status') . '</th>
						<th>' . _('Delivered') . '</th>
						<th>' . _('Part Description') . '</th>
						</tr>';

				$linectr = 0;
				$k = 0;
				while ($myrow = DB_fetch_array($result)) {
					if ($k==1){
						echo '<tr class="EvenTableRows">';
						$k=0;
					} else {
						echo '<tr class="OddTableRows">';
						$k++;
					}
					$linectr++;
				   // Detail for both DateType of Ship
				   // In sql, had to alias weberp_grns.qtyrecd as quantityord so could use same name here
					printf('<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td class="number">%s</td>
							<td class="number">%s</td>
							<td class="number">%s</td>
							<td class="number">%s</td>
							<td class="number">%s</td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							</tr>',
							$myrow['orderno'],
							$myrow['itemcode'],
							ConvertSQLDate($myrow['orddate']),
							$myrow['supplierno'],
							$myrow['suppname'],
							locale_number_format($myrow['quantityrecd'],$myrow['decimalplaces']),
							locale_number_format($myrow['quantityord'],$myrow['decimalplaces']),
							locale_number_format($myrow['extcost'],2),
							locale_number_format($myrow['extprice'],2),
							locale_number_format($myrow['qtyinvoiced'],$myrow['decimalplaces']),
							$myrow['linestatus'],
							ConvertSQLDate($myrow['deliverydate']),
							$myrow['description']);

					$LastDecimalPlaces = $myrow['decimalplaces'];
					$TotalQty += $myrow['quantityord'];
					$TotalExtCost += $myrow['extcost'];
					$TotalExtPrice += $myrow['extprice'];
					$TotalInvQty += $myrow['qtyinvoiced'];
				} //END WHILE LIST LOOP
				// Print totals
					printf('<tr>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td class="number">%s</td>
							<td class="number">%s</td>
							<td class="number">%s</td>
							<td class="number">%s</td>
							<td>%s</td>
							<td>%s</td>
							</tr>',
							_('Totals'),
							_('Lines - ') . $linectr,
							' ',
							' ',
							' ',
							locale_number_format($TotalQty,$LastDecimalPlaces),
							locale_number_format($TotalExtCost,2),
							locale_number_format($TotalExtPrice,2),
							locale_number_format($TotalInvQty,$LastDecimalPlaces),
							' ',
							' ');
			}
			echo '</table>';
		} else {
		  // Print summary stuff
			echo '<br /><table class="selection" width="98%">';
			$summarytype = $_POST['SummaryType'];
			// For SummaryType 'suppname' had to add supplierid to it for the GROUP BY in the sql,
			// but have to take it away for $myrow[$summarytype] to be valid
			// Set up description based on the Summary Type
			if ($summarytype == "suppname,weberp_suppliers.supplierid") {
				$summarytype = "suppname";
				$description = 'supplierno';
				$summaryheader = _('Supplier Name');
				$descriptionheader = _('Supplier Number');
			}
			if ($summarytype == 'itemcode' || $summarytype == 'extprice') {
				$description = 'description';
				$summaryheader = _('Part Number');
				$descriptionheader = _('Part Description');
			}
			if ($summarytype == 'supplierno') {
				$description = 'suppname';
				$summaryheader = _('Supplier Number');
				$descriptionheader = _('Supplier Name');
			}
			if ($summarytype == 'orderno') {
				$description = 'supplierno';
				$summaryheader = _('Order Number');
				$descriptionheader = _('Supplier Number');
			}
			if ($summarytype == 'categoryid') {
				$description = 'categorydescription';
				$summaryheader = _('Stock Category');
				$descriptionheader = _('Category Description');
			}
			$summarydesc = $summaryheader;
			if ($orderby == 'extprice DESC') {
				$summarydesc = _('Extended Price');
			}
			if ($summarytype == 'month') {
				$description = 'monthname';
				$summaryheader = _('Month');
				$descriptionheader = _('Month');
			}
			printf('<tr>
					<th>%s</th>
					<th>%s</th>
					<th>%s</th>
					<th>%s</th>
					<th>%s</th>
					<th>%s</th>
					</tr>',
				 _($summaryheader),
				 _($descriptionheader),
				 _('Quantity'),
				 _('Extended Cost'),
				 _('Extended Price'),
				 _('Invoiced Qty'));

				$suppname = ' ';
				$linectr = 0;
				$k=0;
			while ($myrow = DB_fetch_array($result)) {
				$linectr++;
				if ($summarytype == 'orderno') {
					$suppname = $myrow['suppname'];
				}
					if ($k==1){
						echo '<tr class="EvenTableRows">';
						$k=0;
					} else {
						echo '<tr class="OddTableRows">';
						$k++;
					}
				printf('<td>%s</td>
						<td>%s</td>
						<td class="number">%s</td>
						<td class="number">%s</td>
						<td class="number">%s</td>
						<td class="number">%s</td>
						</tr>',
						$myrow[$summarytype],
						$myrow[$description],
						$myrow['quantityord'],
						locale_number_format($myrow['extcost'],2),
						locale_number_format($myrow['extprice'],2),
						$myrow['qtyinvoiced'],
						$suppname);
				$TotalQty += $myrow['quantityord'];
				$TotalExtCost += $myrow['extcost'];
				$TotalExtPrice += $myrow['extprice'];
				$TotalInvQty += $myrow['qtyinvoiced'];
			} //END WHILE LIST LOOP
			// Print totals
				printf('<tr>
						<td>%s</td>
						<td>%s</td>
						<td class="number">%s</td>
						<td class="number">%s</td>
						<td class="number">%s</td>
						<td class="number">%s</td>
						</tr>',
						_('Totals'),
						_('Lines - ') . $linectr,
						locale_number_format($TotalQty,2),
						locale_number_format($TotalExtCost,2),
						locale_number_format($TotalExtPrice,2),
						locale_number_format($TotalInvQty,2),
						' ');
            echo '</table>';
		} // End of if ($_POST['ReportType']
		echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '" method="post">';
        echo '<div>';
		echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';
		echo '<input type="hidden" name="ReportType" value="'.$_POST['ReportType'].'" />';
		echo '<input type="hidden" name="DateType" value="'.$_POST['DateType'].'" />';
		echo '<input type="hidden" name="FromDate" value="'.$_POST['FromDate'].'" />';
		echo '<input type="hidden" name="ToDate" value="'.$_POST['ToDate'].'" />';
		echo '<input type="hidden" name="PartNumberOp" value="'.$_POST['PartNumberOp'].'" />';
		echo '<input type="hidden" name="PartNumber" value="'.$_POST['PartNumber'].'" />';
		echo '<input type="hidden" name="SupplierIdOp" value="'.$_POST['SupplierIdOp'].'" />';
		echo '<input type="hidden" name="SupplierId" value="'.$_POST['SupplierId'].'" />';
		echo '<input type="hidden" name="SupplierNameOp" value="'.$_POST['SupplierNameOp'].'" />';
		echo '<input type="hidden" name="SupplierName" value="'.$_POST['SupplierName'].'" />';
		echo '<input type="hidden" name="OrderNo" value="'.$_POST['OrderNo'].'" />';
		echo '<input type="hidden" name="LineStatus" value="'.$_POST['LineStatus'].'" />';
		echo '<input type="hidden" name="Category" value="'.$_POST['Category'].'" />';
		echo '<input type="hidden" name="SortBy" value="'.$_POST['SortBy'].'" />';
		echo '<input type="hidden" name="SummaryType" value="'.$_POST['SummaryType'].'" />';
		echo '<br /><div class="centre"><input type="submit" name="submitcsv" value="' . _('Export as csv file') . '" /></div>';
		echo '</div>
              </form>';
	} // End of if inputerror != 1
} // End of function submit()

//####_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT####
function submitcsv(&$db,
					$PartNumber,
					$PartNumberOp,
					$SupplierId,
					$SupplierIdOp,
					$SupplierName,
					$SupplierNameOp,
					$SaveSummaryType) {

	//initialize no input errors
	$InputError = 0;

	/* actions to take once the user has clicked the submit button
	ie the page has called itself with some user input */

	//first off validate inputs sensible

	if (!Is_Date($_POST['FromDate'])) {
		$InputError = 1;
		prnMsg(_('Invalid From Date'),'error');
	}
	if (!Is_Date($_POST['ToDate'])) {
		$InputError = 1;
		prnMsg(_('Invalid To Date'),'error');
	}

	# Add more to WHERE statement, if user entered something for the part number,supplierid, name
	$WherePart = ' ';
	if (mb_strlen($PartNumber) > 0 && $PartNumberOp == 'LIKE') {
		$PartNumber = $PartNumber . '%';
	} else {
		$PartNumberOp = '=';
	}
	if (mb_strlen($PartNumber) > 0) {
		$WherePart = " AND weberp_purchorderdetails.itemcode " . $PartNumberOp . " '" . $PartNumber . "'  ";
	} else {
		$WherePart=' ';
	}

	$WhereSupplierID = ' ';
	if ($SupplierIdOp == 'LIKE') {
		$SupplierId = $SupplierId . '%';
	} else {
		$SupplierIdOp = '=';
	}
	if (mb_strlen($SupplierId) > 0) {
		$WhereSupplierID = " AND weberp_purchorders.supplierno " . $SupplierIdOp . " '" . $SupplierId . "'  ";
	} else {
		$WhereSupplierID=' ';
	}

	$WhereSupplierName = ' ';
	if (mb_strlen($SupplierName) > 0 && $SupplierNameOp == 'LIKE') {
		$SupplierName = $SupplierName . '%';
	} else {
		$SupplierNameOp = '=';
	}
	if (mb_strlen($SupplierName) > 0) {
		$WhereSupplierName = " AND weberp_suppliers.suppname " . $SupplierNameOp . " '" . $SupplierName . "'  ";
	} else {
		$WhereSupplierName=' ';
	}

	if (mb_strlen($_POST['OrderNo']) > 0) {
		$WhereOrderNo = " AND weberp_purchorderdetails.orderno = '" . $_POST['OrderNo'] . "'  ";
	} else {
		$WhereOrderNo=' ';
	}

	$WhereLineStatus = ' ';
	# Had to use IF statement instead of comparing 'linestatus' to $_POST['LineStatus']
	#in WHERE clause because the WHERE clause didn't recognize
	# that had used the IF statement to create a field called linestatus
	if ($_POST['LineStatus'] != 'All') {
		if ($_POST['DateType'] == 'Order') {
			$WhereLineStatus = " AND IF(weberp_purchorderdetails.quantityord = weberp_purchorderdetails.qtyinvoiced ||
			  weberp_purchorderdetails.completed = 1,'Completed','Open') = '" . $_POST['LineStatus'] . "'";
		 } else {
			$WhereLineStatus = " AND IF(weberp_grns.qtyrecd - weberp_grns.quantityinv <> 0,'Open','Completed') = '"
			. $_POST['LineStatus'] . "'";
		 }
	}


	$WhereCategory = ' ';
	if ($_POST['Category'] != 'All') {
		$WhereCategory = " AND weberp_stockmaster.categoryid = '" . $_POST['Category'] . "'";
	}

	if ($InputError !=1) {
		$FromDate = FormatDateForSQL($_POST['FromDate']);
		$ToDate = FormatDateForSQL($_POST['ToDate']);
		if ($_POST['ReportType'] == 'Detail') {
			if ($_POST['DateType'] == 'Order') {
				$sql = "SELECT weberp_purchorderdetails.orderno,
							   weberp_purchorderdetails.itemcode,
							   weberp_purchorderdetails.deliverydate,
							   weberp_purchorders.supplierno,
							   weberp_purchorders.orddate,
							   weberp_purchorderdetails.quantityrecd,
							   weberp_purchorderdetails.quantityord,
							   weberp_purchorderdetails.qtyinvoiced,
							   (weberp_purchorderdetails.quantityord * weberp_purchorderdetails.unitprice) as extprice,
							   (weberp_purchorderdetails.quantityord * weberp_purchorderdetails.stdcostunit) as extcost,
							   IF(weberp_purchorderdetails.quantityord = weberp_purchorderdetails.qtyinvoiced ||
								  weberp_purchorderdetails.completed = 1,'Completed','Open') as linestatus,
							   weberp_suppliers.suppname,
							   weberp_stockmaster.decimalplaces,
							   weberp_stockmaster.description
							   FROM weberp_purchorderdetails
						INNER JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
						INNER JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
						LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
						WHERE weberp_purchorders.orddate >='$FromDate'
						 AND weberp_purchorders.orddate <='$ToDate'
						$WherePart
						$WhereSupplierID
						$WhereSupplierName
						$WhereOrderNo
						$WhereLineStatus
						$WhereCategory
						ORDER BY " . $_POST['SortBy'];
			} else {
				// Selects by delivery date from weberp_grns
				$sql = "SELECT weberp_purchorderdetails.orderno,
							   weberp_purchorderdetails.itemcode,
							   weberp_grns.deliverydate,
							   weberp_purchorders.supplierno,
							   weberp_purchorders.orddate,
							   weberp_purchorderdetails.quantityord as quantityrecd,
							   weberp_grns.qtyrecd as quantityord,
							   weberp_grns.quantityinv as qtyinvoiced,
							   (weberp_grns.qtyrecd * weberp_purchorderdetails.unitprice) as extprice,
							   (weberp_grns.qtyrecd * weberp_grns.stdcostunit) as extcost,
							   IF(weberp_grns.qtyrecd - weberp_grns.quantityinv <> 0,'Open','Completed') as linestatus,
							   weberp_suppliers.suppname,
							   weberp_stockmaster.decimalplaces,
							   weberp_stockmaster.description
							   FROM weberp_grns
						LEFT JOIN weberp_purchorderdetails ON weberp_grns.podetailitem = weberp_purchorderdetails.podetailitem
						INNER JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
						INNER JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
						LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
						WHERE weberp_grns.deliverydate >='$FromDate'
						 AND weberp_grns.deliverydate <='$ToDate'
						$WherePart
						$WhereSupplierID
						$WhereSupplierName
						$WhereOrderNo
						$WhereLineStatus
						$WhereCategory
						ORDER BY " . $_POST['SortBy'];
		   }
		} else {
		  // sql for Summary report
		  $orderby = $_POST['SummaryType'];
		  // The following is because the 'extprice' summary is a special case - with the other
		  // summaries, you group and order on the same field; with 'extprice', you are actually
		  // grouping on the stkcode and ordering by extprice descending
		  if ($_POST['SummaryType'] == 'extprice') {
			  $_POST['SummaryType'] = 'itemcode';
			  $orderby = 'extprice DESC';
		  }
		  if ($_POST['DateType'] == 'Order') {
				if ($_POST['SummaryType'] == 'extprice' || $_POST['SummaryType'] == 'itemcode') {
					$sql = "SELECT weberp_purchorderdetails.itemcode,
								   SUM(weberp_purchorderdetails.quantityord) as quantityord,
								   SUM(weberp_purchorderdetails.qtyinvoiced) as qtyinvoiced,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.stdcostunit) as extcost,
								   weberp_stockmaster.decimalplaces,
								   weberp_stockmaster.description
								   FROM weberp_purchorderdetails
							INNER JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							INNER JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							INNER JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_purchorders.orddate >='$FromDate'
							 AND weberp_purchorders.orddate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							",weberp_stockmaster.decimalplaces,
							  weberp_stockmaster.description
							ORDER BY " . $orderby;
			   } elseif ($_POST['SummaryType'] == 'orderno') {
					$sql = "SELECT weberp_purchorderdetails.orderno,
								   weberp_purchorders.supplierno,
								   SUM(weberp_purchorderdetails.quantityord) as quantityord,
								   SUM(weberp_purchorderdetails.qtyinvoiced) as qtyinvoiced,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.stdcostunit) as extcost,
								   weberp_suppliers.suppname
								   FROM weberp_purchorderdetails
							INNER JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							INNER JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							INNER JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_purchorders.orddate >='$FromDate'
							 AND weberp_purchorders.orddate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							",weberp_purchorders.supplierno,
							  weberp_suppliers.suppname
							ORDER BY " . $orderby;
			} elseif ($_POST['SummaryType'] == 'supplierno' || $_POST['SummaryType'] == 'suppname,weberp_suppliers.supplierid') {
					$sql = "SELECT weberp_purchorders.supplierno,
								   SUM(weberp_purchorderdetails.quantityord) as quantityord,
								   SUM(weberp_purchorderdetails.qtyinvoiced) as qtyinvoiced,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.stdcostunit) as extcost,
								   weberp_suppliers.suppname
								   FROM weberp_purchorderdetails
							INNER JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							INNER JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							INNER JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_purchorders.orddate >='$FromDate'
							 AND weberp_purchorders.orddate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							",weberp_purchorders.supplierno,
							  weberp_suppliers.suppname
							ORDER BY " . $orderby;
			} elseif ($_POST['SummaryType'] == 'month') {
					$sql = "SELECT EXTRACT(YEAR_MONTH from weberp_purchorders.orddate) as month,
								   CONCAT(MONTHNAME(weberp_purchorders.orddate),' ',YEAR(weberp_purchorders.orddate)) as monthname,
								   SUM(weberp_purchorderdetails.quantityord) as quantityord,
								   SUM(weberp_purchorderdetails.qtyinvoiced) as qtyinvoiced,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.stdcostunit) as extcost
								   FROM weberp_purchorderdetails
							INNER JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							INNER JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							INNER JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_purchorders.orddate >='$FromDate'
							 AND weberp_purchorders.orddate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							", monthname
							ORDER BY " . $orderby;
			} elseif ($_POST['SummaryType'] == 'categoryid') {
					$sql = "SELECT SUM(weberp_purchorderdetails.quantityord) as quantityord,
								   SUM(weberp_purchorderdetails.qtyinvoiced) as qtyinvoiced,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_purchorderdetails.quantityord * weberp_purchorderdetails.stdcostunit) as extcost,
								   weberp_stockmaster.categoryid,
								   weberp_stockcategory.categorydescription
								   FROM weberp_purchorderdetails
							INNER JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							INNER JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							INNER JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_purchorders.orddate >='$FromDate'
							 AND weberp_purchorders.orddate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							", categorydescription
							ORDER BY " . $orderby;
			}
		} else {
					// Selects by delivery date from weberp_grns
				if ($_POST['SummaryType'] == 'extprice' || $_POST['SummaryType'] == 'itemcode') {
					$sql = "SELECT weberp_purchorderdetails.itemcode,
								   SUM(weberp_grns.qtyrecd) as quantityord,
								   SUM(weberp_grns.quantityinv) as qtyinvoiced,
								   SUM(weberp_grns.qtyrecd * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_grns.qtyrecd * weberp_grns.stdcostunit) as extcost,
								   weberp_stockmaster.description
								   FROM weberp_grns
							LEFT JOIN weberp_purchorderdetails ON weberp_grns.podetailitem = weberp_purchorderdetails.podetailitem
							INNER JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							INNER JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							LEFT JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_grns.deliverydate >='$FromDate'
							 AND weberp_grns.deliverydate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							", weberp_stockmaster.description
							ORDER BY " . $orderby;
				} elseif ($_POST['SummaryType'] == 'orderno') {
					$sql = "SELECT weberp_purchorderdetails.orderno,
								   weberp_purchorders.supplierno,
								   SUM(weberp_grns.qtyrecd) as quantityord,
								   SUM(weberp_grns.quantityinv) as qtyinvoiced,
								   SUM(weberp_grns.qtyrecd * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_grns.qtyrecd * weberp_grns.stdcostunit) as extcost,
								   weberp_suppliers.suppname
								   FROM weberp_grns
							LEFT JOIN weberp_purchorderdetails ON weberp_grns.podetailitem = weberp_purchorderdetails.podetailitem
							INNER JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							INNER JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							INNER JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_grns.deliverydate >='$FromDate'
							 AND weberp_grns.deliverydate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							", weberp_purchorders.supplierno,
							   weberp_suppliers.suppname
							ORDER BY " . $orderby;
			} elseif ($_POST['SummaryType'] == 'supplierno' || $_POST['SummaryType'] == 'suppname,weberp_suppliers.supplierid') {
					$sql = "SELECT weberp_purchorders.supplierno,
								   SUM(weberp_grns.qtyrecd) as quantityord,
								   SUM(weberp_grns.quantityinv) as qtyinvoiced,
								   SUM(weberp_grns.qtyrecd * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_grns.qtyrecd * weberp_grns.stdcostunit) as extcost,
								   weberp_suppliers.suppname
								   FROM weberp_grns
							LEFT JOIN weberp_purchorderdetails ON weberp_grns.podetailitem = weberp_purchorderdetails.podetailitem
							INNER JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							INNER JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							INNER JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_grns.deliverydate >='$FromDate'
							 AND weberp_grns.deliverydate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							", weberp_purchorders.supplierno,
							   weberp_suppliers.suppname
							ORDER BY " . $orderby;
				} elseif ($_POST['SummaryType'] == 'month') {
					$sql = "SELECT EXTRACT(YEAR_MONTH from weberp_purchorders.orddate) as month,
								   CONCAT(MONTHNAME(weberp_purchorders.orddate),' ',YEAR(weberp_purchorders.orddate)) as monthname,
								   SUM(weberp_grns.qtyrecd) as quantityord,
								   SUM(weberp_grns.quantityinv) as qtyinvoiced,
								   SUM(weberp_grns.qtyrecd * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_grns.qtyrecd * weberp_grns.stdcostunit) as extcost
								   FROM weberp_grns
							LEFT JOIN weberp_purchorderdetails ON weberp_grns.podetailitem = weberp_purchorderdetails.podetailitem
							INNER JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							INNER JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							INNER JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_grns.deliverydate >='$FromDate'
							 AND weberp_grns.deliverydate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							",monthname
							ORDER BY " . $orderby;
				} elseif ($_POST['SummaryType'] == 'categoryid') {
					$sql = "SELECT weberp_stockmaster.categoryid,
								   weberp_stockcategory.categorydescription,
								   SUM(weberp_grns.qtyrecd) as quantityord,
								   SUM(weberp_grns.quantityinv) as qtyinvoiced,
								   SUM(weberp_grns.qtyrecd * weberp_purchorderdetails.unitprice) as extprice,
								   SUM(weberp_grns.qtyrecd * weberp_grns.stdcostunit) as extcost
								   FROM weberp_grns
							LEFT JOIN weberp_purchorderdetails ON weberp_grns.podetailitem = weberp_purchorderdetails.podetailitem
							INNER JOIN weberp_purchorders ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
							INNER JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							LEFT JOIN weberp_stockmaster ON weberp_purchorderdetails.itemcode = weberp_stockmaster.stockid
							INNER JOIN weberp_stockcategory ON weberp_stockcategory.categoryid = weberp_stockmaster.categoryid
							WHERE weberp_grns.deliverydate >='$FromDate'
							 AND weberp_grns.deliverydate <='$ToDate'
							$WherePart
							$WhereSupplierID
							$WhereSupplierName
							$WhereOrderNo
							$WhereLineStatus
							$WhereCategory
							GROUP BY " . $_POST['SummaryType'] .
							",categorydescription
							ORDER BY " . $orderby;
				}
			}
		} // End of if ($_POST['ReportType']
		//echo "<br/>$sql<br/>";
		$ErrMsg = _('The SQL to find the parts selected failed with the message');
		$result = DB_query($sql,$ErrMsg);
		$ctr = 0;
		$TotalQty = 0;
		$TotalExtCost = 0;
		$TotalExtPrice = 0;
		$TotalInvQty = 0;
		$FileName = $_SESSION['reports_dir'] .'/POReport.csv';
		$FileHandle = fopen($FileName, 'w');
		// Create array for summary type to display in header. Access it with $SaveSummaryType
		$Summary_Array['orderno'] =  _('Order Number');
		$Summary_Array['itemcode'] =  _('Part Number');
		$Summary_Array['extprice'] =  _('Extended Price');
		$Summary_Array['supplierno'] =  _('Customer Number');
		$Summary_Array['suppname'] =  _('Customer Name');
		$Summary_Array['month'] =  _('Month');
		$Summary_Array['categoryid'] =  _('Stock Category');

		// Create array for sort for detail report to display in header
		$Detail_Array['weberp_purchorderdetails.orderno'] = _('Order Number');
		$Detail_Array['weberp_purchorderdetails.itemcode'] = _('Part Number');
		$Detail_Array['weberp_suppliers.supplierid,weberp_purchorderdetails.orderno'] = _('Supplier Number');
		$Detail_Array['weberp_suppliers.suppname,weberp_suppliers.supplierid,weberp_purchorderdetails.orderno'] = _('Supplier Name');

		// Display Header info
		if ($_POST['ReportType'] == 'Summary') {
			$SortBy_Display = $Summary_Array[$SaveSummaryType];
		} else {
			$SortBy_Display = $Detail_Array[$_POST['SortBy']];
		}
		fprintf($FileHandle, '"'. _('Purchase Order Report') . '","' . $_POST['ReportType'] . ' '._('By').' '.$SortBy_Display ."\n");
		fprintf($FileHandle, '"'. _('Date Type') . '","' . $_POST['DateType'] . '"'. "\n");
		fprintf($FileHandle, '"'. _('Date Range') . '","' . $_POST['FromDate'] . _(' To ') .  $_POST['ToDate'] . '"'."\n");
		if (mb_strlen(trim($PartNumber)) > 0) {
			fprintf($FileHandle, '"'. _('Part Number') . '","' . $_POST['PartNumberOp'] . ' ' . $_POST['PartNumber'] . '"'."\n");
		}
		if (mb_strlen(trim($_POST['SupplierId'])) > 0) {
			fprintf($FileHandle, '"'. _('Supplier Number') . '","' . $_POST['SupplierIdOp'] . ' ' . $_POST['SupplierId'] . '"'."\n");
		}
		if (mb_strlen(trim($_POST['SupplierName'])) > 0) {
			fprintf($FileHandle, '"'. _('Supplier Name') . '","' . $_POST['SupplierNameOp'] . ' ' . $_POST['SupplierName'] . '"'."\n");
		}
		fprintf($FileHandle, '"'._('Line Item Status') . '","' . $_POST['LineStatus'] . '"'."\n");
		fprintf($FileHandle, '"'. _('Stock Category') . '","' . $_POST['Category'] . '"'."\n");

		if ($_POST['ReportType'] == 'Detail') {
			if ($_POST['DateType'] == 'Order') {
				fprintf($FileHandle, '"%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s"'."\n",
					 _('Order No'),
					 _('Part Number'),
					 _('Order Date'),
					 _('Supplier No'),
					 _('Supplier Name'),
					 _('Order Qty'),
					 _('Qty Received'),
					 _('Extended Cost'),
					 _('Extended Price'),
					 _('Invoiced Qty'),
					 _('Line Status'),
					 _('Item Due'),
					 _('Part Description'));
					$linectr = 0;
				while ($myrow = DB_fetch_array($result)) {
					$linectr++;
				   // Detail for both DateType of Order
					fprintf($FileHandle, '"%s","%s","%s","%s","%s",%s,%s,%s,%s,%s,"%s","%s","%s"'."\n",
					$myrow['orderno'],
					$myrow['itemcode'],
					ConvertSQLDate($myrow['orddate']),
					$myrow['supplierno'],
					str_replace(',',' ',$myrow['suppname']),
					round($myrow['quantityord'],$myrow['decimalplaces']),
					round($myrow['quantityrecd'],$myrow['decimalplaces']),
					round($myrow['extcost'],2),
					round($myrow['extprice'],2),
					round($myrow['qtyinvoiced'],$myrow['decimalplaces']),
					$myrow['linestatus'],
					ConvertSQLDate($myrow['deliverydate']),
					str_replace(',',' ',$myrow['description']));
					$LastDecimalPlaces = $myrow['decimalplaces'];
					$TotalQty += $myrow['quantityord'];
					$TotalExtCost += $myrow['extcost'];
					$TotalExtPrice += $myrow['extprice'];
					$TotalInvQty += $myrow['qtyinvoiced'];
				} //END WHILE LIST LOOP
				// Print totals
					fprintf($FileHandle, '"%s","%s","%s","%s","%s",%s,%s,%s,%s,"%s","%s"'."\n",
					'Totals',
					_('Lines - ') . $linectr,
					' ',
					' ',
					' ',
					round($TotalQty,2),
					round($TotalExtCost,2),
					round($TotalExtPrice,2),
					round($TotalInvQty,2),
					' ',
					' ');
			} else {
			  // Header for Date Type of Delivery Date
				fprintf($FileHandle, '"%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s"'."\n",
					_('Order No'), 
					_('Part Number'),
					 _('Order Date'),
					 _('Supplier No'),
					 _('Supplier Name'),
					 _('Order Qty'),
					 _('Received'),
					 _('Extended Cost'),
					 _('Extended Price'),
					 _('Invoiced Qty'),
					 _('Line Status'),
					 _('Delivered'),
					 _('Part Description'));
					$linectr = 0;
				while ($myrow = DB_fetch_array($result)) {
					$linectr++;
				   // Detail for both DateType of Ship
				   // In sql, had to alias weberp_grns.qtyrecd as quantityord so could use same name here
					fprintf($FileHandle, '"%s","%s","%s","%s","%s",%s,%s,%s,%s,%s,"%s","%s","%s"'."\n",
					$myrow['orderno'],
					$myrow['itemcode'],
					ConvertSQLDate($myrow['orddate']),
					$myrow['supplierno'],
					str_replace(',',' ',$myrow['suppname']),
					round($myrow['quantityrecd'],$myrow['decimalplaces']),
					round($myrow['quantityord'],$myrow['decimalplaces']),
					round($myrow['extcost'],2),
					round($myrow['extprice'],2),
					round($myrow['qtyinvoiced'],$myrow['decimalplaces']),
					$myrow['linestatus'],
					ConvertSQLDate($myrow['deliverydate']),
					str_replace(',',' ',$myrow['description']));
					$LastDecimalPlaces = $myrow['decimalplaces'];
					$TotalQty += $myrow['quantityord'];
					$TotalExtCost += $myrow['extcost'];
					$TotalExtPrice += $myrow['extprice'];
					$TotalInvQty += $myrow['qtyinvoiced'];
				} //END WHILE LIST LOOP
				// Print totals
					fprintf($FileHandle, '"%s","%s","%s","%s","%s",%s,%s,%s,%s,"%s","%s"'."\n",
					'Totals',
					_('Lines - ') . $linectr,
					' ',
					' ',
					' ',
					round($TotalQty,$LastDecimalPlaces),
					round($TotalExtCost,2),
					round($TotalExtPrice,2),
					round($TotalInvQty,$LastDecimalPlaces),
					" ",
					" ");
			}
		} else {
		  // Print summary stuff
			$summarytype = $_POST['SummaryType'];
			// For SummaryType 'suppname' had to add supplierid to it for the GROUP BY in the sql,
			// but have to take it away for $myrow[$summarytype] to be valid
			// Set up description based on the Summary Type
			if ($summarytype == 'suppname,weberp_suppliers.supplierid') {
				$summarytype = 'suppname';
				$description = 'supplierno';
				$summaryheader = _('Supplier Name');
				$descriptionheader = _('Supplier Number');
			}
			if ($summarytype == 'itemcode' || $summarytype == 'extprice') {
				$description = 'description';
				$summaryheader = _('Part Number');
				$descriptionheader = _('Part Description');
			}
			if ($summarytype == 'supplierno') {
				$description = 'suppname';
				$summaryheader = _('Supplier Number');
				$descriptionheader = _('Supplier Name');
			}
			if ($summarytype == 'orderno') {
				$description = 'supplierno';
				$summaryheader = _('Order Number');
				$descriptionheader = _('Supplier Number');
			}
			if ($summarytype == 'categoryid') {
				$description = 'categorydescription';
				$summaryheader = _('Stock Category');
				$descriptionheader = _('Category Description');
			}
			$summarydesc = $summaryheader;
			if ($orderby == 'extprice DESC') {
				$summarydesc = _('Extended Price');
			}
			if ($summarytype == 'month') {
				$description = 'monthname';
				$summaryheader = _('Month');
				$descriptionheader = _('Month');
			}
			fprintf($FileHandle, '"%s","%s","%s","%s","%s","%s"'."\n",
				 _($summaryheader),
				 _($descriptionheader),
				 _('Quantity'),
				 _('Extended Cost'),
				 _('Extended Price'),
				 _('Invoiced Qty'));

				$suppname = ' ';
				$linectr = 0;
			while ($myrow = DB_fetch_array($result)) {
				$linectr++;
				if ($summarytype == 'orderno') {
					$suppname = $myrow['suppname'];
				}
				fprintf($FileHandle, '"%s","%s",%s,%s,%s,%s,"%s"'."\n",
				$myrow[$summarytype],
				$myrow[$description],
				round($myrow['quantityord'],$myrow['decimalplaces']),
				round($myrow['extcost'],2),
				round($myrow['extprice'],2),
				round($myrow['qtyinvoiced'],$myrow['decimalplaces']),
				$suppname);
				print '<br/>';
				$LastDecimalPlaces = $myrow['decimalplaces'];
				$TotalQty += $myrow['quantityord'];
				$TotalExtCost += $myrow['extcost'];
				$TotalExtPrice += $myrow['extprice'];
				$TotalInvQty += $myrow['qtyinvoiced'];
			} //END WHILE LIST LOOP
			// Print totals
				fprintf($FileHandle, '"%s","%s",%s,%s,%s,%s,"%s"'."\n",
				'Totals',
				_('Lines - ') . $linectr,
				round($TotalQty,$LastDecimalPlaces),
				round($TotalExtCost,2),
				round($TotalExtPrice,2),
				round($TotalInvQty,$LastDecimalPlaces),
				' ');
		} // End of if ($_POST['ReportType']
		fclose($FileHandle);
		echo '<div class="centre"><p>' . _('The report has been exported as a csv file.') . '</p>';
		echo '<p><a href="' .  $FileName . '">' . _('click here') . '</a> ' . _('to view the file') . '</div></p>';

	} // End of if inputerror != 1
} // End of function submitcvs()


function display(&$db)  //####DISPLAY_DISPLAY_DISPLAY_DISPLAY_DISPLAY_DISPLAY_#####
{
// Display form fields. This function is called the first time
// the page is called.

	echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '" method="post">';
    echo '<div>';
	echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />
		<table class="selection">
		<tr>
			<td>' . _('Report Type') . ':</td>
			<td><select required="required" autofocus="autofocus" name="ReportType">
				<option selected="selected" value="Detail">' . _('Detail') . '</option>
				<option value="Summary">' . _('Summary') . '</option>
				</select></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>' . _('Date Type') . ':</td>
			<td><select required="required" name="DateType">
				<option selected="selected" value="Order">' . _('Order Date') . '</option>
				<option value="Delivery">' . _('Delivery Date') . '</option>
				</select></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>' . _('Date Range') . ':</td>
			<td><input type="text" required="required" class="date" alt="' . $_SESSION['DefaultDateFormat'] . '" name="FromDate" size="10" maxlength="10" value="' . $_POST['FromDate'] .'" /> ' . _('To') . ':&nbsp;&nbsp;
        <input type="text" required="required" class="date" alt="' . $_SESSION['DefaultDateFormat'] . '" name="ToDate" size="10" maxlength="10" value="' . $_POST['ToDate'] . '" /></td>
		</tr>
		<tr>
			<td>' . _('Part Number') . ':</td>
			<td><select name="PartNumberOp">
				<option selected="selected" value="Equals">' . _('Equals') . '</option>
				<option value="LIKE">' . _('Begins With') . '</option>
				</select>
				&nbsp;&nbsp;
				<input type="text" name="PartNumber" size="20" maxlength="20" value="';
    if (isset($_POST['PartNumber'])) {
        echo $_POST['PartNumber'] . '" /></td>
			</tr>';
	} else {
		echo '" /></td>
			</tr>';
	}

	echo '<tr>
			<td>' . _('Supplier Number') . ':</td>
			<td><select name="SupplierIdOp">
				<option selected="selected" value="Equals">' . _('Equals') . '</option>
				<option value="LIKE">' . _('Begins With') . '</option>
				</select>
				&nbsp;&nbsp;
				<input type="text" name="SupplierId" size="10" maxlength="10" value="';
    if (isset($_POST['SupplierId'])) {
        echo $_POST['SupplierId'] . '" /></td>
				</tr>';
	} else {
		echo  '" /></td>
			</tr>';
	}

	echo '<tr>
			<td>' . _('Supplier Name') . ':</td>
			<td><select name="SupplierNameOp">
				<option selected="selected" value="LIKE">' . _('Begins With') . '</option>
				<option value="Equals">' . _('Equals') . '</option>
				</select>
				&nbsp;&nbsp;
				<input type="text" name="SupplierName" size="30" maxlength="30" value="';
	if (isset($_POST['SupplierName'])) {
		echo $_POST['SupplierName'] . '" /></td>
			</tr>';
	} else {
		echo  '" /></td>
			</tr>';
	}

	echo '<tr>
			<td>' . _('Order Number') . ':</td>
			<td>' . _('Equals').':&nbsp;&nbsp;<input type="text" name="OrderNo" size="10" maxlength="10" value="';
    if (isset($_POST['OrderNo'])) {
        echo $_POST['OrderNo'] . '" /></td>
				</tr>';
	} else {
		echo  '" /></td>
				</tr>';
	}

	echo '<tr>
			<td>' . _('Line Item Status') . ':</td>
			<td><select name="LineStatus">
				<option selected="selected" value="All">' . _('All') . '</option>
				<option value="Completed">' . _('Completed') . '</option>
				<option value="Open">' . _('Not Completed') . '</option>
				</select></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>' . _('Stock Categories') . ':</td>
			<td><select name="Category">';
	$sql="SELECT categoryid, categorydescription FROM weberp_stockcategory";
	$CategoryResult= DB_query($sql);
	echo '<option selected="selected" value="All">' . _('All Categories') . '</option>';
	While ($myrow = DB_fetch_array($CategoryResult)){
		echo '<option value="' . $myrow['categoryid'] . '">' . $myrow['categorydescription'] . '</option>';
	}
	echo '</select></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>' . _('Sort By') . ':</td>
			<td><select name="SortBy">
				<option selected="selected" value="weberp_purchorderdetails.orderno">' . _('Order Number') . '</option>
				<option value="weberp_purchorderdetails.itemcode">' . _('Part Number') . '</option>
				<option value="weberp_suppliers.supplierid,weberp_purchorderdetails.orderno">' . _('Supplier Number') . '</option>
				<option value="weberp_suppliers.suppname,weberp_suppliers.supplierid,weberp_purchorderdetails.orderno">' . _('Supplier Name') . '</option>
				</select></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>' . _('Summary Type') . ':</td>
			<td><select name="SummaryType">
				<option selected="selected" value="orderno">' . _('Order Number') . '</option>
				<option value="itemcode">' . _('Part Number') . '</option>
				<option value="extprice">' . _('Extended Price') . '</option>
				<option value="supplierno">' . _('Supplier Number') . '</option>
				<option value="suppname">' . _('Supplier Name') . '</option>
				<option value="month">' . _('Month') . '</option>
				<option value="categoryid">' . _('Stock Category') . '</option>
				</select></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4"><div class="centre"><input type="submit" name="submit" value="' . _('Run Inquiry') . '" /></div></td>
		</tr>
		<tr>
			<td colspan="4"><div class="centre"><input type="submit" name="submitcsv" value="' . _('Export as csv file') . '" /></div></td>
		</tr>
	</table>
	<br/>
	</div>
   </form>';

} // End of function display()


include('includes/footer.inc');
?>
