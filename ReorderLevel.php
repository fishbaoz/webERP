<?php

/* $Id: ReorderLevel.php 6944 2014-10-27 07:15:34Z daintree $*/

// ReorderLevel.php - Report of parts with quantity below reorder level
// Shows if there are other locations that have quantities for the parts that are short

include('includes/session.inc');
if (isset($_POST['PrintPDF'])) {
	$PaperSize='A4_Landscape';
	include('includes/PDFStarter.php');
	$pdf->addInfo('Title',_('Reorder Level Report'));
	$pdf->addInfo('Subject',_('Parts below reorder level'));
	$FontSize=9;
	$PageNumber=1;
	$line_height=12;

	$Xpos = $Left_Margin+1;
	$WhereCategory = ' ';
	$CategoryDescription = ' ';
	if ($_POST['StockCat'] != 'All') {
		$WhereCategory = " AND weberp_stockmaster.categoryid='" . $_POST['StockCat'] . "'";
		$sql= "SELECT categoryid,
					categorydescription
				FROM weberp_stockcategory
				WHERE categoryid='" . $_POST['StockCat'] . "'";
		$result = DB_query($sql);
		$myrow = DB_fetch_row($result);
		$CategoryDescription = $myrow[1];
	}
	$WhereLocation = " ";
	if ($_POST['StockLocation'] != 'All') {
		$WhereLocation = " AND weberp_locstock.loccode='" . $_POST['StockLocation'] . "' ";
	}

	$sql = "SELECT weberp_locstock.stockid,
					weberp_stockmaster.description,
					weberp_locstock.loccode,
					weberp_locations.locationname,
					weberp_locstock.quantity,
					weberp_locstock.reorderlevel,
					weberp_stockmaster.decimalplaces,
					weberp_stockmaster.serialised,
					weberp_stockmaster.controlled
				FROM weberp_locstock INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locstock.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1,
					weberp_stockmaster
				LEFT JOIN weberp_stockcategory
				ON weberp_stockmaster.categoryid=weberp_stockcategory.categoryid,
					weberp_locations
				WHERE weberp_locstock.stockid=weberp_stockmaster.stockid " .
				$WhereLocation .
				"AND weberp_locstock.loccode=weberp_locations.loccode
				AND weberp_locstock.reorderlevel > weberp_locstock.quantity
				AND (weberp_stockmaster.mbflag='B' OR weberp_stockmaster.mbflag='M') " .
				$WhereCategory . " ORDER BY weberp_locstock.loccode,weberp_locstock.stockid";

	$result = DB_query($sql,'','',false,true);

	if (DB_error_no() !=0) {
	  $Title = _('Reorder Level') . ' - ' . _('Problem Report');
	  include('includes/header.inc');
	   prnMsg( _('The Reorder Level report could not be retrieved by the SQL because') . ' '  . DB_error_msg(),'error');
	   echo '<br /><a href="' .$RootPath .'/index.php">' . _('Back to the menu') . '</a>';
	   if ($debug==1){
		  echo '<br />' . $sql;
	   }
	   include('includes/footer.inc');
	   exit;
	}

	PrintHeader($pdf,$YPos,$PageNumber,$Page_Height,$Top_Margin,$Left_Margin,
				$Page_Width,$Right_Margin,$CategoryDescription);

	$FontSize=8;

	$ListCount = 0; // UldisN

	while ($myrow = DB_fetch_array($result,$db)){
		$YPos -=(2 * $line_height);

		$ListCount ++;

		$OnOrderSQL = "SELECT SUM(quantityord-quantityrecd) AS quantityonorder
								FROM weberp_purchorders
								LEFT JOIN weberp_purchorderdetails
								ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
								WHERE weberp_purchorders.status !='Cancelled'
								AND weberp_purchorders.status !='Rejected'
								AND weberp_purchorders.status !='Pending'
								AND weberp_purchorderdetails.itemcode='".$myrow['stockid']."'
								      AND weberp_purchorders.intostocklocation='".$myrow['loccode']."'";
		$OnOrderResult = DB_query($OnOrderSQL);
		$OnOrderRow = DB_fetch_array($OnOrderResult);
		// Parameters for addTextWrap are defined in /includes/class.pdf.php
		// 1) X position 2) Y position 3) Width
		// 4) Height 5) Text 6) Alignment 7) Border 8) Fill - True to use SetFillColor
		// and False to set to transparent
		$fill = '';
		$pdf->addTextWrap(50,$YPos,100,$FontSize,$myrow['stockid'],'',0,$fill);
		$pdf->addTextWrap(150,$YPos,150,$FontSize,$myrow['description'],'',0,$fill);
		$pdf->addTextWrap(410,$YPos,60,$FontSize,$myrow['loccode'],'left',0,$fill);
		$pdf->addTextWrap(470,$YPos,50,$FontSize,locale_number_format($myrow['quantity'], $myrow['decimalplaces']),'right',0,$fill);
		$pdf->addTextWrap(520,$YPos,50,$FontSize,locale_number_format($myrow['reorderlevel'], $myrow['decimalplaces']),'right',0,$fill);
		$pdf->addTextWrap(570,$YPos,50,$FontSize,locale_number_format($OnOrderRow['quantityonorder'], $myrow['decimalplaces']),'right',0,$fill);
		$shortage = $myrow['reorderlevel'] - $myrow['quantity'] - $OnOrderRow['quantityonorder'];
		$pdf->addTextWrap(620,$YPos,50,$FontSize,locale_number_format($shortage, $myrow['decimalplaces']),'right',0,$fill);

		if ($YPos < $Bottom_Margin + $line_height){
		   PrintHeader($pdf,$YPos,$PageNumber,$Page_Height,$Top_Margin,$Left_Margin,$Page_Width,
					   $Right_Margin,$CategoryDescription);
		}
		$OnOrderSQL = "SELECT SUM(quantityord-quantityrecd) AS quantityonorder
								FROM weberp_purchorders
								LEFT JOIN weberp_purchorderdetails
								ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
								WHERE weberp_purchorders.status != 'Cancelled'
									AND weberp_purchorders.status != 'Rejected'
									AND weberp_purchorders.status != 'Pending'
								      AND weberp_purchorderdetails.itemcode='".$myrow['stockid']."'
								      AND weberp_purchorders.intostocklocation='".$myrow['loccode']."'";
		$OnOrderResult = DB_query($OnOrderSQL);
		$OnOrderRow = DB_fetch_array($OnOrderResult);

		// Print if stock for part in other locations
		$sql2 = "SELECT weberp_locstock.quantity,
								weberp_locstock.loccode,
								weberp_locstock.reorderlevel,
								weberp_stockmaster.decimalplaces
						 FROM weberp_locstock INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locstock.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1, weberp_stockmaster
						 WHERE weberp_locstock.quantity > 0
						 AND weberp_locstock.quantity > reorderlevel
						 AND weberp_locstock.stockid = weberp_stockmaster.stockid
						 AND weberp_locstock.stockid ='" . $myrow['stockid'] .
						 "' AND weberp_locstock.loccode !='" . $myrow['loccode'] . "'";
		$OtherResult = DB_query($sql2,'','',false,true);
		while ($myrow2 = DB_fetch_array($OtherResult,$db)){
			$YPos -=$line_height;

			// Parameters for addTextWrap are defined in /includes/class.pdf.php
			// 1) X position 2) Y position 3) Width
			// 4) Height 5) Text 6) Alignment 7) Border 8) Fill - True to use SetFillColor
			// and False to set to transparent
			$OnOrderSQL = "SELECT SUM(quantityord-quantityrecd) AS quantityonorder
								FROM weberp_purchorders
								LEFT JOIN weberp_purchorderdetails
								ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
								WHERE weberp_purchorders.status !='Cancelled'
									AND weberp_purchorders.status !='Rejected'
									AND weberp_purchorders.status !='Pending'
							      	      AND weberp_purchorderdetails.itemcode='".$myrow['stockid']."'
								      AND weberp_purchorders.intostocklocation='".$myrow2['loccode']."'";
			$OnOrderResult = DB_query($OnOrderSQL);
			$OnOrderRow = DB_fetch_array($OnOrderResult);

			$pdf->addTextWrap(410,$YPos,60,$FontSize,$myrow2['loccode'],'left',0,$fill);
			$pdf->addTextWrap(470,$YPos,50,$FontSize,locale_number_format($myrow2['quantity'], $myrow2['decimalplaces']),'right',0,$fill);
			$pdf->addTextWrap(520,$YPos,50,$FontSize,locale_number_format($myrow2['reorderlevel'], $myrow2['decimalplaces']),'right',0,$fill);
			$pdf->addTextWrap(570,$YPos,50,$FontSize,locale_number_format($OnOrderRow['quantityonorder'], $myrow['decimalplaces']),'right',0,$fill);
			$shortage = $myrow['reorderlevel'] - $myrow['quantity'] - $OnOrderRow['quantityonorder'];
			$pdf->addTextWrap(620,$YPos,50,$FontSize,locale_number_format($shortage, $myrow['decimalplaces']),'right',0,$fill);

			if ($YPos < $Bottom_Margin + $line_height){
			   PrintHeader($pdf,$YPos,$PageNumber,$Page_Height,$Top_Margin,$Left_Margin,$Page_Width,$Right_Margin,$CategoryDescription);
			}

		} /*end while loop */

	} /*end while loop */

	if ($YPos < $Bottom_Margin + $line_height){
		   PrintHeader($pdf,$YPos,$PageNumber,$Page_Height,$Top_Margin,$Left_Margin,$Page_Width,$Right_Margin,$CategoryDescription);
	}
/*Print out the grand totals */

	//$pdfcode = $pdf->output();
	//$len = mb_strlen($pdfcode);

	if ($ListCount == 0){
			$Title = _('Print Reorder Level Report');
			include('includes/header.inc');
			prnMsg(_('There were no items with demand greater than supply'),'error');
			echo '<br /><a href="' . $RootPath . '/index.php?">' . _('Back to the menu') . '</a>';
			include('includes/footer.inc');
			exit;
	} else {
			$pdf->OutputD($_SESSION['DatabaseName'] . '_ReOrderLevel_' . date('Y-m-d') . '.pdf');
			$pdf->__destruct();
	}

} else { /*The option to print PDF was not hit so display form */

	$Title=_('Reorder Level Reporting');
	include('includes/header.inc');
	echo '<p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/inventory.png" title="' . _('Inventory') . '" alt="" />' . ' ' . _('Inventory Reorder Level Report') . '</p>';
	echo '<div class="page_help_text">' . _('Use this report to display the reorder levels for Inventory items in different categories.') . '</div><br />';

	echo '<br /><form action="' . htmlspecialchars($_SERVER['PHP_SELF'], ENT_QUOTES, 'UTF-8') . '" method="post">';
    echo '<div>';
	echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';
	$sql = "SELECT weberp_locations.loccode,
			locationname
		FROM weberp_locations INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locations.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1";
	$resultStkLocs = DB_query($sql);
	echo '<table class="selection">
			<tr>
				<td>' . _('From Stock Location') . ':</td>
				<td><select name="StockLocation"> ';
	if (!isset($_POST['StockLocation'])){
		$_POST['StockLocation']='All';
	}
	if ($_POST['StockLocation']=='All'){
		echo '<option selected="selected" value="All">' . _('All') . '</option>';
	} else {
		echo '<option value="All">' . _('All') . '</option>';
	}
	while ($myrow=DB_fetch_array($resultStkLocs)){
		if ($myrow['loccode'] == $_POST['StockLocation']){
			 echo '<option selected="selected" value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
		} else {
			 echo '<option value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
		}
	}
	echo '</select></td></tr>';

	$SQL="SELECT categoryid, categorydescription FROM weberp_stockcategory WHERE stocktype<>'A' ORDER BY categorydescription";
	$result1 = DB_query($SQL);
	if (DB_num_rows($result1)==0){
		echo '</td></tr>
			</table>
			<br />';
		prnMsg(_('There are no stock categories currently defined please use the link below to set them up'),'warn');
		echo '<br /><a href="' . $RootPath . '/StockCategories.php">' . _('Define Stock Categories') . '</a>';
		include ('includes/footer.inc');
		exit;
	}

	echo '<tr>
			<td>' . _('In Stock Category') . ':</td>
			<td><select name="StockCat">';
	if (!isset($_POST['StockCat'])){
		$_POST['StockCat']='All';
	}
	if ($_POST['StockCat']=='All'){
		echo '<option selected="selected" value="All">' . _('All') . '</option>';
	} else {
		echo '<option value="All">' . _('All') . '</option>';
	}
	while ($myrow1 = DB_fetch_array($result1)) {
		if ($myrow1['categoryid']==$_POST['StockCat']){
			echo '<option selected="selected" value="' . $myrow1['categoryid'] . '">' . $myrow1['categorydescription'] . '</option>';
		} else {
			echo '<option value="' . $myrow1['categoryid'] . '">' . $myrow1['categorydescription'] . '</option>';
		}
	}
	echo '</select></td></tr>';
	echo '</table>
			<br />
			<div class="centre">
				<input type="submit" name="PrintPDF" value="' . _('Print PDF') . '" />
			</div>';
    echo '</div>
          </form>';
	include('includes/footer.inc');

} /*end of else not PrintPDF */

