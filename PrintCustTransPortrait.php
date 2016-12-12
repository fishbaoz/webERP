<?php
/* $Id: PrintCustTransPortrait.php 7549 2016-06-05 18:19:51Z rchacon $ */
/*  Print Invoices or Credit Notes (Portrait Mode) */

include('includes/session.inc');

$ViewTopic = 'ARReports';
$BookMark = 'PrintInvoicesCredits';


if(isset($_GET['FromTransNo'])) {
	$FromTransNo = filter_number_format($_GET['FromTransNo']);
} elseif(isset($_POST['FromTransNo'])) {
	$FromTransNo = filter_number_format($_POST['FromTransNo']);
} else {
	$FromTransNo = '';
}

if(isset($_GET['InvOrCredit'])) {
	$InvOrCredit = $_GET['InvOrCredit'];
} elseif(isset($_POST['InvOrCredit'])) {
	$InvOrCredit = $_POST['InvOrCredit'];
}

if(isset($_GET['PrintPDF'])) {
	$PrintPDF = $_GET['PrintPDF'];
} elseif(isset($_POST['PrintPDF'])) {
	$PrintPDF = $_POST['PrintPDF'];
}

if(!isset($_POST['ToTransNo'])
	OR trim($_POST['ToTransNo'])==''
	OR filter_number_format($_POST['ToTransNo']) < $FromTransNo) {

	$_POST['ToTransNo'] = $FromTransNo;
}

$FirstTrans = $FromTransNo; /* Need to start a new page only on subsequent transactions */

