<?php

/* $Id: PDFDeliveryDifferences.php 6943 2014-10-27 07:06:42Z daintree $*/

include ('includes/session.inc');
include('includes/SQL_CommonFunctions.inc');

$InputError=0;

if (isset($_POST['FromDate']) AND !Is_Date($_POST['FromDate'])){
	$msg = _('The date from must be specified in the format') . ' ' . $_SESSION['DefaultDateFormat'];
	$InputError=1;
}
if (isset($_POST['ToDate']) AND !Is_Date($_POST['ToDate'])){
	$msg =  _('The date to must be specified in the format') . ' ' .  $_SESSION['DefaultDateFormat'];
	$InputError=1;
}

if (!isset($_POST['FromDate']) OR !isset($_POST['ToDate']) OR $InputError==1){

	 $Title = _('Delivery Differences Report');
	 include ('includes/header.inc');

	echo '<div class="centre"><p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/transactions.png" title="' . $Title . '" alt="" />' . ' '
		. _('Delivery Differences Report') . '</p></div>';

	echo '<form method="post" action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '">';
    echo '<div>';
	echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';
	echo '<table class="selection">
			<tr>
			<td>' . _('Enter the date from which variances between orders and deliveries are to be listed') . ':</td>
			<td><input type="text" required="required" autofocus="autofocus" class="date" alt="' . $_SESSION['DefaultDateFormat']. '" name="FromDate" maxlength="10" size="10" value="' . Date($_SESSION['DefaultDateFormat'], Mktime(0,0,0,Date('m')-1,0,Date('y'))) . '" /></td>
			</tr>';
	echo '<tr>
			<td>' . _('Enter the date to which variances between orders and deliveries are to be listed') . ':</td>
			<td><input type="text" required="required" class="date" alt="' . $_SESSION['DefaultDateFormat']. '"  name="ToDate" maxlength="10" size="10" value="' . Date($_SESSION['DefaultDateFormat']) . '" /></td>
			</tr>';
	echo '<tr>
			<td>' . _('Inventory Category') . '</td>
			<td>';

	$sql = "SELECT categorydescription,
					categoryid
			FROM weberp_stockcategory
			WHERE stocktype<>'D'
			AND stocktype<>'L'";

	$result = DB_query($sql);


	 echo '<select name="CategoryID">
			<option selected="selected" value="All">' . _('Over All Categories') . '</option>';

	while ($myrow=DB_fetch_array($result)){
		echo '<option value="' . $myrow['categoryid'] . '">' . $myrow['categorydescription']  . '</option>';
	}

	 echo '</select></td>
		</tr>
		<tr>
			<td>' . _('Inventory Location') . ':</td>
			<td><select name="Location">
				<option selected="selected" value="All">' . _('All Locations')  . '</option>';

	$result= DB_query("SELECT weberp_locations.loccode, locationname FROM weberp_locations INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locations.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1");
	while ($myrow=DB_fetch_array($result)){
		echo '<option value="' . $myrow['loccode'] . '">' . $myrow['locationname']  . '</option>';
	}
	 echo '</select></td></tr>';

	 echo '<tr>
				<td>' . _('Email the report off') . ':</td>
				<td><select name="Email">
					<option selected="selected" value="No">' . _('No')  . '</option>
					<option value="Yes">' . _('Yes')  . '</option>
					</select></td>
			</tr>
			</table>
			<br />
			<div class="centre">
				<input type="submit" name="Go" value="' . _('Create PDF') . '" />
			</div>
			</div>
		</form>';

	 if ($InputError==1){
	 	prnMsg($msg,'error');
	 }
	 include('includes/footer.inc');
	 exit;
} else {
	include('includes/ConnectDB.inc');
}

