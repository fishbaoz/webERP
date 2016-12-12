<?php

/* $Id: SalesGLPostings.php 7035 2014-12-20 06:55:12Z exsonqu $*/

include('includes/session.inc');
$Title = _('Sales GL Postings Set Up');
$ViewTopic= 'CreatingNewSystem';
$BookMark = 'SalesGLPostings';
include('includes/header.inc');

if (isset($_GET['SelectedSalesPostingID'])){
	$SelectedSalesPostingID =$_GET['SelectedSalesPostingID'];
} elseif (isset($_POST['SelectedSalesPostingID'])){
	$SelectedSalesPostingID =$_POST['SelectedSalesPostingID'];
}

$InputError=false;

echo '<p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/customer.png" title="' . _('Search') . '" alt="" />' . ' ' . $Title . '</p>';

if (isset($_POST['submit'])) {

	/* actions to take once the user has clicked the submit button
	ie the page has called itself with some user input */

	if (isset($SelectedSalesPostingID)) {

		/*SelectedSalesPostingID could also exist if submit had not been clicked this		code would not run in this case cos submit is false of course	see the delete code below*/

		$sql = "UPDATE weberp_salesglpostings SET salesglcode = '" . $_POST['SalesGLCode'] . "',
										discountglcode = '" . $_POST['DiscountGLCode'] . "',
										area = '" . $_POST['Area'] . "',
										stkcat = '" . $_POST['StkCat'] . "',
										salestype = '" . $_POST['SalesType'] . "'
				WHERE weberp_salesglpostings.id = '".$SelectedSalesPostingID."'";
		$msg = _('The sales GL posting record has been updated');
	} else {

	/*Selected Sales GL Posting is null cos no item selected on first time round so must be	adding a record must be submitting new entries in the new SalesGLPosting form */

		/* Verify if item doesn't exists to insert it, otherwise just refreshes the page. */
		$sql = "SELECT count(*) FROM weberp_salesglpostings
				WHERE area='" . $_POST['Area'] . "'
				AND stkcat='" . $_POST['StkCat'] . "'
				AND salestype='" . $_POST['SalesType'] . "'";

		$result = DB_query($sql);
		$myrow = DB_fetch_row($result);
		if ($myrow[0] == 0) {
			$sql = "INSERT INTO weberp_salesglpostings (
						salesglcode,
						discountglcode,
						area,
						stkcat,
						salestype)
					VALUES (
						'" . $_POST['SalesGLCode'] . "',
						'" . $_POST['DiscountGLCode'] . "',
						'" . $_POST['Area'] . "',
						'" . $_POST['StkCat'] . "',
						'" . $_POST['SalesType'] . "'
						)";
			$msg = _('The new sales GL posting record has been inserted');
		} else {
			prnMsg (_('A sales gl posting account already exists for the selected area, stock category, salestype'),'warn');
			$InputError = true;
		}
	}
	//run the SQL from either of the above possibilites

	$result = DB_query($sql);

	if ($InputError==false){
		prnMsg($msg,'success');
	}
	unset ($SelectedSalesPostingID);
	unset($_POST['SalesGLCode']);
	unset($_POST['DiscountGLCode']);
	unset($_POST['Area']);
	unset($_POST['StkCat']);
	unset($_POST['SalesType']);

} elseif (isset($_GET['delete'])) {
//the link to delete a selected record was clicked instead of the submit button

	$sql="DELETE FROM weberp_salesglpostings WHERE id='".$SelectedSalesPostingID."'";

	$result = DB_query($sql);

	prnMsg( _('Sales posting record has been deleted'),'success');
}

