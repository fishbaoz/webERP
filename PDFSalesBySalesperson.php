<?php

/* $Id: PDFSalesBySalesperson.php 1 2014-11-11 03:26:23Z agaluski $*/
$DatabaseName='weberp';
$AllowAnyone = true;

include ('includes/session.inc');
include('includes/SQL_CommonFunctions.inc');
include ('includes/class.pdf.php');
$_POST['FromDate']=date('Y-m-01');
$_POST['ToDate']= FormatDateForSQL(Date($_SESSION['DefaultDateFormat']));
$WeekStartDate = Date(($_SESSION['DefaultDateFormat']), strtotime($WeekStartDate . ' - 7 days'));
$Recipients = GetMailList('salesbysalesperson');
if (sizeOf($Recipients) == 0) {
	$Title = _('Weekly Orders') . ' - ' . _('Problem Report');
      	include('includes/header.inc');
	prnMsg( _('There are no members of the Weekly Orders Recipients email group'), 'warn');
	include('includes/footer.inc');
	exit;
}

$sql= "SELECT weberp_salesorders.orderno,
			  weberp_salesorders.orddate,
			  weberp_salesorderdetails.stkcode,
			  weberp_salesorderdetails.unitprice,
			  weberp_stockmaster.description,
			  weberp_stockmaster.units,
			  weberp_stockmaster.decimalplaces,
			  weberp_salesorderdetails.quantity,
			  weberp_salesorderdetails.qtyinvoiced,
			  weberp_salesorderdetails.completed,
			  weberp_salesorderdetails.discountpercent,
			  weberp_stockmaster.materialcost+weberp_stockmaster.labourcost+weberp_stockmaster.overheadcost AS standardcost,
			  weberp_debtorsmaster.name,
			  weberp_salesman.salesmanname
		 FROM weberp_salesorders
			 INNER JOIN weberp_salesorderdetails
			 ON weberp_salesorders.orderno = weberp_salesorderdetails.orderno
			 INNER JOIN weberp_stockmaster
			 ON weberp_salesorderdetails.stkcode = weberp_stockmaster.stockid
			 INNER JOIN weberp_debtorsmaster
			 ON weberp_salesorders.debtorno=weberp_debtorsmaster.debtorno
			 INNER JOIN weberp_custbranch ON weberp_custbranch.debtorno=weberp_salesorders.debtorno 
			 AND weberp_custbranch.branchcode=weberp_salesorders.branchcode
			 INNER JOIN weberp_salesman ON weberp_salesman.salesmancode=weberp_custbranch.salesman
		 WHERE weberp_salesorders.orddate >='" . FormatDateForSQL($WeekStartDate) . "'
			  AND weberp_salesorders.orddate <='" . $_POST['ToDate'] . "'
		 AND weberp_salesorders.quotation=0
		 ORDER BY weberp_custbranch.salesman, weberp_salesorders.orderno";

$Result=DB_query($sql,$db,'','',false,false); //dont trap errors here

if (DB_error_no($db)!=0){
	include('includes/header.inc');
	echo '<br />' . _('An error occurred getting the orders details');
	if ($debug==1){
		echo '<br />' . _('The SQL used to get the orders that failed was') . '<br />' . $sql;
	}
	include ('includes/footer.inc');
	exit;
}
$PaperSize="Letter_Landscape";
include('includes/PDFStarter.php');
$pdf->addInfo('Title',_('Weekly Orders Report'));
$pdf->addInfo('Subject',_('Orders from') . ' ' . $_POST['FromDate'] . ' ' . _('to') . ' ' . $_POST['ToDate']);
$line_height=12;
$PageNumber = 1;
$TotalDiffs = 0;
include ('includes/PDFWeeklyOrdersPageHeader.inc');
$Col1=2;
$Col2=40;
$Col3=160;
$Col4=210;
$Col5=260;
$Col6=390;
$Col7=450;
$Col8=510;
$Col9=570;
$Col10=650;
$Col11=660;

$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col1,$YPos,$Col2-$Col1-5,$FontSize,_('Order'), 'left');
$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col2,$YPos,$Col3-$Col2-5,$FontSize,_('Customer'), 'left');
$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col3,$YPos,$Col4-$Col3-5,$FontSize,_('Order Date'), 'left');
$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col4,$YPos,$Col5-$Col4-5,$FontSize,_('Item'), 'left');
$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col5,$YPos,$Col6-$Col5-5,$FontSize,_('Description'), 'left');
$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col6,$YPos,$Col7-$Col6-5,$FontSize,_('Quantity'), 'right');
$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col7,$YPos,$Col8-$Col7-5,$FontSize,_('Sales'), 'right');
$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col8,$YPos,$Col9-$Col8-5,$FontSize,_('Status'), 'Left');
$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col9,$YPos,$Col10-$Col9-5,$FontSize,_('Salesperson'), 'Left');

