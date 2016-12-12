<?php
/* $Id: Z_Upgrade_3.04-3.05.php 6941 2014-10-26 23:18:08Z daintree $*/

//$PageSecurity = 15;
include('includes/session.inc');
$Title = _('Upgrade webERP 3.04 - 3.05');
include('includes/header.inc');


prnMsg(_('This script will run perform any modifications to the database required to allow the additional functionality in version 3.05 scripts'),'info');

echo "<p><form method='post' action='" . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '?' . SID . "'>";
	echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';
echo '<input type="submit" name="DoUpgrade" value="' . _('Perform Upgrade') . '" />';
echo '</form>';

if ($_POST['DoUpgrade'] == _('Perform Upgrade')){

	if ($DBType=='postgres'){

		$SQLScriptFile = file('./sql/pg/upgrade3.04-3.05.psql');

	} elseif ($DBType ='mysql') { //its a mysql db

		$SQLScriptFile = file('./sql/mysql/upgrade3.04-3.05.sql');
	}

	$ScriptFileEntries = sizeof($SQLScriptFile);
	$ErrMsg = _('The script to upgrade the database failed because');
	$SQL ='';
	$InAFunction = false;

	for ($i=0; $i<=$ScriptFileEntries; $i++) {

		$SQLScriptFile[$i] = trim($SQLScriptFile[$i]);

		if (mb_substr($SQLScriptFile[$i], 0, 2) != '--'
			AND mb_substr($SQLScriptFile[$i], 0, 3) != 'USE'
			AND mb_strstr($SQLScriptFile[$i],'/*')==FALSE
			AND mb_strlen($SQLScriptFile[$i])>1){

			$SQL .= ' ' . $SQLScriptFile[$i];

			//check if this line kicks off a function definition - pg chokes otherwise
			if (mb_substr($SQLScriptFile[$i],0,15) == 'CREATE FUNCTION'){
				$InAFunction = true;
			}
			//check if this line completes a function definition - pg chokes otherwise
			if (mb_substr($SQLScriptFile[$i],0,8) == 'LANGUAGE'){
				$InAFunction = false;
			}
			if (mb_strpos($SQLScriptFile[$i],';')>0 AND ! $InAFunction){
				$SQL = mb_substr($SQL,0,mb_strlen($SQL)-1);
				$result = DB_query($SQL, $ErrMsg);
				$SQL='';
			}

		} //end if its a valid sql line not a comment
	} //end of for loop around the lines of the sql script


	/*Now run the data conversions required. */

	prnMsg(_('Upgrade script to put cost information against GRN records from weberp_purchorderdetails records .... please wait'),'info');

	$TestAlreadyDoneResult = DB_query('SELECT * FROM weberp_grns WHERE stdcostunit<>0');
	if (DB_num_rows($TestAlreadyDoneResult)>0){
		prnMsg(_('The upgrade script appears to have been run already successfully - there is no need to re-run it'),'info');
		include('includes/footer.inc');
		exit;
	}


	$UpdateGRNCosts = DB_query('UPDATE weberp_grns INNER JOIN weberp_purchorderdetails ON weberp_grns.podetailitem=weberp_purchorderdetails.podetailitem SET weberp_grns.stdcostunit = weberp_purchorderdetails.stdcostunit');


	prnMsg(_('The GRN records have been updated with cost information from weberp_purchorderdetails successfully'),'success');
} /*Dont do upgrade */

include('includes/footer.inc');
?>