if (!isset($SelectedSalesPostingID)) {

	$ShowLivePostingRecords = true;

	$SQL = "SELECT weberp_salesglpostings.id,
				weberp_salesglpostings.area,
				weberp_salesglpostings.stkcat,
				weberp_salesglpostings.salestype,
				weberp_salesglpostings.salesglcode,
				weberp_salesglpostings.discountglcode
				FROM weberp_salesglpostings LEFT JOIN weberp_chartmaster
					ON weberp_salesglpostings.salesglcode = weberp_chartmaster.accountcode
				WHERE weberp_chartmaster.accountcode IS NULL
				ORDER BY weberp_salesglpostings.area,
					weberp_salesglpostings.stkcat,
					weberp_salesglpostings.salestype";

	$result = DB_query($SQL);
	if (DB_num_rows($result)>0){
		$ShowLivePostingRecords = false;
		prnMsg (_('The following posting records that do not have valid general ledger code specified - these records must be amended.'),'error');
		echo '<table class="selection">';
		echo '<tr><th>' . _('Area') . '</th>
				<th>' . _('Stock Category') . '</th>
				<th>' . _('Sales Type') . '</th>
				<th>' . _('Sales Account') . '</th>
				<th>' . _('Discount Account') . '</th>
			</tr>';
		$k=0; //row colour counter

		while ($myrow = DB_fetch_row($result)) {
			if ($k==1){
				echo '<tr class="EvenTableRows">';
				$k=0;
			} else {
				echo '<tr class="OddTableRows">';
				$k=1;
			}

			printf('<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td><a href="%sSelectedSalesPostingID=%s">' . _('Edit') . '</a></td>
				<td><a href="%sSelectedSalesPostingID=%s&amp;delete=yes" onclick="return confirm(\'' . _('Are you sure you wish to delete this sales GL posting record?') . '\');">' .  _('Delete') . '</a></td></tr>',
				$myrow[1],
				$myrow[2],
				$myrow[3],
				htmlspecialchars($myrow[4],ENT_QUOTES,'UTF-8'),
				$myrow[5],
				htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '?',
				$myrow[0],
				htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8'). '?',
				$myrow[0]);
		}
	}

	$SQL = "SELECT weberp_salesglpostings.id,
			weberp_salesglpostings.area,
			weberp_salesglpostings.stkcat,
			weberp_salesglpostings.salestype
			FROM weberp_salesglpostings";

	$result = DB_query($SQL);

	if (DB_num_rows($result)==0){
		/* there is no default set up so need to check that account 1 is not already used */
		/* First Check if we have at least a group_ caled Sales */
		$SQL = "SELECT groupname FROM weberp_accountgroups WHERE groupname = 'Sales'";
		$result = DB_query($SQL);
		if (DB_num_rows($result)==0){
			/* The required group does not seem to exist so we create it */
			$SQL = "INSERT INTO weberp_accountgroups (
					groupname,
					sectioninaccounts,
					pandl,
					sequenceintb,
					parentgroupname
				) VALUES (
					'Sales',
					1,
					1,
					10,
					' ')";

			$result = DB_query($SQL);
		}
		$SQL = "SELECT accountcode FROM weberp_chartmaster WHERE accountcode ='1'";
		$result = DB_query($SQL);
		if (DB_num_rows($result)==0){
		/* account number 1 is not used, so insert a new account */
			$SQL = "INSERT INTO weberp_chartmaster (
						accountcode,
						accountname,
						group_)
					VALUES (
						1,
						'Default Sales/Discounts',
						'Sales'
						)";
			$result = DB_query($SQL);
		}

		$SQL = "INSERT INTO weberp_salesglpostings (
						area,
						stkcat,
						salestype,
						salesglcode,
						discountglcode)
				VALUES ('AN',
					'ANY',
					'AN',
					1,
					1)";
		$result = DB_query($SQL);

	}
	if ($ShowLivePostingRecords){

		$SQL = "SELECT weberp_salesglpostings.id,
				weberp_salesglpostings.area,
				weberp_salesglpostings.stkcat,
				weberp_salesglpostings.salestype,
				chart1.accountname,
				chart2.accountname
			FROM weberp_salesglpostings,
				weberp_chartmaster as chart1,
				weberp_chartmaster as chart2
			WHERE weberp_salesglpostings.salesglcode = chart1.accountcode
			AND weberp_salesglpostings.discountglcode = chart2.accountcode
			ORDER BY weberp_salesglpostings.area,
					weberp_salesglpostings.stkcat,
					weberp_salesglpostings.salestype";

		$result = DB_query($SQL);

		echo '<table class="selection">
			<tr>
			<th>' . _('Area') . '</th>
			<th>' . _('Stock Category') . '</th>
			<th>' . _('Sales Type') . '</th>
			<th>' . _('Sales Account') . '</th>
			<th>' . _('Discount Account') . '</th>
			</tr>';

		$k=0; //row colour counter

		while ($myrow = DB_fetch_row($result)) {
			if ($k==1){
				echo '<tr class="EvenTableRows">';
				$k=0;
			} else {
				echo '<tr class="OddTableRows">';
				$k=1;
			}

			printf('<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td>%s</td>
				<td><a href="%sSelectedSalesPostingID=%s">' . _('Edit') . '</a></td>
				<td><a href="%sSelectedSalesPostingID=%s&amp;delete=yes" onclick="return confirm(\'' . _('Are you sure you wish to delete this sales GL posting record?') . '\');">' .  _('Delete') . '</a></td></tr>',
				$myrow[1],
				$myrow[2],
				$myrow[3],
                htmlspecialchars($myrow[4],ENT_QUOTES,'UTF-8'),
				$myrow[5],
				htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '?',
				$myrow[0],
				htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8'). '?',
				$myrow[0]);
		}
		//END WHILE LIST LOOP
		echo '</table>';
	}
}

//end of ifs and buts!

if (isset($SelectedSalesPostingID)) {
	echo '<div class="centre"><a href="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '">' . _('Show All Sales Posting Codes Defined') . '</a></div>';
}