if(isset($PrintPDF)
	and $PrintPDF!=''
	and isset($FromTransNo)
	and isset($InvOrCredit)
	and $FromTransNo!='') {

	include ('includes/class.pdf.php');


	$Page_Width=595;
	$Page_Height=842;
	$Top_Margin=30;
	$Bottom_Margin=30;
	$Left_Margin=40;
	$Right_Margin=30;

	$pdf = new Cpdf('P', 'pt', 'A4');
	$pdf->addInfo('Author','webERP ' . $Version);
	$pdf->addInfo('Creator','webERP http://www.weberp.org');

	if($InvOrCredit=='Invoice') {
		$pdf->addInfo('Title',_('Sales Invoice') . ' ' . $FromTransNo . ' to ' . $_POST['ToTransNo']);
		$pdf->addInfo('Subject',_('Invoices from') . ' ' . $FromTransNo . ' ' . _('to') . ' ' . $_POST['ToTransNo']);
	} else {
		$pdf->addInfo('Title',_('Sales Credit Note') );
		$pdf->addInfo('Subject',_('Credit Notes from') . ' ' . $FromTransNo . ' ' . _('to') . ' ' . $_POST['ToTransNo']);
	}

	$pdf->setAutoPageBreak(0);
	$pdf->setPrintHeader(false);
	$pdf->setPrintFooter(false);
	$pdf->AddPage();
	$pdf->cMargin = 0;

	$FirstPage = true;
	$line_height=16;

	//Keep a record of the user's language
	$UserLanguage = $_SESSION['Language'];

	while($FromTransNo <= filter_number_format($_POST['ToTransNo'])) {

	/*retrieve the invoice details from the database to print
	notice that salesorder record must be present to print the invoice purging of sales orders will
	nobble the invoice reprints */

	// check if the user has set a default bank account for invoices, if not leave it blank
		$sql = "SELECT weberp_bankaccounts.invoice,
					weberp_bankaccounts.bankaccountnumber,
					weberp_bankaccounts.bankaccountcode
				FROM weberp_bankaccounts
				WHERE weberp_bankaccounts.invoice = '1'";
		$result=DB_query($sql,'','',false,false);
		if(DB_error_no()!=1) {
			if(DB_num_rows($result)==1) {
				$myrow = DB_fetch_array($result);
				$DefaultBankAccountNumber = _('Account') .': ' .$myrow['bankaccountnumber'];
				$DefaultBankAccountCode = _('Bank Code:') .' ' .$myrow['bankaccountcode'];
			} else {
				$DefaultBankAccountNumber = '';
				$DefaultBankAccountCode = '';
			}
		} else {
			$DefaultBankAccountNumber = '';
			$DefaultBankAccountCode = '';
		}
// gather the invoice data

		if($InvOrCredit=='Invoice') {
			$sql = "SELECT weberp_debtortrans.trandate,
							weberp_debtortrans.ovamount,
							weberp_debtortrans.ovdiscount,
							weberp_debtortrans.ovfreight,
							weberp_debtortrans.ovgst,
							weberp_debtortrans.rate,
							weberp_debtortrans.invtext,
							weberp_debtortrans.consignment,
							weberp_debtortrans.packages,
							weberp_debtorsmaster.name,
							weberp_debtorsmaster.address1,
							weberp_debtorsmaster.address2,
							weberp_debtorsmaster.address3,
							weberp_debtorsmaster.address4,
							weberp_debtorsmaster.address5,
							weberp_debtorsmaster.address6,
							weberp_debtorsmaster.currcode,
							weberp_debtorsmaster.invaddrbranch,
							weberp_debtorsmaster.taxref,
							weberp_debtorsmaster.language_id,
							weberp_paymentterms.terms,
							weberp_salesorders.deliverto,
							weberp_salesorders.deladd1,
							weberp_salesorders.deladd2,
							weberp_salesorders.deladd3,
							weberp_salesorders.deladd4,
							weberp_salesorders.deladd5,
							weberp_salesorders.deladd6,
							weberp_salesorders.customerref,
							weberp_salesorders.orderno,
							weberp_salesorders.orddate,
							weberp_locations.locationname,
							weberp_shippers.shippername,
							weberp_custbranch.brname,
							weberp_custbranch.braddress1,
							weberp_custbranch.braddress2,
							weberp_custbranch.braddress3,
							weberp_custbranch.braddress4,
							weberp_custbranch.braddress5,
							weberp_custbranch.braddress6,
							weberp_custbranch.brpostaddr1,
							weberp_custbranch.brpostaddr2,
							weberp_custbranch.brpostaddr3,
							weberp_custbranch.brpostaddr4,
							weberp_custbranch.brpostaddr5,
							weberp_custbranch.brpostaddr6,
							weberp_salesman.salesmanname,
							weberp_debtortrans.debtorno,
							weberp_debtortrans.branchcode,
							weberp_currencies.decimalplaces
						FROM weberp_debtortrans INNER JOIN weberp_debtorsmaster
						ON weberp_debtortrans.debtorno=weberp_debtorsmaster.debtorno
						INNER JOIN weberp_custbranch
						ON weberp_debtortrans.debtorno=weberp_custbranch.debtorno
						AND weberp_debtortrans.branchcode=weberp_custbranch.branchcode
						INNER JOIN weberp_salesorders
						ON weberp_debtortrans.order_ = weberp_salesorders.orderno
						INNER JOIN weberp_shippers
						ON weberp_debtortrans.shipvia=weberp_shippers.shipper_id
						INNER JOIN weberp_salesman
						ON weberp_custbranch.salesman=weberp_salesman.salesmancode
						INNER JOIN weberp_locations
						ON weberp_salesorders.fromstkloc=weberp_locations.loccode
						INNER JOIN weberp_locationusers
						ON weberp_locationusers.loccode=weberp_locations.loccode AND weberp_locationusers.userid='" . $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
						INNER JOIN weberp_paymentterms
						ON weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator
						INNER JOIN weberp_currencies
						ON weberp_debtorsmaster.currcode=weberp_currencies.currabrev
						WHERE weberp_debtortrans.type=10
						AND weberp_debtortrans.transno='" . $FromTransNo . "'";

			if(isset($_POST['PrintEDI']) and $_POST['PrintEDI']=='No') {
				$sql = $sql . " AND weberp_debtorsmaster.ediinvoices=0";
			}
		} else {
			$sql = "SELECT weberp_debtortrans.trandate,
							weberp_debtortrans.ovamount,
							weberp_debtortrans.ovdiscount,
							weberp_debtortrans.ovfreight,
							weberp_debtortrans.ovgst,
							weberp_debtortrans.rate,
							weberp_debtortrans.invtext,
							weberp_debtorsmaster.invaddrbranch,
							weberp_debtorsmaster.name,
							weberp_debtorsmaster.address1,
							weberp_debtorsmaster.address2,
							weberp_debtorsmaster.address3,
							weberp_debtorsmaster.address4,
							weberp_debtorsmaster.address5,
							weberp_debtorsmaster.address6,
							weberp_debtorsmaster.currcode,
							weberp_debtorsmaster.taxref,
							weberp_debtorsmaster.language_id,
							weberp_custbranch.brname,
							weberp_custbranch.braddress1,
							weberp_custbranch.braddress2,
							weberp_custbranch.braddress3,
							weberp_custbranch.braddress4,
							weberp_custbranch.braddress5,
							weberp_custbranch.braddress6,
							weberp_custbranch.brpostaddr1,
							weberp_custbranch.brpostaddr2,
							weberp_custbranch.brpostaddr3,
							weberp_custbranch.brpostaddr4,
							weberp_custbranch.brpostaddr5,
							weberp_custbranch.brpostaddr6,
							weberp_salesman.salesmanname,
							weberp_debtortrans.debtorno,
							weberp_debtortrans.branchcode,
							weberp_paymentterms.terms,
							weberp_currencies.decimalplaces
						FROM weberp_debtortrans INNER JOIN weberp_debtorsmaster
						ON weberp_debtortrans.debtorno=weberp_debtorsmaster.debtorno
						INNER JOIN weberp_custbranch
						ON weberp_debtortrans.debtorno=weberp_custbranch.debtorno
						AND weberp_debtortrans.branchcode=weberp_custbranch.branchcode
						INNER JOIN weberp_salesman
						ON weberp_custbranch.salesman=weberp_salesman.salesmancode
						INNER JOIN weberp_paymentterms
						ON weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator
						INNER JOIN weberp_currencies
						ON weberp_debtorsmaster.currcode=weberp_currencies.currabrev
						WHERE weberp_debtortrans.type=11
						AND weberp_debtortrans.transno='" . $FromTransNo . "'";


			if(isset($_POST['PrintEDI']) and $_POST['PrintEDI']=='No') {
				$sql = $sql . ' AND weberp_debtorsmaster.ediinvoices=0';
			}
		}

		$result=DB_query($sql,'','',false,false);

		if(DB_error_no()!=0) {

			$Title = _('Transaction Print Error Report');
			include ('includes/header.inc');

			prnMsg( _('There was a problem retrieving the invoice or credit note details for note number') . ' ' . $InvoiceToPrint . ' ' . _('from the database') . '. ' . _('To print an invoice, the sales order record, the customer transaction record and the branch record for the customer must not have been purged') . '. ' . _('To print a credit note only requires the customer, transaction, salesman and branch records be available'),'error');
			if($debug==1) {
				prnMsg (_('The SQL used to get this information that failed was') . '<br />' . $sql,'error');
			}
			include ('includes/footer.inc');
			exit;
		}
		if(DB_num_rows($result)==1) {
			$myrow = DB_fetch_array($result);
			$ExchRate = $myrow['rate'];
			//Change the language to the customer's language
			$_SESSION['Language'] = $myrow['language_id'];
			include('includes/LanguageSetup.php');

			if($InvOrCredit == 'Invoice') {
				$sql = "SELECT weberp_stockmoves.stockid,
						weberp_stockmaster.description,
						-weberp_stockmoves.qty as quantity,
						weberp_stockmoves.discountpercent,
						((1 - weberp_stockmoves.discountpercent) * weberp_stockmoves.price * " . $ExchRate . "* -weberp_stockmoves.qty) AS fxnet,
						(weberp_stockmoves.price * " . $ExchRate . ") AS fxprice,
						weberp_stockmoves.narrative,
						weberp_stockmaster.controlled,
						weberp_stockmaster.serialised,
						weberp_stockmaster.units,
						weberp_stockmoves.stkmoveno,
						weberp_stockmaster.decimalplaces
					FROM weberp_stockmoves INNER JOIN weberp_stockmaster
					ON weberp_stockmoves.stockid = weberp_stockmaster.stockid
					WHERE weberp_stockmoves.type=10
					AND weberp_stockmoves.transno='" . $FromTransNo . "'
					AND weberp_stockmoves.show_on_inv_crds=1";
			} else {
				/* only credit notes to be retrieved */
				$sql = "SELECT weberp_stockmoves.stockid,
						weberp_stockmaster.description,
						weberp_stockmoves.qty as quantity,
						weberp_stockmoves.discountpercent,
						((1 - weberp_stockmoves.discountpercent) * weberp_stockmoves.price * " . $ExchRate . " * weberp_stockmoves.qty) AS fxnet,
						(weberp_stockmoves.price * " . $ExchRate . ") AS fxprice,
						weberp_stockmoves.narrative,
						weberp_stockmaster.controlled,
						weberp_stockmaster.serialised,
						weberp_stockmaster.units,
						weberp_stockmoves.stkmoveno,
						weberp_stockmaster.decimalplaces
					FROM weberp_stockmoves INNER JOIN weberp_stockmaster
					ON weberp_stockmoves.stockid = weberp_stockmaster.stockid
					WHERE weberp_stockmoves.type=11
					AND weberp_stockmoves.transno='" . $FromTransNo . "'
					AND weberp_stockmoves.show_on_inv_crds=1";
			} // end else

		$result=DB_query($sql);
		if(DB_error_no()!=0) {
			$Title = _('Transaction Print Error Report');
			include ('includes/header.inc');
			echo '<br />' . _('There was a problem retrieving the invoice or credit note stock movement details for invoice number') . ' ' . $FromTransNo . ' ' . _('from the database');
			if($debug==1) {
				echo '<br />' . _('The SQL used to get this information that failed was') . '<br />' . $sql;
			}
			include('includes/footer.inc');
			exit;
		}

		if(DB_num_rows($result)>0) {

			$FontSize = 10;
			$PageNumber = 1;

			include('includes/PDFTransPageHeaderPortrait.inc');
			$FirstPage = False;

			while($myrow2=DB_fetch_array($result)) {
				if($myrow2['discountpercent'] == 0) {
					$DisplayDiscount = '';
				} else {
					$DisplayDiscount = locale_number_format($myrow2['discountpercent'] * 100, 2) . '%';
					$DiscountPrice = $myrow2['fxprice'] * (1 - $myrow2['discountpercent']);
				}
				$DisplayNet = locale_number_format($myrow2['fxnet'],$myrow['decimalplaces']);
				$DisplayPrice = locale_number_format($myrow2['fxprice'],$myrow['decimalplaces']);
				$DisplayQty = locale_number_format($myrow2['quantity'],$myrow2['decimalplaces']);

				$LeftOvers = $pdf->addTextWrap($Left_Margin+5,$YPos,71,$FontSize,$myrow2['stockid']);// Print item code.
				//Get translation if it exists
				$TranslationResult = DB_query("SELECT descriptiontranslation
												FROM weberp_stockdescriptiontranslations
												WHERE stockid='" . $myrow2['stockid'] . "'
												AND language_id='" . $myrow['language_id'] ."'");

				if(DB_num_rows($TranslationResult)==1) { //there is a translation
					$TranslationRow = DB_fetch_array($TranslationResult);
					$LeftOvers = $pdf->addTextWrap($Left_Margin+80,$YPos,186,$FontSize,$TranslationRow['descriptiontranslation']);// Print translated item short description.
				} else {
					$LeftOvers = $pdf->addTextWrap($Left_Margin+80,$YPos,186,$FontSize,$myrow2['description']);// Print item short description.
				}
				$lines=1;
				while($LeftOvers!='') {
					$LeftOvers = $pdf->addTextWrap($Left_Margin+80,$YPos-(10*$lines),186,$FontSize,$LeftOvers);
					$lines++;
				}

				$LeftOvers = $pdf->addTextWrap($Left_Margin+270,$YPos,76,$FontSize,$DisplayPrice,'right');
				$LeftOvers = $pdf->addTextWrap($Left_Margin+350,$YPos,36,$FontSize,$DisplayQty,'right');
				$LeftOvers = $pdf->addTextWrap($Left_Margin+390,$YPos,26,$FontSize,$myrow2['units'],'center');
				$LeftOvers = $pdf->addTextWrap($Left_Margin+420,$YPos,26,$FontSize,$DisplayDiscount,'right');
				$LeftOvers = $pdf->addTextWrap($Page_Width-$Left_Margin-72, $YPos, 72, $FontSize, $DisplayNet, 'right');

				if($myrow2['controlled']==1) {

					$GetControlMovts = DB_query("
						SELECT
							moveqty,
							serialno
						FROM weberp_stockserialmoves
						WHERE stockmoveno='" . $myrow2['stkmoveno'] . "'");

					if($myrow2['serialised']==1) {
						while($ControlledMovtRow = DB_fetch_array($GetControlMovts)) {
							$YPos -= (10*$lines);
							$LeftOvers = $pdf->addTextWrap($Left_Margin+82,$YPos,100,$FontSize,$ControlledMovtRow['serialno'],'left');
							if($YPos-$line_height <= $Bottom_Margin) {
								/* head up a new invoice/credit note page */
								/*draw the vertical column lines right to the bottom */
								PrintLinesToBottom ();
								include ('includes/PDFTransPageHeaderPortrait.inc');
							} //end if need a new page headed up
						}
					} else {
						while($ControlledMovtRow = DB_fetch_array($GetControlMovts)) {
							$YPos -= (10*$lines);
							$LeftOvers = $pdf->addTextWrap($Left_Margin+82,$YPos,100,$FontSize,(-$ControlledMovtRow['moveqty']) . ' x ' . $ControlledMovtRow['serialno'], 'left');
							if($YPos-$line_height <= $Bottom_Margin) {
								/* head up a new invoice/credit note page */
								/*draw the vertical column lines right to the bottom */
								PrintLinesToBottom ();
								include ('includes/PDFTransPageHeaderPortrait.inc');
							} //end if need a new page headed up
						}
					}
				}
				$YPos -= ($FontSize*$lines);

				$lines=explode("\r\n",htmlspecialchars_decode($myrow2['narrative']));
				for ($i=0;$i<sizeOf($lines);$i++) {
					while(mb_strlen($lines[$i])>1) {
						if($YPos-$line_height <= $Bottom_Margin) {
							/* head up a new invoice/credit note page */
							/*draw the vertical column lines right to the bottom */
							PrintLinesToBottom ();
							include ('includes/PDFTransPageHeaderPortrait.inc');
						} //end if need a new page headed up
						/*increment a line down for the next line item */
						if(mb_strlen($lines[$i])>1) {
							$lines[$i] = $pdf->addTextWrap($Left_Margin+85,$YPos,181,$FontSize,stripslashes($lines[$i]));
						}
						$YPos -= ($line_height);
					}
				}

				if($YPos <= $Bottom_Margin) {
					/* head up a new invoice/credit note page */
					/*draw the vertical column lines right to the bottom */
					PrintLinesToBottom ();
					include ('includes/PDFTransPageHeaderPortrait.inc');
				} //end if need a new page headed up

			} /*end while there are line items to print out*/

		} /*end if there are stock movements to show on the invoice or credit note*/

		$YPos -= $line_height;

		/* check to see enough space left to print the 4 lines for the totals/footer */
		if(($YPos-$Bottom_Margin)<(2*$line_height)) {
			PrintLinesToBottom ();
			include ('includes/PDFTransPageHeaderPortrait.inc');
		}
		/*Print a column vertical line with enough space for the footer*/
		/*draw the vertical column lines to 4 lines shy of the bottom
		to leave space for invoice footer info ie totals etc*/
		$pdf->line($Left_Margin+78, $TopOfColHeadings+12,$Left_Margin+78,$Bottom_Margin+(4*$line_height));

		/*Print a column vertical line */
		$pdf->line($Left_Margin+268, $TopOfColHeadings+12,$Left_Margin+268,$Bottom_Margin+(4*$line_height));

		/*Print a column vertical line */
		$pdf->line($Left_Margin+348, $TopOfColHeadings+12,$Left_Margin+348,$Bottom_Margin+(4*$line_height));

		/*Print a column vertical line */
		$pdf->line($Left_Margin+388, $TopOfColHeadings+12,$Left_Margin+388,$Bottom_Margin+(4*$line_height));

		/*Print a column vertical line */
		$pdf->line($Left_Margin+418, $TopOfColHeadings+12,$Left_Margin+418,$Bottom_Margin+(4*$line_height));

		$pdf->line($Left_Margin+448, $TopOfColHeadings+12,$Left_Margin+448,$Bottom_Margin+(4*$line_height));

		/*Rule off at bottom of the vertical lines */
		$pdf->line($Left_Margin, $Bottom_Margin+(4*$line_height),$Page_Width-$Right_Margin,$Bottom_Margin+(4*$line_height));

		/*Now print out the footer and totals */

		if($InvOrCredit=='Invoice') {
			$DisplaySubTot = locale_number_format($myrow['ovamount'],$myrow['decimalplaces']);
			$DisplayFreight = locale_number_format($myrow['ovfreight'],$myrow['decimalplaces']);
			$DisplayTax = locale_number_format($myrow['ovgst'],$myrow['decimalplaces']);
			$DisplayTotal = locale_number_format($myrow['ovfreight']+$myrow['ovgst']+$myrow['ovamount'],$myrow['decimalplaces']);
		} else {
			$DisplaySubTot = locale_number_format(-$myrow['ovamount'],$myrow['decimalplaces']);
			$DisplayFreight = locale_number_format(-$myrow['ovfreight'],$myrow['decimalplaces']);
			$DisplayTax = locale_number_format(-$myrow['ovgst'],$myrow['decimalplaces']);
			$DisplayTotal = locale_number_format(-$myrow['ovfreight']-$myrow['ovgst']-$myrow['ovamount'],$myrow['decimalplaces']);
		}
	/*Print out the invoice text entered */
		$YPos = $Bottom_Margin+(3*$line_height);
	/* Print out the payment terms */

			$pdf->addTextWrap($Left_Margin, $YPos+3, 280, $FontSize,_('Payment Terms') . ': ' . $myrow['terms']);

		$FontSize =8;
		$LeftOvers=explode("\r\n",DB_escape_string($myrow['invtext']));
		for ($i=0;$i<sizeOf($LeftOvers);$i++) {
			$pdf->addText($Left_Margin, $YPos-8-($i*8), $FontSize, $LeftOvers[$i]);
		}
		$FontSize = 10;

		$LeftOvers = $pdf->addTextWrap($Page_Width-$Right_Margin-220, $YPos+5, 72, $FontSize, _('Sub Total'));
		$LeftOvers = $pdf->addTextWrap($Page_Width-$Left_Margin-72, $YPos+5, 72, $FontSize, $DisplaySubTot, 'right');

		$LeftOvers = $pdf->addTextWrap($Page_Width-$Right_Margin-220, $YPos+5-$line_height, 72, $FontSize, _('Freight'));
		$LeftOvers = $pdf->addTextWrap($Page_Width-$Left_Margin-72, $YPos+5-$line_height, 72, $FontSize, $DisplayFreight, 'right');

		$LeftOvers = $pdf->addTextWrap($Page_Width-$Right_Margin-220, $YPos+5-$line_height*2, 72, $FontSize, _('Tax'));
		$LeftOvers = $pdf->addTextWrap($Page_Width-$Left_Margin-72, $YPos+5-$line_height*2, 72, $FontSize, $DisplayTax, 'right');

		/*rule off for total */
		$pdf->line($Page_Width-$Right_Margin-222, $YPos-(2*$line_height),$Page_Width-$Right_Margin,$YPos-(2*$line_height));

		/*vertical to separate totals from comments and ROMALPA */
		$pdf->line($Page_Width-$Right_Margin-222, $YPos+$line_height,$Page_Width-$Right_Margin-222,$Bottom_Margin);

		$YPos+=10;
		if($InvOrCredit=='Invoice') {
			$LeftOvers = $pdf->addTextWrap($Page_Width-$Right_Margin-220, $Bottom_Margin+5, 144, $FontSize, _('TOTAL INVOICE'));
			$FontSize=8;
			$LeftOvers = $pdf->addTextWrap($Left_Margin, $YPos-18,280,$FontSize,$_SESSION['RomalpaClause']);
			while(mb_strlen($LeftOvers)>0 AND $YPos > $Bottom_Margin) {
				$YPos -=10;
				$LeftOvers = $pdf->addTextWrap($Left_Margin, $YPos-18,280,$FontSize,$LeftOvers);
			}
			/* Add Images for Visa / Mastercard / Paypal */
			if(file_exists('companies/' . $_SESSION['DatabaseName'] . '/payment.jpg')) {
				$pdf->addJpegFromFile('companies/' . $_SESSION['DatabaseName'] . '/payment.jpg',$Page_Width/2 -60,$YPos-15,0,20);
			}
			// Print Bank acount details if available and default for invoices is selected
			$pdf->addText($Left_Margin, $YPos+22-$line_height*3, $FontSize, $DefaultBankAccountCode . ' ' . $DefaultBankAccountNumber);
			$FontSize=10;
		} else {
			$LeftOvers = $pdf->addTextWrap($Page_Width-$Right_Margin-220, $Bottom_Margin+5, 144, $FontSize, _('TOTAL CREDIT'));
 		}
		$LeftOvers = $pdf->addTextWrap($Page_Width-$Left_Margin-72, $Bottom_Margin+5, 72, $FontSize, $DisplayTotal, 'right');
		} /* end of check to see that there was an invoice record to print */

		$FromTransNo++;
	} /* end loop to print invoices */

	/* Put the transaction number back as would have been incremented by one after last pass */
	$FromTransNo--;

	if(isset($_GET['Email'])) { //email the invoice to address supplied
		include ('includes/htmlMimeMail.php');
		$FromTransNo--; //reverse the increment to retain the correct transaction number
		$FileName = $_SESSION['reports_dir'] . '/' . $_SESSION['DatabaseName'] . '_' . $InvOrCredit . '_' . $_GET['FromTransNo'] . '.pdf';
		$pdf->Output($FileName,'F');
		$mail = new htmlMimeMail();

		$Attachment = $mail->getFile($FileName);
		$mail->setText(_('Please find attached') . ' ' . $InvOrCredit . ' ' . $_GET['FromTransNo'] );
		$mail->SetSubject($InvOrCredit . ' ' . $_GET['FromTransNo']);
		$mail->addAttachment($Attachment, $FileName, 'application/pdf');
		if($_SESSION['SmtpSetting'] == 0) {
			$mail->setFrom($_SESSION['CompanyRecord']['coyname'] . ' <' . $_SESSION['CompanyRecord']['email'] . '>');
			$result = $mail->send(array($_GET['Email']));
		} else {
			$result = SendmailBySmtp($mail,array($_GET['Email']));
		}

		unlink($FileName); //delete the temporary file

		$Title = _('Emailing') . ' ' .$InvOrCredit . ' ' . _('Number') . ' ' . $FromTransNo;
		include('includes/header.inc');
		echo '<p>' . $InvOrCredit . ' ' . _('number') . ' ' . $FromTransNo . ' ' . _('has been emailed to') . ' ' . $_GET['Email'];
		include('includes/footer.inc');
		exit;

	} else { //its not an email just print the invoice to PDF
		$pdf->OutputD($_SESSION['DatabaseName'] . '_' . $InvOrCredit . '_' . $FromTransNo . '.pdf');

	}
	$pdf->__destruct();
	//Change the language back to the user's language
	$_SESSION['Language'] = $UserLanguage;
	include('includes/LanguageSetup.php');

} else { /*The option to print PDF was not hit */

	$Title=_('Select Invoices/Credit Notes To Print');
	include('includes/header.inc');

	if(!isset($FromTransNo) OR $FromTransNo=='') {

	/*if FromTransNo is not set then show a form to allow input of either a single invoice number or a range of invoices to be printed. Also get the last invoice number created to show the user where the current range is up to */

		echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '" method="post">';
		echo '<div>';
		echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';

		echo '<p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/printer.png" title="' . _('Print') . '" alt="" />' . ' ' . _('Print Invoices or Credit Notes (Portrait Mode)') . '</p>';

		echo '<table class="selection">
				<tr>
					<td>' . _('Print Invoices or Credit Notes') . '</td>
					<td><select name="InvOrCredit">';

		if($InvOrCredit=='Invoice' OR !isset($InvOrCredit)) {
			echo '<option selected="selected" value="Invoice">' . _('Invoices') . '</option>';
			echo '<option value="Credit">' . _('Credit Notes') . '</option>';
		} else {
			echo '<option selected="selected" value="Credit">' . _('Credit Notes') . '</option>';
			echo '<option value="Invoice">' . _('Invoices') . '</option>';
		}
		echo '</select></td>
			</tr>
			<tr>
				<td>', _('Print EDI Transactions'), '</td>
				<td><select name="PrintEDI">';

		if($InvOrCredit=='Invoice' OR !isset($InvOrCredit)) {
			echo '<option selected="selected" value="No">' . _('Do not Print PDF EDI Transactions') . '</option>';
			echo '<option value="Yes">' . _('Print PDF EDI Transactions Too') . '</option>';
		} else {
			echo '<option value="No">' . _('Do not Print PDF EDI Transactions') . '</option>';
			echo '<option selected="selected" value="Yes">' . _('Print PDF EDI Transactions Too') . '</option>';
		}

		echo '</select></td>
			</tr>';
		echo '<tr>
				<td>' . _('Start invoice/credit note number to print') . '</td>
				<td><input class="number" type="text" maxlength="6" size="7" name="FromTransNo" /></td>
			</tr>';
		echo '<tr>
				<td>' . _('End invoice/credit note number to print') . '</td>
				<td><input class="number" type="text" maxlength="6" size="7" name="ToTransNo" /></td>
			</tr>
			</table>';
		echo '<div class="centre">
				<br />
				<input type="submit" name="Print" value="' . _('Print Preview') . '" />
				<br />
				<input type="submit" name="PrintPDF" value="' . _('Print PDF') . '" />
			</div>';

		$sql = "SELECT typeno FROM weberp_systypes WHERE typeid=10";

		$result = DB_query($sql);
		$myrow = DB_fetch_row($result);

		echo '<div class="page_help_text"><b>' . _('The last invoice created was number') . ' ' . $myrow[0] . '</b><br />' . _('If only a single invoice is required') . ', ' . _('enter the invoice number to print in the Start transaction number to print field and leave the End transaction number to print field blank') . '. ' . _('Only use the end invoice to print field if you wish to print a sequential range of invoices') . '';

		$sql = "SELECT typeno FROM weberp_systypes WHERE typeid='11'";

		$result = DB_query($sql);
		$myrow = DB_fetch_row($result);

		echo '<br /><b>' . _('The last credit note created was number') . ' ' . $myrow[0] . '</b><br />' . _('A sequential range can be printed using the same method as for invoices above') . '. ' . _('A single credit note can be printed by only entering a start transaction number') . '</div>';
		echo '</div>
			</form>';

	} else {

		while($FromTransNo <= $_POST['ToTransNo']) {

	/*retrieve the invoice details from the database to print
	notice that salesorder record must be present to print the invoice purging of sales orders will
	nobble the invoice reprints */

			if($InvOrCredit=='Invoice') {

				$sql = "SELECT weberp_debtortrans.trandate,
							weberp_debtortrans.ovamount,
							weberp_debtortrans.ovdiscount,
							weberp_debtortrans.ovfreight,
							weberp_debtortrans.ovgst,
							weberp_debtortrans.rate,
							weberp_debtortrans.invtext,
							weberp_debtortrans.consignment,
							weberp_debtorsmaster.name,
							weberp_debtorsmaster.address1,
							weberp_debtorsmaster.address2,
							weberp_debtorsmaster.address3,
							weberp_debtorsmaster.address4,
							weberp_debtorsmaster.address5,
							weberp_debtorsmaster.address6,
							weberp_debtorsmaster.currcode,
							weberp_salesorders.deliverto,
							weberp_salesorders.deladd1,
							weberp_salesorders.deladd2,
							weberp_salesorders.deladd3,
							weberp_salesorders.deladd4,
							weberp_salesorders.deladd5,
							weberp_salesorders.deladd6,
							weberp_salesorders.customerref,
							weberp_salesorders.orderno,
							weberp_salesorders.orddate,
							weberp_shippers.shippername,
							weberp_custbranch.brname,
							weberp_custbranch.braddress1,
							weberp_custbranch.braddress2,
							weberp_custbranch.braddress3,
							weberp_custbranch.braddress4,
							weberp_custbranch.braddress5,
							weberp_custbranch.braddress6,
							weberp_salesman.salesmanname,
							weberp_debtortrans.debtorno,
							weberp_currencies.decimalplaces
						FROM weberp_debtortrans INNER JOIN weberp_debtorsmaster
						ON weberp_debtortrans.debtorno=weberp_debtorsmaster.debtorno
						INNER JOIN weberp_custbranch
						ON weberp_debtortrans.debtorno=weberp_custbranch.debtorno
						AND weberp_debtortrans.branchcode=weberp_custbranch.branchcode
						INNER JOIN weberp_salesorders
						ON weberp_debtortrans.order_ = weberp_salesorders.orderno
						INNER JOIN weberp_shippers
						ON weberp_debtortrans.shipvia=weberp_shippers.shipper_id
						INNER JOIN weberp_salesman
						ON weberp_custbranch.salesman=weberp_salesman.salesmancode
						INNER JOIN weberp_locations
						ON weberp_salesorders.fromstkloc=weberp_locations.loccode
						INNER JOIN weberp_locationusers
						ON weberp_locationusers.loccode=weberp_locations.loccode AND weberp_locationusers.userid='" . $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1
						INNER JOIN weberp_paymentterms
						ON weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator
						INNER JOIN weberp_currencies
						ON weberp_debtorsmaster.currcode=weberp_currencies.currabrev
						WHERE weberp_debtortrans.type=10
						AND weberp_debtortrans.transno='" . $FromTransNo . "'";
			} else { //its a credit note

				$sql = "SELECT weberp_debtortrans.trandate,
							weberp_debtortrans.ovamount,
							weberp_debtortrans.ovdiscount,
							weberp_debtortrans.ovfreight,
							weberp_debtortrans.ovgst,
							weberp_debtortrans.rate,
							weberp_debtortrans.invtext,
							weberp_debtorsmaster.name,
							weberp_debtorsmaster.address1,
							weberp_debtorsmaster.address2,
							weberp_debtorsmaster.address3,
							weberp_debtorsmaster.address4,
							weberp_debtorsmaster.address5,
							weberp_debtorsmaster.address6,
							weberp_debtorsmaster.currcode,
							weberp_custbranch.brname,
							weberp_custbranch.braddress1,
							weberp_custbranch.braddress2,
							weberp_custbranch.braddress3,
							weberp_custbranch.braddress4,
							weberp_custbranch.braddress5,
							weberp_custbranch.braddress6,
							weberp_salesman.salesmanname,
							weberp_debtortrans.debtorno,
							weberp_currencies.decimalplaces
						FROM weberp_debtortrans INNER JOIN weberp_debtorsmaster
						ON weberp_debtortrans.debtorno=weberp_debtorsmaster.debtorno
						INNER JOIN weberp_custbranch
						ON weberp_debtortrans.debtorno=weberp_custbranch.debtorno
						AND weberp_debtortrans.branchcode=weberp_custbranch.branchcode
						INNER JOIN weberp_salesman
						ON weberp_custbranch.salesman=weberp_salesman.salesmancode
						INNER JOIN weberp_paymentterms
						ON weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator
						INNER JOIN weberp_currencies
						ON weberp_debtorsmaster.currcode=weberp_currencies.currabrev
						WHERE weberp_debtortrans.type=11
						AND weberp_debtortrans.transno='" . $FromTransNo . "'";

			}

			$result=DB_query($sql);
			if(DB_num_rows($result)==0 OR DB_error_no()!=0) {
				echo '<p>' . _('There was a problem retrieving the invoice or credit note details for note number') . ' ' . $InvoiceToPrint . ' ' . _('from the database') . '. ' . _('To print an invoice, the sales order record, the customer transaction record and the branch record for the customer must not have been purged') . '. ' . _('To print a credit note only requires the customer, transaction, salesman and branch records be available');
				if($debug==1) {
					prnMsg( _('The SQL used to get this information that failed was') . '<br />' . $sql,'warn');
				}
				break;
				include('includes/footer.inc');
				exit;
			} elseif(DB_num_rows($result)==1) {

				$myrow = DB_fetch_array($result);
	/* Then there's an invoice (or credit note) to print. So print out the invoice header and GST Number from the company record */
				if(count($_SESSION['AllowedPageSecurityTokens'])==1 AND in_array(1, $_SESSION['AllowedPageSecurityTokens']) AND $myrow['debtorno'] != $_SESSION['CustomerID']) {
					echo '<p class="bad">' . _('This transaction is addressed to another customer and cannot be displayed for privacy reasons') . '. ' . _('Please select only transactions relevant to your company');
					exit;
				}

				$ExchRate = $myrow['rate'];
				$PageNumber = 1;

				echo '<table class="table1">
						<tr>
							<td valign="top" style="width:10%"><img src="' . $_SESSION['LogoFile'] . '" alt="" /></td>
							<td style="background-color:#bbbbbb">';

				if($InvOrCredit=='Invoice') {
					echo '<h2>' . _('TAX INVOICE') . ' ';
				} else {
					echo '<h2 style="color:red">' . _('TAX CREDIT NOTE') . ' ';
				}
				echo _('Number') . ' ' . $FromTransNo . '</h2>
					<br />' . _('Tax Authority Ref') . '. ' . $_SESSION['CompanyRecord']['gstno'] . '</td>
					</tr>
					</table>';

	/*Now print out the logo and company name and address */
				echo '<table class="table1">
						<tr>
							<td><h2>' . $_SESSION['CompanyRecord']['coyname'] . '</h2>
							<br />';
				echo $_SESSION['CompanyRecord']['regoffice1'] . '<br />';
				echo $_SESSION['CompanyRecord']['regoffice2'] . '<br />';
				echo $_SESSION['CompanyRecord']['regoffice3'] . '<br />';
				echo $_SESSION['CompanyRecord']['regoffice4'] . '<br />';
				echo $_SESSION['CompanyRecord']['regoffice5'] . '<br />';
				echo $_SESSION['CompanyRecord']['regoffice6'] . '<br />';
				echo _('Telephone') . ': ' . $_SESSION['CompanyRecord']['telephone'] . '<br />';
				echo _('Facsimile') . ': ' . $_SESSION['CompanyRecord']['fax'] . '<br />';
				echo _('Email') . ': ' . $_SESSION['CompanyRecord']['email'] . '<br />';

				echo '</td>
					<td style="width:50%" class="number">';

	/*Now the customer charged to details in a sub table within a cell of the main table*/

				echo '<table class="table1">
						<tr>
							<td align="left" style="background-color:#bbbbbb"><b>' . _('Charge To') . ':</b></td>
						</tr>
						<tr>
							<td style="background-color:#eeeeee">';
				echo $myrow['name'] .
					'<br />' . $myrow['address1'] .
					'<br />' . $myrow['address2'] .
					'<br />' . $myrow['address3'] .
					'<br />' . $myrow['address4'] .
					'<br />' . $myrow['address5'] .
					'<br />' . $myrow['address6'];

				echo '</td>
					</tr>
					</table>';
				/*end of the small table showing charge to account details */
				echo _('Page') . ': ' . $PageNumber;
				echo '</td>
					</tr>
					</table>';
				/*end of the main table showing the company name and charge to details */

				if($InvOrCredit=='Invoice') {

					echo '<table class="table1">
						<tr>
							<td align="left" style="background-color:#bbbbbb"><b>' . _('Charge Branch') . ':</b></td>
							<td align="left" style="background-color:#bbbbbb"><b>' . _('Delivered To') . ':</b></td>
						</tr>';
					echo '<tr>
						<td style="background-color:#eeeeee">' .$myrow['brname'] .
									'<br />' . $myrow['braddress1'] .
									'<br />' . $myrow['braddress2'] .
									'<br />' . $myrow['braddress3'] .
									'<br />' . $myrow['braddress4'] .
									'<br />' . $myrow['braddress5'] .
									'<br />' . $myrow['braddress6'] .
						'</td>';

					echo '<td style="background-color:#eeeeee">' . $myrow['deliverto'] .
									'<br />' . $myrow['deladd1'] .
									'<br />' . $myrow['deladd2'] .
									'<br />' . $myrow['deladd3'] .
									'<br />' . $myrow['deladd4'] .
									'<br />' . $myrow['deladd5'] .
									'<br />' . $myrow['deladd6'] .
						'</td>';
					echo '</tr>
					</table><hr />';

					echo '<table class="table1">
						<tr>
							<td align="left" style="background-color:#bbbbbb"><b>' . _('Your Order Ref') . '</b></td>
							<td align="left" style="background-color:#bbbbbb"><b>' . _('Our Order No') . '</b></td>
							<td align="left" style="background-color:#bbbbbb"><b>' . _('Order Date') . '</b></td>
							<td align="left" style="background-color:#bbbbbb"><b>' . _('Invoice Date') . '</b></td>
							<td align="left" style="background-color:#bbbbbb"><b>' . _('Sales Person') . '</b></td>
							<td align="left" style="background-color:#bbbbbb"><b>' . _('Shipper') . '</b></td>
							<td align="left" style="background-color:#bbbbbb"><b>' . _('Consignment Ref') . '</b></td>
						</tr>';
					echo '<tr>
							<td style="background-color:#EEEEEE">' . $myrow['customerref'] . '</td>
							<td style="background-color:#EEEEEE">' .$myrow['orderno'] . '</td>
							<td style="background-color:#EEEEEE">' . ConvertSQLDate($myrow['orddate']) . '</td>
							<td style="background-color:#EEEEEE">' . ConvertSQLDate($myrow['trandate']) . '</td>
							<td style="background-color:#EEEEEE">' . $myrow['salesmanname'] . '</td>
							<td style="background-color:#EEEEEE">' . $myrow['shippername'] . '</td>
							<td style="background-color:#EEEEEE">' . $myrow['consignment'] . '</td>
						</tr>
					</table>';

					$sql ="SELECT weberp_stockmoves.stockid,
								weberp_stockmaster.description,
								-weberp_stockmoves.qty as quantity,
								weberp_stockmoves.discountpercent,
								((1 - weberp_stockmoves.discountpercent) * weberp_stockmoves.price * " . $ExchRate . "* -weberp_stockmoves.qty) AS fxnet,
								(weberp_stockmoves.price * " . $ExchRate . ") AS fxprice,
								weberp_stockmoves.narrative,
								weberp_stockmaster.units,
								weberp_stockmaster.decimalplaces
							FROM weberp_stockmoves INNER JOIN weberp_stockmaster
							ON weberp_stockmoves.stockid = weberp_stockmaster.stockid
							WHERE weberp_stockmoves.type=10
							AND weberp_stockmoves.transno='" . $FromTransNo . "'
							AND weberp_stockmoves.show_on_inv_crds=1";

				} else { /* then its a credit note */

					echo '<table width="50%">
						<tr>
							<td align="left" style="background-color:#BBBBBB"><b>' . _('Branch') . ':</b></td>
						</tr>';
					echo '<tr>
							<td style="background-color:#EEEEEE">' . $myrow['brname'] .
										'<br />' . $myrow['braddress1'] .
										'<br />' . $myrow['braddress2'] .
										'<br />' . $myrow['braddress3'] .
										'<br />' . $myrow['braddress4'] .
										'<br />' . $myrow['braddress5'] .
										'<br />' . $myrow['braddress6'] .
								'</td>
					</tr></table>';
					echo '<hr />
						<table class="table1">
						<tr>
							<td align="left" style="background-color:#bbbbbb"><b>' . _('Date') . '</b></td>
							<td align="left" style="background-color:#BBBBBB"><b>' . _('Sales Person') . '</b></td>
						</tr>';
					echo '<tr>
							<td style="background-color:#EEEEEE">' . ConvertSQLDate($myrow['trandate']) . '</td>
							<td style="background-color:#EEEEEE">' . $myrow['salesmanname'] . '</td>
						</tr>
						</table>';


					$sql ="SELECT weberp_stockmoves.stockid,
								weberp_stockmaster.description,
								weberp_stockmoves.qty as quantity,
								weberp_stockmoves.discountpercent, ((1 - weberp_stockmoves.discountpercent) * weberp_stockmoves.price * " . $ExchRate . " * weberp_stockmoves.qty) AS fxnet,
								(weberp_stockmoves.price * " . $ExchRate . ") AS fxprice,
								weberp_stockmaster.units,
								weberp_stockmoves.narrative,
								weberp_stockmaster.decimalplaces
							FROM weberp_stockmoves INNER JOIN weberp_stockmaster
							ON weberp_stockmoves.stockid = weberp_stockmaster.stockid
							WHERE weberp_stockmoves.type=11
							AND weberp_stockmoves.transno='" . $FromTransNo . "'
							AND weberp_stockmoves.show_on_inv_crds=1";
				}

				echo '<hr />';
				echo '<div class="centre"><h4>' . _('All amounts stated in') . ' ' . $myrow['currcode'] . '</h4></div>';

				$result=DB_query($sql);
				if(DB_error_no()!=0) {
					echo '<br />' . _('There was a problem retrieving the invoice or credit note stock movement details for invoice number') . ' ' . $FromTransNo . ' ' . _('from the database');
					if($debug==1) {
						 echo '<br />' . _('The SQL used to get this information that failed was') . '<br />' . $sql;
					}
					exit;
				}

				if(DB_num_rows($result)>0) {
					echo '<table class="table1">
							<tr>
								<th>' . _('Item Code') . '</th>
								<th>' . _('Item Description') . '</th>
								<th>' . _('Quantity') . '</th>
								<th>' . _('Unit') . '</th>
								<th>' . _('Price') . '</th>
								<th>' . _('Discount') . '</th>
								<th>' . _('Net') . '</th>
							</tr>';

					$LineCounter =17;
					$k=0;	//row colour counter

					while($myrow2=DB_fetch_array($result)) {

						if($k==1) {
							$RowStarter = '<tr class="EvenTableRows">';
							$k=0;
						} else {
							$RowStarter = '<tr class="OddTableRows">';
							$k=1;
						}

						echo $RowStarter;

						$DisplayPrice =locale_number_format($myrow2['fxprice'],$myrow['decimalplaces']);
						$DisplayQty = locale_number_format($myrow2['quantity'],$myrow2['decimalplaces']);
						$DisplayNet = locale_number_format($myrow2['fxnet'],$myrow['decimalplaces']);

						if($myrow2['discountpercent']==0) {
							$DisplayDiscount ='';
						} else {
							$DisplayDiscount = locale_number_format($myrow2['discountpercent']*100,2) . '%';
						}

						printf ('<td>%s</td>
								<td>%s</td>
								<td class="number">%s</td>
								<td class="number">%s</td>
								<td class="number">%s</td>
								<td class="number">%s</td>
								<td class="number">%s</td>
								</tr>',
								$myrow2['stockid'],
								$myrow2['description'],
								$DisplayQty,
								$myrow2['units'],
								$DisplayPrice,
								$DisplayDiscount,
								$DisplayNet);

						if(mb_strlen($myrow2['narrative'])>1) {
							echo $RowStarter .
								'<td></td>
								<td colspan="6">' . $myrow2['narrative'] . '</td>
								</tr>';
							$LineCounter++;
						}

						$LineCounter++;

						if($LineCounter == ($_SESSION['PageLength'] - 2)) {

							/* head up a new invoice/credit note page */

							$PageNumber++;
							echo '</table>
								<table class="table1">
								<tr>
									<td valign="top"><img src="' . $_SESSION['LogoFile'] . '" alt="" /></td>
									<td style="background-color:#bbbbbb">';

							if($InvOrCredit=='Invoice') {
								echo '<h2>' . _('TAX INVOICE') . ' ';
							} else {
								echo '<h2 style="color:red">' . _('TAX CREDIT NOTE') . ' ';
							}
							echo _('Number') . ' ' . $FromTransNo . '</h2><br />' . _('GST Number') . ' - ' . $_SESSION['CompanyRecord']['gstno'] . '</td>
							</tr>
							</table>';

	/*Now print out company name and address */
							echo '<table class="table1">
									<tr>
										<td><h2>' . $_SESSION['CompanyRecord']['coyname'] . '</h2><br />';
							echo $_SESSION['CompanyRecord']['regoffice1'] . '<br />';
							echo $_SESSION['CompanyRecord']['regoffice2'] . '<br />';
							echo $_SESSION['CompanyRecord']['regoffice3'] . '<br />';
							echo $_SESSION['CompanyRecord']['regoffice4'] . '<br />';
							echo $_SESSION['CompanyRecord']['regoffice5'] . '<br />';
							echo $_SESSION['CompanyRecord']['regoffice6'] . '<br />';
							echo _('Telephone') . ': ' . $_SESSION['CompanyRecord']['telephone'] . '<br />';
							echo _('Facsimile') . ': ' . $_SESSION['CompanyRecord']['fax'] . '<br />';
							echo _('Email') . ': ' . $_SESSION['CompanyRecord']['email'] . '<br />';
							echo '</td><td class="number">' . _('Page') . ': ' . $PageNumber . '</td>
									</tr>
								</table>';
							echo '<table class="table1">
									<tr>
										<th>' . _('Item Code') . '</th>
										<th>' . _('Item Description') . '</th>
										<th>' . _('Quantity') . '</th>
										<th>' . _('Unit') . '</th>
										<th>' . _('Price') . '</th>
										<th>' . _('Discount') . '</th>
										<th>' . _('Net') . '</th>
									</tr>';

							$LineCounter = 10;

						} //end if need a new page headed up
					} //end while there are line items to print out
					echo '</table>';
				} /*end if there are stock movements to show on the invoice or credit note*/

				/* check to see enough space left to print the totals/footer */
				$LinesRequiredForText = floor(mb_strlen($myrow['invtext'])/140);

				if($LineCounter >= ($_SESSION['PageLength'] - 8 - $LinesRequiredForText)) {

					/* head up a new invoice/credit note page */

					$PageNumber++;
					echo '<table class="table1">
							<tr>
								<td valign="top"><img src="' . $_SESSION['LogoFile'] . '" alt="" /></td>
								<td style="background-color:#bbbbbb">';
					if($InvOrCredit=='Invoice') {
						echo '<h2>' . _('TAX INVOICE') .' ';
					} else {
						echo '<h2 style="color:red">' . _('TAX CREDIT NOTE') . ' ';
					}
					echo _('Number') . ' ' . $FromTransNo . '</h2>
							<br />' . _('GST Number') . ' - ' . $_SESSION['CompanyRecord']['gstno'] . '</td>
						</tr>
						</table>';

	/*Print out the logo and company name and address */
					echo '<table class="table1">
							<tr>
								<td><h2>' . $_SESSION['CompanyRecord']['coyname'] . '</h2><br />';
					echo $_SESSION['CompanyRecord']['regoffice1'] . '<br />';
					echo $_SESSION['CompanyRecord']['regoffice2'] . '<br />';
					echo $_SESSION['CompanyRecord']['regoffice3'] . '<br />';
					echo $_SESSION['CompanyRecord']['regoffice4'] . '<br />';
					echo $_SESSION['CompanyRecord']['regoffice5'] . '<br />';
					echo $_SESSION['CompanyRecord']['regoffice6'] . '<br />';
					echo _('Telephone') . ': ' . $_SESSION['CompanyRecord']['telephone'] . '<br />';
					echo _('Facsimile') . ': ' . $_SESSION['CompanyRecord']['fax'] . '<br />';
					echo _('Email') . ': ' . $_SESSION['CompanyRecord']['email'] . '<br />';
					echo '</td><td class="number">' . _('Page') . ': ' . $PageNumber . '</td>
						</tr>
						</table>';
					echo '<table class="table1">
							<tr>
								<th>' . _('Item Code') . '</th>
								<th>' . _('Item Description') . '</th>
								<th>' . _('Quantity') . '</th>
								<th>' . _('Unit') . '</th>
								<th>' . _('Price') . '</th>
								<th>' . _('Discount') . '</th>
								<th>' . _('Net') . '</th>
							</tr>
						</table>';

					$LineCounter = 10;
				}

	/*Space out the footer to the bottom of the page */

				echo '<br /><br />' . $myrow['invtext'];

				$LineCounter=$LineCounter+2+$LinesRequiredForText;
				while($LineCounter < ($_SESSION['PageLength'] -6)) {
					echo '<br />';
					$LineCounter++;
				}

	/*Now print out the footer and totals */

				if($InvOrCredit=='Invoice') {
					$DisplaySubTot = locale_number_format($myrow['ovamount'],$myrow['decimalplaces']);
					$DisplayFreight = locale_number_format($myrow['ovfreight'],$myrow['decimalplaces']);
					$DisplayTax = locale_number_format($myrow['ovgst'],$myrow['decimalplaces']);
					$DisplayTotal = locale_number_format($myrow['ovfreight']+$myrow['ovgst']+$myrow['ovamount'],$myrow['decimalplaces']);
				} else {
					$DisplaySubTot = locale_number_format(-$myrow['ovamount'],$myrow['decimalplaces']);
					$DisplayFreight = locale_number_format(-$myrow['ovfreight'],$myrow['decimalplaces']);
					$DisplayTax = locale_number_format(-$myrow['ovgst'],$myrow['decimalplaces']);
					$DisplayTotal = locale_number_format(-$myrow['ovfreight']-$myrow['ovgst']-$myrow['ovamount'],$myrow['decimalplaces']);
				}
	/*Print out the invoice text entered */
				echo '<table class="table1"><tr>
					<td class="number">' . _('Sub Total') . '</td>
					<td class="number" style="background-color:#EEEEEE;width:15%">' . $DisplaySubTot . '</td></tr>';
				echo '<tr><td class="number">' . _('Freight') . '</td>
					<td class="number" style="background-color:#EEEEEE">' . $DisplayFreight . '</td></tr>';
				echo '<tr><td class="number">' . _('Tax') . '</td>
					<td class="number" style="background-color:#EEEEEE">' . $DisplayTax . '</td></tr>';
				if($InvOrCredit=='Invoice') {
					echo '<tr><td class="number"><b>' . _('TOTAL INVOICE') . '</b></td>
						<td class="number" style="background-color:#EEEEEE"><b>' . $DisplayTotal . '</b></td></tr>';
				} else {
					echo '<tr><td class="number" style="color:red"><b>' . _('TOTAL CREDIT') . '</b></td>
							<td class="number" style="background-color:#EEEEEE;color:red"><b>' . $DisplayTotal . '</b></td></tr>';
				}
				echo '</table>';
			} /* end of check to see that there was an invoice record to print */
			$FromTransNo++;
		} /* end loop to print invoices */
	} /*end of if FromTransNo exists */
	include('includes/footer.inc');

} /*end of else not PrintPDF */


function PrintLinesToBottom () {

	global $Bottom_Margin;
	global $Left_Margin;
	global $line_height;
	global $PageNumber;
	global $pdf;
	global $TopOfColHeadings;

	// Prints column vertical lines:
	$pdf->line($Left_Margin+ 78, $TopOfColHeadings+12,$Left_Margin+ 78,$Bottom_Margin);
	$pdf->line($Left_Margin+268, $TopOfColHeadings+12,$Left_Margin+268,$Bottom_Margin);
	$pdf->line($Left_Margin+348, $TopOfColHeadings+12,$Left_Margin+348,$Bottom_Margin);
	$pdf->line($Left_Margin+388, $TopOfColHeadings+12,$Left_Margin+388,$Bottom_Margin);
	$pdf->line($Left_Margin+418, $TopOfColHeadings+12,$Left_Margin+418,$Bottom_Margin);
	$pdf->line($Left_Margin+448, $TopOfColHeadings+12,$Left_Margin+448,$Bottom_Margin);

	$PageNumber++;
}

?>
