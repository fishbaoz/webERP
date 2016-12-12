<?php
/*	$Id: Z_ChangeStockCode.php 7494 2016-04-25 09:53:53Z daintree $*/
/*	This script is an utility to change an inventory item code. */
/*	It uses function ChangeFieldInTable($TableName, $FieldName, $OldValue, 
	$NewValue, $db) from .../includes/MiscFunctions.php.*/

include ('includes/session.inc');
$Title = _('UTILITY PAGE Change A Stock Code');// Screen identificator.
$ViewTopic = 'SpecialUtilities'; // Filename in ManualContents.php's TOC.
$BookMark = 'Z_ChangeStockCode'; // Anchor's id in the manual's html document.
include('includes/header.inc');
echo '<p class="page_title_text"><img alt="" src="'.$RootPath.'/css/'.$Theme.
	'/images/inventory.png" title="' . 
	_('Change An Inventory Item Code') . '" /> ' .// Icon title.
	_('Change An Inventory Item Code') . '</p>';// Page title.

include('includes/SQL_CommonFunctions.inc');

if (isset($_POST['ProcessStockChange'])){

	$InputError =0;

	$_POST['NewStockID'] = mb_strtoupper($_POST['NewStockID']);

/*First check the stock code exists */
	$result=DB_query("SELECT stockid FROM weberp_stockmaster WHERE stockid='" . $_POST['OldStockID'] . "'");
	if (DB_num_rows($result)==0){
		prnMsg(_('The stock code') . ': ' . $_POST['OldStockID'] . ' ' . _('does not currently exist as a stock code in the system'),'error');
		$InputError =1;
	}

	if (ContainsIllegalCharacters($_POST['NewStockID'])){
		prnMsg(_('The new stock code to change the old code to contains illegal characters - no changes will be made'),'error');
		$InputError =1;
	}

	if ($_POST['NewStockID']==''){
		prnMsg(_('The new stock code to change the old code to must be entered as well'),'error');
		$InputError =1;
	}


/*Now check that the new code doesn't already exist */
	$result=DB_query("SELECT stockid FROM weberp_stockmaster WHERE stockid='" . $_POST['NewStockID'] . "'");
	if (DB_num_rows($result)!=0){
		echo '<br /><br />';
		prnMsg(_('The replacement stock code') . ': ' . $_POST['NewStockID'] . ' ' . _('already exists as a stock code in the system') . ' - ' . _('a unique stock code must be entered for the new code'),'error');
		$InputError =1;
	}


	if ($InputError ==0){ // no input errors

		DB_IgnoreForeignKeys();
		$result = DB_Txn_Begin();
		echo '<br />' . _('Adding the new stock master record');
		$sql = "INSERT INTO weberp_stockmaster (stockid,
										categoryid,
										description,
										longdescription,
										units,
										mbflag,
										actualcost,
										lastcost,
										materialcost,
										labourcost,
										overheadcost,
										lowestlevel,
										discontinued,
										controlled,
										eoq,
										volume,
										grossweight,
										barcode,
										discountcategory,
										taxcatid,
										decimalplaces,
										shrinkfactor,
										pansize,
										netweight,
										perishable,
										nextserialno)
				SELECT '" . $_POST['NewStockID'] . "',
					categoryid,
					description,
					longdescription,
					units,
					mbflag,
					actualcost,
					lastcost,
					materialcost,
					labourcost,
					overheadcost,
					lowestlevel,
					discontinued,
					controlled,
					eoq,
					volume,
					grossweight,
					barcode,
					discountcategory,
					taxcatid,
					decimalplaces,
					shrinkfactor,
					pansize,
					netweight,
					perishable,
					nextserialno
				FROM weberp_stockmaster
				WHERE stockid='" . $_POST['OldStockID'] . "'";

		$DbgMsg = _('The SQL statement that failed was');
		$ErrMsg =_('The SQL to insert the new stock master record failed');
		$result = DB_query($sql,$ErrMsg,$DbgMsg,true);
		echo ' ... ' . _('completed');

		ChangeFieldInTable("weberp_locstock", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_stockmoves", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_loctransfers", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_mrpdemands", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);

		//check if MRP tables exist before assuming
		$sql = "SELECT * FROM weberp_mrpparameters";
		$result = DB_query($sql, '', '', false, false);
		if (DB_error_no() == 0) {
			$result = DB_query("SELECT COUNT(*) FROM weberp_mrpplannedorders",'','',false,false);
			if (DB_error_no()==0) {
				ChangeFieldInTable("weberp_mrpplannedorders", "part", $_POST['OldStockID'], $_POST['NewStockID'], $db);
			}
	
			$result = DB_query("SELECT * FROM weberp_mrprequirements" ,'','',false,false);
			if (DB_error_no()==0){
				ChangeFieldInTable("weberp_mrprequirements", "part", $_POST['OldStockID'], $_POST['NewStockID'], $db);
			}
			
			$result = DB_query("SELECT * FROM weberp_mrpsupplies" ,'','',false,false);
			if (DB_error_no()==0){
				ChangeFieldInTable("weberp_mrpsupplies", "part", $_POST['OldStockID'], $_POST['NewStockID'], $db);
			}
		}
		ChangeFieldInTable("weberp_salesanalysis", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_orderdeliverydifferenceslog", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_prices", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_salesorderdetails", "stkcode", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_purchorderdetails", "itemcode", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_purchdata", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_shipmentcharges", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_stockcheckfreeze", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_stockcounts", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_grns", "itemcode", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_contractbom", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_bom", "component", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		
		DB_IgnoreForeignKeys($db);

		ChangeFieldInTable("weberp_bom", "parent", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_stockrequestitems", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_stockdescriptiontranslations", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);// Updates the translated item titles (StockTitles)
		ChangeFieldInTable("weberp_custitem", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_pricematrix", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
/*		ChangeFieldInTable("weberp_Stockdescriptions", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);// Updates the translated item descriptions (StockDescriptions)*/

		echo '<br />' . _('Changing any image files');
		$SupportedImgExt = array('png','jpg','jpeg');
		foreach ($SupportedImgExt as $ext) {
			$file = $_SESSION['part_pics_dir'] . '/' . $_POST['OldStockID'] . '.' . $ext;
			if (file_exists ($file) ) {
				if (rename($file,
					$_SESSION['part_pics_dir'] . '/' .$_POST['NewStockID'] . '.' . $ext)) {
					echo ' ... ' . _('completed');
				} else {
					echo ' ... ' . _('failed');
				}
			} else {
				echo ' .... ' . _('no image to rename');
			}
		}

		ChangeFieldInTable("weberp_stockitemproperties", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_worequirements", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_worequirements", "parentstockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_woitems", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_salescatprod", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_stockserialitems", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_stockserialmoves", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_offers", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_tenderitems", "stockid", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_prodspecs", "keyval", $_POST['OldStockID'], $_POST['NewStockID'], $db);
		ChangeFieldInTable("weberp_qasamples", "prodspeckey", $_POST['OldStockID'], $_POST['NewStockID'], $db);

		DB_ReinstateForeignKeys();

		$result = DB_Txn_Commit();

		echo '<br />' . _('Deleting the old stock master record');
		$sql = "DELETE FROM weberp_stockmaster WHERE stockid='" . $_POST['OldStockID'] . "'";
		$ErrMsg = _('The SQL to delete the old stock master record failed');
		$result = DB_query($sql,$ErrMsg,$DbgMsg,true);
		echo ' ... ' . _('completed');
		echo '<p>' . _('Stock Code') . ': ' . $_POST['OldStockID'] . ' ' . _('was successfully changed to') . ' : ' . $_POST['NewStockID'];

		// If the current SelectedStockItem is the same as the OldStockID, it updates to the NewStockID:
		if ($_SESSION['SelectedStockItem'] == $_POST['OldStockID']) {
			$_SESSION['SelectedStockItem'] = $_POST['NewStockID'];
		}
		
	} //only do the stuff above if  $InputError==0
}

echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') .  '" method="post">';
echo '<div class="centre">';
echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';

echo '<br />
    <table>
	<tr>
		<td>' . _('Existing Inventory Code') . ':</td>
		<td><input type="text" name="OldStockID" size="20" maxlength="20" /></td>
	</tr>
	<tr>
		<td>' . _('New Inventory Code') . ':</td>
		<td><input type="text" name="NewStockID" size="20" maxlength="20" /></td>
	</tr>
	</table>

		<input type="submit" name="ProcessStockChange" value="' . _('Process') . '" />
	</div>
	</form>';

include('includes/footer.inc');

?>