$YPos-=$line_height;
$pdf->line($XPos, $YPos,$Page_Width-$Right_Margin, $YPos);
$YPos-=$line_height;
$Salesman='';
while ($myrow=DB_fetch_array($Result)){

	if ($myrow['completed']==1) {
		$Status="Closed";
		$Qty=$myrow['qtyinvoiced'];
	} else {
		$Qty=$myrow['quantity'];
		if ($myrow['qtyinvoiced']==0) {
			$Status= _('Ordered');
		} else {
			$Status= _('Partial');
		}
	}
	$SalesValue=$Qty*$myrow['unitprice']*(1-$myrow['discountpercent']);
	$SalesCost=$Qty*$myrow['standardcost'];
	if ($SalesValue <> 0) {
		$GP=($SalesValue-$SalesCost)/$SalesValue *100;
	} else {
		$GP=0;
	}

	if ($Salesman > '' and $Salesman <> $myrow['salesmanname']){
		$PageNumber++;
		include ('includes/PDFWeeklyOrdersPageHeader.inc');
	} /*end of new page header  */
	$Salesman = $myrow['salesmanname'];
	
	$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col1,$YPos,$Col2-$Col1-5,$FontSize,$myrow['orderno'], 'left');
	$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col2,$YPos,$Col3-$Col2-5,$FontSize,html_entity_decode($myrow['name'],ENT_QUOTES,'UTF-8'), 'left');
	$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col3,$YPos,$Col4-$Col3-5,$FontSize,ConvertSQLDate($myrow['orddate']), 'left');
	$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col4,$YPos,$Col5-$Col4-5,$FontSize,$myrow['stkcode'], 'left');
	$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col5,$YPos,$Col6-$Col5-5,$FontSize,$myrow['description'], 'left');
	$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col6,$YPos,$Col7-$Col6-5,$FontSize,locale_number_format($myrow['quantity'],$_SESSION['CompanyRecord']['decimalplaces']), 'right');
	$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col7,$YPos,$Col8-$Col7-5,$FontSize,locale_number_format($SalesValue,$_SESSION['CompanyRecord']['decimalplaces']), 'right');
	$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col8,$YPos,$Col9-$Col8-5,$FontSize,$Status, 'left');
	$LeftOvers = $pdf->addTextWrap($Left_Margin+$Col9,$YPos,$Col10-$Col9-5,$FontSize,$myrow['salesmanname'], 'left');
	if ($YPos - (2 *$line_height) < $Bottom_Margin){
		$PageNumber++;
		include ('includes/PDFWeeklyOrdersPageHeader.inc');
	} /*end of new page header  */
	$YPos -= $line_height;

} //while

include('includes/htmlMimeMail.php');
$filename=$_SESSION['reports_dir'] .  '/SalesBySalesperson.pdf';
$pdf->Output($filename, 'F');
$pdf->__destruct();
$mail = new htmlMimeMail();
$attachment = $mail->getFile($filename);
$mail->setText(_('Please find the Sales By Salesperson report'));
$mail->setSubject(_('Sales By Salesperson Report'));
$mail->addAttachment($attachment, $filename, 'application/pdf');
//echo '<br /><div class="centre"><a href="' . $RootPath . '/' . $filename . '">' . _('click here') . '</a> ' . _('to view the file') . '</div>';
if($_SESSION['SmtpSetting']==0){
	$mail->setFrom($_SESSION['CompanyRecord']['coyname'] . '<' . $_SESSION['CompanyRecord']['email'] . '>');
	$result = $mail->send($Recipients);
}else{
	$result = SendmailBySmtp($mail,$Recipients);
}
if($result){
		$Title = _('Print Weekly Orders');
		include('includes/header.inc');
		prnMsg(_('The Weekly Orders report has been mailed'),'success');
		echo '<br /><a href="' . $RootPath . '/index.php">' . _('Back to the menu') . '</a>';
		include('includes/footer.inc');
		exit;

}else{
		$Title = _('Print Weekly Orders Error');
		include('includes/header.inc');
		prnMsg(_('There are errors lead to mails not sent'),'error');
		echo '<br /><a href="' . $RootPath . '/index.php">' . _('Back to the menu') . '</a>';
		include('includes/footer.inc');
		exit;

}
?>