if ($_POST['CategoryID']=='All' AND $_POST['Location']=='All'){
	$sql= "SELECT invoiceno,
			weberp_orderdeliverydifferenceslog.orderno,
			weberp_orderdeliverydifferenceslog.stockid,
			weberp_stockmaster.description,
			weberp_stockmaster.decimalplaces,
			quantitydiff,
			trandate,
			weberp_orderdeliverydifferenceslog.debtorno,
			weberp_orderdeliverydifferenceslog.branch
		FROM weberp_orderdeliverydifferenceslog INNER JOIN weberp_stockmaster
			ON weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid
		INNER JOIN weberp_salesorders ON weberp_orderdeliverydifferenceslog.orderno = weberp_salesorders.orderno
		INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_salesorders.fromstkloc AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
		INNER JOIN weberp_debtortrans ON weberp_orderdeliverydifferenceslog.invoiceno=weberp_debtortrans.transno
			AND weberp_debtortrans.type=10
			AND trandate >='" . FormatDateForSQL($_POST['FromDate']) . "'
			AND trandate <='" . FormatDateForSQL($_POST['ToDate']) . "'";

} elseif ($_POST['CategoryID']!='All' AND $_POST['Location']=='All') {
	$sql= "SELECT invoiceno,
			weberp_orderdeliverydifferenceslog.orderno,
			weberp_orderdeliverydifferenceslog.stockid,
			weberp_stockmaster.description,
			weberp_stockmaster.decimalplaces,
			quantitydiff,
			trandate,
			weberp_orderdeliverydifferenceslog.debtorno,
			weberp_orderdeliverydifferenceslog.branch
		FROM weberp_orderdeliverydifferenceslog INNER JOIN weberp_stockmaster
			ON weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid
			INNER JOIN weberp_salesorders ON weberp_orderdeliverydifferenceslog.orderno = weberp_salesorders.orderno
			INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_salesorders.fromstkloc AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
			INNER JOIN weberp_debtortrans ON weberp_orderdeliverydifferenceslog.invoiceno=weberp_debtortrans.transno
			AND weberp_debtortrans.type=10
			AND trandate >='" . FormatDateForSQL($_POST['FromDate']) . "'
			AND trandate <='" . FormatDateForSQL($_POST['ToDate']) . "'
			AND categoryid='" . $_POST['CategoryID'] ."'";

} elseif ($_POST['CategoryID']=='All' AND $_POST['Location']!='All') {
	$sql = "SELECT invoiceno,
			weberp_orderdeliverydifferenceslog.orderno,
			weberp_orderdeliverydifferenceslog.stockid,
			weberp_stockmaster.description,
			weberp_stockmaster.decimalplaces,
			quantitydiff,
			trandate,
			weberp_orderdeliverydifferenceslog.debtorno,
			weberp_orderdeliverydifferenceslog.branch
		FROM weberp_orderdeliverydifferenceslog INNER JOIN weberp_stockmaster
			ON weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid
			INNER JOIN weberp_debtortrans
				ON weberp_orderdeliverydifferenceslog.invoiceno=weberp_debtortrans.transno
				INNER JOIN weberp_salesorders
					ON weberp_orderdeliverydifferenceslog.orderno=weberp_salesorders.orderno
				INNER JOIN weberp_locationusers 
					ON weberp_locationusers.loccode=weberp_salesorders.fromstkloc AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
		WHERE weberp_debtortrans.type=10
		AND weberp_salesorders.fromstkloc='". $_POST['Location'] . "'
		AND trandate >='" . FormatDateForSQL($_POST['FromDate']) . "'
		AND trandate <='" . FormatDateForSQL($_POST['ToDate']) . "'";

} elseif ($_POST['CategoryID']!='All' AND $_POST['location']!='All'){

	$sql = "SELECT invoiceno,
			weberp_orderdeliverydifferenceslog.orderno,
			weberp_orderdeliverydifferenceslog.stockid,
			weberp_stockmaster.description,
			weberp_stockmaster.decimalplaces,
			quantitydiff,
			trandate,
			weberp_orderdeliverydifferenceslog.debtorno,
			weberp_orderdeliverydifferenceslog.branch
		FROM weberp_orderdeliverydifferenceslog INNER JOIN weberp_stockmaster
			ON weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid
			INNER JOIN weberp_debtortrans
				ON weberp_orderdeliverydifferenceslog.invoiceno=weberp_debtortrans.transno
				AND weberp_debtortrans.type=10
				INNER JOIN weberp_salesorders
					ON weberp_orderdeliverydifferenceslog.orderno = weberp_salesorders.orderno
				INNER JOIN weberp_locationusers 
					ON weberp_locationusers.loccode=weberp_salesorders.fromstkloc AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
		WHERE weberp_salesorders.fromstkloc='" . $_POST['Location'] . "'
		AND categoryid='" . $_POST['CategoryID'] . "'
		AND trandate >='" . FormatDateForSQL($_POST['FromDate']) . "'
		AND trandate <= '" . FormatDateForSQL($_POST['ToDate']) . "'";
}

if ($_SESSION['SalesmanLogin'] != '') {
	$sql .= " AND weberp_debtortrans.salesperson='" . $_SESSION['SalesmanLogin'] . "'";
}

$Result=DB_query($sql,'','',false,false); //dont error check - see below

