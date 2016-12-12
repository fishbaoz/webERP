<?php

/* $Id: PDFLowGP.php 6944 2014-10-27 07:15:34Z daintree $*/

include('includes/session.inc');

if (!isset($_POST['FromCat'])  OR $_POST['FromCat']=='') {
	$Title=_('Low Gross Profit Sales');
}
$debug=0;
if (isset($_POST['PrintPDF'])) {

	include('includes/PDFStarter.php');
	$pdf->addInfo('Title', _('Low Gross Profit Sales'));
	$pdf->addInfo('Subject', _('Low Gross Profit Sales'));
	$FontSize=10;
	$PageNumber=1;
	$line_height=12;

	$Title = _('Low GP sales') . ' - ' . _('Problem Report');

	if (! Is_Date($_POST['FromDate']) OR ! Is_Date($_POST['ToDate'])){
		include('includes/header.inc');
		prnMsg(_('The dates entered must be in the format') . ' '  . $_SESSION['DefaultDateFormat'],'error');
		include('includes/footer.inc');
		exit;
	}

	  /*Now figure out the data to report for the category range under review */
	$SQL = "SELECT weberp_stockmaster.categoryid,
					weberp_stockmaster.stockid,
					weberp_stockmoves.transno,
					weberp_stockmoves.trandate,
					weberp_systypes.typename,
					weberp_stockmaster.materialcost + weberp_stockmaster.labourcost + weberp_stockmaster.overheadcost as unitcost,
					weberp_stockmoves.qty,
					weberp_stockmoves.debtorno,
					weberp_stockmoves.branchcode,
					weberp_stockmoves.price*(1-weberp_stockmoves.discountpercent) as sellingprice,
					(weberp_stockmoves.price*(1-weberp_stockmoves.discountpercent)) - (weberp_stockmaster.materialcost + weberp_stockmaster.labourcost + weberp_stockmaster.overheadcost) AS gp,
					weberp_debtorsmaster.name
				FROM weberp_stockmaster INNER JOIN weberp_stockmoves
					ON weberp_stockmaster.stockid=weberp_stockmoves.stockid
				INNER JOIN weberp_systypes
					ON weberp_stockmoves.type=weberp_systypes.typeid
				INNER JOIN weberp_debtorsmaster
					ON weberp_stockmoves.debtorno=weberp_debtorsmaster.debtorno
				WHERE weberp_stockmoves.trandate >= '" . FormatDateForSQL($_POST['FromDate']) . "'
				AND weberp_stockmoves.trandate <= '" . FormatDateForSQL($_POST['ToDate']) . "'
				AND ((weberp_stockmoves.price*(1-weberp_stockmoves.discountpercent)) - (weberp_stockmaster.materialcost + weberp_stockmaster.labourcost + weberp_stockmaster.overheadcost))/(weberp_stockmoves.price*(1-weberp_stockmoves.discountpercent)) <=" . $_POST['GPMin']/100 . "
				ORDER BY weberp_stockmaster.stockid";

	$LowGPSalesResult = DB_query($SQL,'','',false,false);

	if (DB_error_no() !=0) {

	  include('includes/header.inc');
		prnMsg(_('The low GP items could not be retrieved by the SQL because') . ' - ' . DB_error_msg(),'error');
		echo '<br /><a href="' .$RootPath .'/index.php">' . _('Back to the menu') . '</a>';
		if ($debug==1){
		  echo '<br />' . $SQL;
		}
		include('includes/footer.inc');
		exit;
	}

	if (DB_num_rows($LowGPSalesResult) == 0) {

		include('includes/header.inc');
		prnMsg(_('No low GP items retrieved'), 'warn');
		echo '<br /><a href="'  . $RootPath . '/index.php">' . _('Back to the menu') . '</a>';
		if ($debug==1){
		  echo '<br />' .  $SQL;
		}
		include('includes/footer.inc');
		exit;
	}

	include ('includes/PDFLowGPPageHeader.inc');
	$Tot_Val=0;
	$Category = '';
	$CatTot_Val=0;
	while ($LowGPItems = DB_fetch_array($LowGPSalesResult,$db)){

		$YPos -=$line_height;
		$FontSize=8;

		$LeftOvers = $pdf->addTextWrap($Left_Margin+2,$YPos,30,$FontSize,$LowGPItems['typename']);
		$LeftOvers = $pdf->addTextWrap(100,$YPos,30,$FontSize,$LowGPItems['transno']);
		$LeftOvers = $pdf->addTextWrap(130,$YPos,50,$FontSize,$LowGPItems['stockid']);
		$LeftOvers = $pdf->addTextWrap(220,$YPos,50,$FontSize,$LowGPItems['name']);
		$DisplayUnitCost = locale_number_format($LowGPItems['unitcost'],$_SESSION['CompanyRecord']['decimalplaces']);
		$DisplaySellingPrice = locale_number_format($LowGPItems['sellingprice'],$_SESSION['CompanyRecord']['decimalplaces']);
		$DisplayGP = locale_number_format($LowGPItems['gp'],$_SESSION['CompanyRecord']['decimalplaces']);
		$DisplayGPPercent = locale_number_format(($LowGPItems['gp']*100)/$LowGPItems['sellingprice'],1);

		$LeftOvers = $pdf->addTextWrap(330,$YPos,60,$FontSize,$DisplaySellingPrice,'right');
		$LeftOvers = $pdf->addTextWrap(380,$YPos,62,$FontSize,$DisplayUnitCost, 'right');
		$LeftOvers = $pdf->addTextWrap(440,$YPos,60,$FontSize,$DisplayGP, 'right');
		$LeftOvers = $pdf->addTextWrap(500,$YPos,60,$FontSize,$DisplayGPPercent . '%', 'right');

		if ($YPos < $Bottom_Margin + $line_height){
			include('includes/PDFLowGPPageHeader.inc');
		}

	} /*end low GP items while loop */

	$FontSize =10;

	$YPos -= (2*$line_height);
	$pdf->OutputD($_SESSION['DatabaseName'] . '_LowGPSales_' . date('Y-m-d') . '.pdf');
	$pdf->__destruct();

} else { /*The option to print PDF was not hit */

	include('includes/header.inc');

	echo '<p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/transactions.png" title="' . $Title . '" alt="" />' . ' '
		. _('Low Gross Profit Report') . '</p>';

	if (!isset($_POST['FromDate']) OR !isset($_POST['ToDate'])) {

	/*if $FromDate is not set then show a form to allow input */
		$_POST['FromDate']=Date($_SESSION['DefaultDateFormat']);
		$_POST['ToDate']=Date($_SESSION['DefaultDateFormat']);
		$_POST['GPMin']=0;
		echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '" method="post">';
        echo '<div>';
        echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';
		echo '<table class="selection">';
		echo '<tr>
				<td>' . _('Sales Made From') . ' (' . _('in the format') . ' ' . $_SESSION['DefaultDateFormat'] . '):</td>
				<td><input type="text" required="required" autofocus="autofocus" class="date" alt="' . $_SESSION['DefaultDateFormat'] . '" name="FromDate" size="10" maxlength="10" value="' . $_POST['FromDate'] . '" /></td>
			</tr>
			<tr>
				<td>' . _('Sales Made To') . ' (' . _('in the format') . ' ' . $_SESSION['DefaultDateFormat'] . '):</td>
				<td><input type="text" required="required" class="date" alt="' . $_SESSION['DefaultDateFormat'] . '" name="ToDate" size="10" maxlength="10" value="' . $_POST['ToDate'] . '" /></td>
			</tr>
			<tr>
				<td>' . _('Show sales with GP % below') . ':</td>
				<td><input type="text" class="integer" name="GPMin" maxlength="3" size="3" value="' . $_POST['GPMin'] . '" /></td>
			</tr>
			</table>
			<br />
			<div class="centre">
				<input type="submit" name="PrintPDF" value="' . _('Print PDF') . '" />
			</div>
			</div>
        </form>';
	}
	include('includes/footer.inc');

} /*end of else not PrintPDF */

?>