function PrintHeader(&$pdf,&$YPos,&$PageNumber,$Page_Height,$Top_Margin,$Left_Margin,
					 $Page_Width,$Right_Margin,$CategoryDescription) {

	/*PDF page header for Reorder Level report */
	if ($PageNumber>1){
		$pdf->newPage();
	}
	$line_height=12;
	$FontSize=9;
	$YPos= $Page_Height-$Top_Margin;
	$pdf->RoundRectangle($Left_Margin-5, $YPos+5+10, 310, ($line_height*3)+10+10, 10, 10);// Function RoundRectangle from includes/class.pdf.php
	$pdf->addTextWrap($Left_Margin,$YPos,290,$FontSize,$_SESSION['CompanyRecord']['coyname']);

	$YPos -=$line_height;

	$pdf->addTextWrap($Left_Margin,$YPos,150,$FontSize,_('Reorder Level Report'));
	$pdf->addTextWrap($Page_Width-$Right_Margin-150,$YPos,160,$FontSize,_('Printed') . ': ' .
		 Date($_SESSION['DefaultDateFormat']) . '   ' . _('Page') . ' ' . $PageNumber,'left');
	$YPos -= $line_height;
	$pdf->addTextWrap($Left_Margin,$YPos,50,$FontSize,_('Category'));
	$pdf->addTextWrap(95,$YPos,50,$FontSize,$_POST['StockCat']);
	$pdf->addTextWrap(160,$YPos,150,$FontSize,$CategoryDescription,'left');
	$YPos -= $line_height;
	$pdf->addTextWrap($Left_Margin,$YPos,50,$FontSize,_('Location'));
	$pdf->addTextWrap(95,$YPos,50,$FontSize,$_POST['StockLocation']);
	$YPos -=(2*$line_height);

	/*set up the headings */
	$Xpos = $Left_Margin+1;

	$pdf->addTextWrap(50,$YPos,100,$FontSize,_('Part Number'), 'left');
	$pdf->addTextWrap(150,$YPos,150,$FontSize,_('Description'), 'left');
	$pdf->addTextWrap(410,$YPos,60,$FontSize,_('Location'), 'left');
	$pdf->addTextWrap(470,$YPos,50,$FontSize,_('Quantity'), 'right');
	$pdf->addTextWrap(520,$YPos,50,$FontSize,_('Reorder'), 'right');
	$pdf->addTextWrap(570,$YPos,50,$FontSize,_('On Order'), 'right');
	$pdf->addTextWrap(620,$YPos,50,$FontSize,_('Needed'), 'right');
	$YPos -= $line_height;
	$pdf->addTextWrap(515,$YPos,50,$FontSize,_('Level'), 'right');


	$FontSize=8;
//	$YPos =$YPos - (2*$line_height);
	$PageNumber++;
} // End of PrintHeader() function
?>