if (DB_error_no()!=0){
	$Title = _('Delivery Differences Log Report Error');
	include('includes/header.inc');
	prnMsg( _('An error occurred getting the variances between deliveries and orders'),'error');
	if ($debug==1){
		prnMsg( _('The SQL used to get the variances between deliveries and orders that failed was') . '<br />' . $SQL,'error');
	}
	include ('includes/footer.inc');
	exit;
} elseif (DB_num_rows($Result) == 0){
	$Title = _('Delivery Differences Log Report Error');
  	include('includes/header.inc');
	prnMsg( _('There were no variances between deliveries and orders found in the database within the period from') . ' ' . $_POST['FromDate'] . ' ' . _('to') . ' ' . $_POST['ToDate'] . '. ' . _('Please try again selecting a different date range'), 'info');
	if ($debug==1) {
		prnMsg( _('The SQL that returned no rows was') . '<br />' . $sql,'error');
	}
	include('includes/footer.inc');
	exit;
}

include('includes/PDFStarter.php');

/*PDFStarter.php has all the variables for page size and width set up depending on the users default preferences for paper size */

$pdf->addInfo('Title',_('Variances Between Deliveries and Orders'));
$pdf->addInfo('Subject',_('Variances Between Deliveries and Orders from') . ' ' . $_POST['FromDate'] . ' ' . _('to') . ' ' . $_POST['ToDate']);
$line_height=12;
$PageNumber = 1;
$TotalDiffs = 0;

include ('includes/PDFDeliveryDifferencesPageHeader.inc');

while ($myrow=DB_fetch_array($Result)){

	  $LeftOvers = $pdf->addTextWrap($Left_Margin,$YPos,40,$FontSize,$myrow['invoiceno'], 'left');
	  $LeftOvers = $pdf->addTextWrap($Left_Margin+40,$YPos,40,$FontSize,$myrow['orderno'], 'left');
	  $LeftOvers = $pdf->addTextWrap($Left_Margin+80,$YPos,200,$FontSize,$myrow['stockid'] . ' - ' . $myrow['description'], 'left');

	  $LeftOvers = $pdf->addTextWrap($Left_Margin+280,$YPos,50,$FontSize,locale_number_format($myrow['quantitydiff'],$myrow['decimalplaces']), 'right');
	  $LeftOvers = $pdf->addTextWrap($Left_Margin+335,$YPos,50,$FontSize,$myrow['debtorno'], 'left');
	  $LeftOvers = $pdf->addTextWrap($Left_Margin+385,$YPos,50,$FontSize,$myrow['branch'], 'left');
	  $LeftOvers = $pdf->addTextWrap($Left_Margin+435,$YPos,50,$FontSize,ConvertSQLDate($myrow['trandate']), 'left');

	  $YPos -= ($line_height);
	  $TotalDiffs++;

	  if ($YPos - (2 *$line_height) < $Bottom_Margin){
		  /*Then set up a new page */
			  $PageNumber++;
		  include ('includes/PDFDeliveryDifferencesPageHeader.inc');
	  } /*end of new page header  */
} /* end of while there are delivery differences to print */


$YPos-=$line_height;
$LeftOvers = $pdf->addTextWrap($Left_Margin,$YPos,200,$FontSize,_('Total number of differences') . ' ' . locale_number_format($TotalDiffs), 'left');