if (!isset($_GET['delete'])) {

	echo '<form method="post" action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') .  '">';
    echo '<div>';
	echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';

	if (isset($SelectedSalesPostingID)) {
		//editing an existing sales posting record

		$sql = "SELECT weberp_salesglpostings.stkcat,
				weberp_salesglpostings.salesglcode,
				weberp_salesglpostings.discountglcode,
				weberp_salesglpostings.area,
				weberp_salesglpostings.salestype
			FROM weberp_salesglpostings
			WHERE weberp_salesglpostings.id='".$SelectedSalesPostingID."'";

		$result = DB_query($sql);
		$myrow = DB_fetch_array($result);

		$_POST['SalesGLCode']= $myrow['salesglcode'];
		$_POST['DiscountGLCode']= $myrow['discountglcode'];
		$_POST['Area']=$myrow['area'];
		$_POST['StkCat']=$myrow['stkcat'];
		$_POST['SalesType']=$myrow['salestype'];
		DB_free_result($result);

		echo '<input type="hidden" name="SelectedSalesPostingID" value="' . $SelectedSalesPostingID . '" />';

	}
/*end of if $SelectedSalesPostingID only do the else when a new record is being entered */

	$SQL = "SELECT areacode,
			areadescription FROM weberp_areas";
	$result = DB_query($SQL);

	echo '<br /><table class="selection">
		<tr>
		<td>' . _('Area') . ':</td>
		<td><select name="Area">
			<option value="AN">' . _('Any Other') . '</option>';

	while ($myrow = DB_fetch_array($result)) {
		if (isset($_POST['Area']) and $myrow['areacode']==$_POST['Area']) {
			echo '<option selected="selected" value="';
		} else {
			echo '<option value="';
		}
		echo $myrow['areacode'] . '">' .  $myrow['areadescription'] . '</option>';

	} //end while loop

	DB_free_result($result);

	$SQL = "SELECT categoryid, categorydescription FROM weberp_stockcategory";
	$result = DB_query($SQL);

	echo '</select></td></tr>';


	echo '<tr><td>' . _('Stock Category') . ':</td>
		<td><select name="StkCat">
			<option value="ANY">' . _('Any Other') . '</option>';

	while ($myrow = DB_fetch_array($result)) {

		if (isset($_POST['StkCat']) and $myrow['categoryid']==$_POST['StkCat']) {
			echo '<option selected="selected" value="';
		} else {
			echo '<option value="';
		}
		echo $myrow['categoryid'] . '">' . $myrow['categorydescription'] . '</option>';

	} //end while loop

	echo '</select></td></tr>';


	DB_free_result($result);

	$SQL = "SELECT typeabbrev,
					sales_type
			FROM weberp_salestypes";
	$result = DB_query($SQL);


	echo '<tr><td>' . _('Sales Type') . ' / ' . _('Price List') . ':</td>
		<td><select name="SalesType">';
	echo '<option value="AN">' . _('Any Other') . '</option>';

	while ($myrow = DB_fetch_array($result)) {
		if (isset($_POST['SalesType']) and $myrow['typeabbrev']==$_POST['SalesType']) {
			echo '<option selected="selected" value="';
		} else {
			echo '<option value="';
		}
		echo $myrow['typeabbrev'] . '">' . $myrow['sales_type']  . '</option>';

	} //end while loop

	echo '</select></td></tr>';


	echo '<tr><td>' . _('Post Sales to GL Account') . ':</td>
			<td><select name="SalesGLCode">';

	DB_free_result($result);
	$SQL = "SELECT weberp_chartmaster.accountcode,
			weberp_chartmaster.accountname
		FROM weberp_chartmaster,
			weberp_accountgroups
		WHERE weberp_chartmaster.group_=weberp_accountgroups.groupname
		AND weberp_accountgroups.pandl='1'
		ORDER BY weberp_accountgroups.sequenceintb,
			weberp_chartmaster.accountcode";

	$result = DB_query($SQL);

	while ($myrow = DB_fetch_array($result)) {
		if (isset($_POST['SalesGLCode']) and $myrow['accountcode']==$_POST['SalesGLCode']) {
			echo '<option selected="selected" value="';
		} else {
			echo '<option value="';
		}
		echo $myrow['accountcode'] . '">' . $myrow['accountcode'] . ' - ' . htmlspecialchars($myrow['accountname'], ENT_QUOTES, 'UTF-8', false)  . '</option>';

	} //end while loop

	DB_data_seek($result,0);

	echo '</select></td></tr>
		<tr><td>' . _('Post Discount to GL Account') . ':</td>
			<td><select name="DiscountGLCode">';

	while ($myrow = DB_fetch_array($result)) {
		if (isset($_POST['DiscountGLCode']) and $myrow['accountcode']==$_POST['DiscountGLCode']) {
			echo '<option selected="selected" value="';
		} else {
			echo '<option value="';
		}
		echo $myrow['accountcode'] . '">' . $myrow['accountcode'] . ' - ' . htmlspecialchars($myrow['accountname'], ENT_QUOTES, 'UTF-8', false)  . '</option>';

	} //end while loop

	echo'</select></td>
		</tr>
		</table>';

	echo '<br /><div class="centre"><input type="submit" name="submit" value="' . _('Enter Information') . '" /></div>';

	echo '</div>
          </form>';

} //end if record deleted no point displaying form to add record


include('includes/footer.inc');
?>
