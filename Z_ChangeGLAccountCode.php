<?php
/* $Id: Z_ChangeGLAccountCode.php 6946 2014-10-27 07:30:11Z daintree $*/
/* Utility to change a GL account code in all webERP. */

include ('includes/session.inc');
$Title = _('UTILITY PAGE Change A GL Account Code');// Screen identificator.
$ViewTopic = 'SpecialUtilities';// Filename's id in ManualContents.php's TOC.
$BookMark = 'Z_ChangeGLAccountCode';// Anchor's id in the manual's html document.
include('includes/header.inc');
echo '<p class="page_title_text"><img alt="" src="', $RootPath, '/css/', $Theme,
	'/images/gl.png" title="',// Icon image.
	_('Change A GL Account Code'), '" /> ',// Icon title.
	_('Change A GL Account Code'), '</p>';// Page title.

include('includes/SQL_CommonFunctions.inc');

if(isset($_POST['ProcessGLAccountCode'])) {

	$InputError =0;

	$_POST['NewAccountCode'] = mb_strtoupper($_POST['NewAccountCode']);

/*First check the code exists */
	$result=DB_query("SELECT accountcode FROM weberp_chartmaster WHERE accountcode='" . $_POST['OldAccountCode'] . "'");
	if(DB_num_rows($result)==0) {
		prnMsg(_('The GL account code') . ': ' . $_POST['OldAccountCode'] . ' ' . _('does not currently exist as a GL account code in the system'),'error');
		$InputError =1;
	}

	if(ContainsIllegalCharacters($_POST['NewAccountCode'])) {
		prnMsg(_('The new GL account code to change the old code to contains illegal characters - no changes will be made'),'error');
		$InputError =1;
	}

	if($_POST['NewAccountCode']=='') {
		prnMsg(_('The new GL account code to change the old code to must be entered as well'),'error');
		$InputError =1;
	}


/*Now check that the new code doesn't already exist */
	$result=DB_query("SELECT accountcode FROM weberp_chartmaster WHERE accountcode='" . $_POST['NewAccountCode'] . "'");
	if(DB_num_rows($result)!=0) {
		echo '<br /><br />';
		prnMsg(_('The replacement GL account code') . ': ' . $_POST['NewAccountCode'] . ' ' . _('already exists as a GL account code in the system') . ' - ' . _('a unique GL account code must be entered for the new code'),'error');
		$InputError =1;
	}


	if($InputError ==0) {// no input errors
		$result = DB_Txn_Begin();
		echo '<br />' . _('Adding the new weberp_chartmaster record');
		$sql = "INSERT INTO weberp_chartmaster (accountcode,
										accountname,
										group_)
				SELECT '" . $_POST['NewAccountCode'] . "',
					accountname,
					group_
				FROM weberp_chartmaster
				WHERE accountcode='" . $_POST['OldAccountCode'] . "'";

		$DbgMsg = _('The SQL statement that failed was');
		$ErrMsg =_('The SQL to insert the new chartmaster record failed');
		$result = DB_query($sql,$ErrMsg,$DbgMsg,true);
		echo ' ... ' . _('completed');

		DB_IgnoreForeignKeys();

		ChangeFieldInTable("weberp_bankaccounts", "accountcode", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_bankaccountusers", "accountcode", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_banktrans", "bankact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_chartdetails", "accountcode", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_cogsglpostings", "glcode", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_companies", "debtorsact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_companies", "pytdiscountact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_companies", "creditorsact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_companies", "payrollact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_companies", "grnact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_companies", "exchangediffact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_companies", "purchasesexchangediffact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_companies", "retainedearnings", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_companies", "freightact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_fixedassetcategories", "costact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_fixedassetcategories", "depnact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_fixedassetcategories", "disposalact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_fixedassetcategories", "accumdepnact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_glaccountusers", "accountcode", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		
		ChangeFieldInTable("weberp_gltrans", "account", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_lastcostrollup", "stockact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_lastcostrollup", "adjglact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_locations", "glaccountcode", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);// Location's ledger account.

		ChangeFieldInTable("weberp_pcexpenses", "glaccount", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_pctabs", "glaccountassignment", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_pctabs", "glaccountpcash", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_purchorderdetails", "glcode", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_salesglpostings", "discountglcode", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_salesglpostings", "salesglcode", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_stockcategory", "stockact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_stockcategory", "adjglact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_stockcategory", "issueglact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_stockcategory", "purchpricevaract", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_stockcategory", "materialuseagevarac", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_stockcategory", "wipact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_taxauthorities", "taxglcode", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_taxauthorities", "purchtaxglaccount", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);
		ChangeFieldInTable("weberp_taxauthorities", "bankacctype", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		ChangeFieldInTable("weberp_workcentres", "overheadrecoveryact", $_POST['OldAccountCode'], $_POST['NewAccountCode'], $db);

		DB_ReinstateForeignKeys();

		$result = DB_Txn_Commit();

		echo '<br />' . _('Deleting the old weberp_chartmaster record');
		$sql = "DELETE FROM weberp_chartmaster WHERE accountcode='" . $_POST['OldAccountCode'] . "'";
		$ErrMsg = _('The SQL to delete the old chartmaster record failed');
		$result = DB_query($sql,$ErrMsg,$DbgMsg,true);
		echo ' ... ' . _('completed');

		echo '<p>' . _('GL account Code') . ': ' . $_POST['OldAccountCode'] . ' ' . _('was successfully changed to') . ' : ' . $_POST['NewAccountCode'];
	}//only do the stuff above if  $InputError==0

}

echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') .  '" method="post">';
echo '<div class="centre">';
echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';

echo '<br />
    <table>
	<tr>
		<td>' . _('Existing GL Account Code') . ':</td>
		<td><input type="text" name="OldAccountCode" size="20" maxlength="20" /></td>
	</tr>
	<tr>
		<td>' . _('New GL Account Code') . ':</td>
		<td><input type="text" name="NewAccountCode" size="20" maxlength="20" /></td>
	</tr>
	</table>

		<input type="submit" name="ProcessGLAccountCode" value="' . _('Process') . '" />
	</div>
	</form>';

include('includes/footer.inc');
?>