if ($_POST['CategoryID']=='All' AND $_POST['Location']=='All'){
	$sql = "SELECT COUNT(weberp_salesorderdetails.orderno)
			FROM weberp_salesorderdetails INNER JOIN weberp_debtortrans
				ON weberp_salesorderdetails.orderno=weberp_debtortrans.order_ INNER JOIN weberp_salesorders 
				ON weberp_salesorderdetails.orderno = weberp_salesorders.orderno INNER JOIN weberp_locationusers 
				ON weberp_locationusers.loccode=weberp_salesorders.fromstkloc AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
			WHERE weberp_debtortrans.trandate>='" . FormatDateForSQL($_POST['FromDate']) . "'
			AND weberp_debtortrans.trandate <='" . FormatDateForSQL($_POST['ToDate']) . "'";

} elseif ($_POST['CategoryID']!='All' AND $_POST['Location']=='All') {
	$sql = "SELECT COUNT(weberp_salesorderdetails.orderno)
		FROM weberp_salesorderdetails INNER JOIN weberp_debtortrans
			ON weberp_salesorderdetails.orderno=weberp_debtortrans.order_ INNER JOIN weberp_stockmaster
			ON weberp_salesorderdetails.stkcode=weberp_stockmaster.stockid INNER JOIN weberp_salesorders 
			ON weberp_salesorderdetails.orderno = weberp_salesorders.orderno INNER JOIN weberp_locationusers 
			ON weberp_locationusers.loccode=weberp_salesorders.fromstkloc AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
		WHERE weberp_debtortrans.trandate>='" . FormatDateForSQL($_POST['FromDate']) . "'
		AND weberp_debtortrans.trandate <='" . FormatDateForSQL($_POST['ToDate']) . "'
		AND weberp_stockmaster.categoryid='" . $_POST['CategoryID'] . "'";

} elseif ($_POST['CategoryID']=='All' AND $_POST['Location']!='All'){

	$sql = "SELECT COUNT(weberp_salesorderdetails.orderno)
		FROM weberp_salesorderdetails INNER JOIN weberp_debtortrans
			ON weberp_salesorderdetails.orderno=weberp_debtortrans.order_ INNER JOIN weberp_salesorders
			ON weberp_salesorderdetails.orderno = weberp_salesorders.orderno INNER JOIN weberp_locationusers 
			ON weberp_locationusers.loccode=weberp_salesorders.fromstkloc AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
		WHERE weberp_debtortrans.trandate>='". FormatDateForSQL($_POST['FromDate']) . "'
		AND weberp_debtortrans.trandate <='" . FormatDateForSQL($_POST['ToDate']) . "'
		AND weberp_salesorders.fromstkloc='" . $_POST['Location'] . "'";

} elseif ($_POST['CategoryID'] !='All' AND $_POST['Location'] !='All'){

	$sql = "SELECT COUNT(weberp_salesorderdetails.orderno)
		FROM weberp_salesorderdetails INNER JOIN weberp_debtortrans ON weberp_salesorderdetails.orderno=weberp_debtortrans.order_
			INNER JOIN weberp_salesorders ON weberp_salesorderdetails.orderno = weberp_salesorders.orderno
			INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_salesorders.fromstkloc AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
			INNER JOIN weberp_stockmaster ON weberp_salesorderdetails.stkcode = weberp_stockmaster.stockid
		WHERE weberp_salesorders.fromstkloc ='" . $_POST['Location'] . "'
		AND categoryid='" . $_POST['CategoryID'] . "'
		AND trandate >='" . FormatDateForSQL($_POST['FromDate']) . "'
		AND trandate <= '" . FormatDateForSQL($_POST['ToDate']) . "'";

}

if ($_SESSION['SalesmanLogin'] != '') {
	$sql .= " AND weberp_debtortrans.salesperson='" . $_SESSION['SalesmanLogin'] . "'";
}

$ErrMsg = _('Could not retrieve the count of sales order lines in the period under review');
$result = DB_query($sql,$ErrMsg);


$myrow=DB_fetch_row($result);
$YPos-=$line_height;
$LeftOvers = $pdf->addTextWrap($Left_Margin,$YPos,200,$FontSize,_('Total number of order lines') . ' ' . locale_number_format($myrow[0]), 'left');

$YPos-=$line_height;
$LeftOvers = $pdf->addTextWrap($Left_Margin,$YPos,200,$FontSize,_('DIFOT') . ' ' . locale_number_format((1-($TotalDiffs/$myrow[0])) * 100,2) . '%', 'left');

$ReportFileName = $_SESSION['DatabaseName'] . '_DeliveryDifferences_' . date('Y-m-d').'.pdf';
$pdf->OutputD($ReportFileName);

if ($_POST['Email']=='Yes'){
	if (file_exists($_SESSION['reports_dir'] . '/'.$ReportFileName)){
		unlink($_SESSION['reports_dir'] . '/'.$ReportFileName);
	}
	$pdf->Output($_SESSION['reports_dir'].'/'.$ReportFileName,'F');	

	include('includes/htmlMimeMail.php');

	$mail = new htmlMimeMail();
	$attachment = $mail->getFile($_SESSION['reports_dir'] . '/'.$ReportFileName);
	$mail->setText(_('Please find herewith delivery differences report from') . ' ' . $_POST['FromDate'] .  ' '. _('to') . ' ' . $_POST['ToDate']);
	$mail->addAttachment($attachment, $ReportFileName, 'application/pdf');
	if($_SESSION['SmtpSetting'] == 0){
		$mail->setFrom($_SESSION['CompanyRecord']['coyname'] . ' <' . $_SESSION['CompanyRecord']['email'] . '>');
		$result = $mail->send(array($_SESSION['FactoryManagerEmail']));
	}else{
		$result = SendmailBySmtp($mail,array($_SESSION['FactoryManagerEmail']));
	}


}
$pdf->__destruct();

?>
