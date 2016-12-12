<?php
/* $Id: Z_CreateChartDetails.php 6945 2014-10-27 07:20:48Z daintree $*/

include ('includes/session.inc');
$Title = _('Create Chart Details Records');
include ('includes/header.inc');

/*Script to insert ChartDetails records where one should already exist
only necessary where manual entry of weberp_chartdetails has stuffed the system */

$FirstPeriodResult = DB_query("SELECT MIN(periodno) FROM weberp_periods");
$FirstPeriodRow = DB_fetch_row($FirstPeriodResult);

$LastPeriodResult = DB_query("SELECT MAX(periodno) FROM weberp_periods");
$LastPeriodRow = DB_fetch_row($LastPeriodResult);

$CreateFrom = $FirstPeriodRow[0];
$CreateTo = $LastPeriodRow[0];;


/*First off see if there are any weberp_chartdetails missing create recordset of */

$sql = "SELECT weberp_chartmaster.accountcode, MIN(weberp_periods.periodno) AS startperiod
		FROM weberp_chartmaster CROSS JOIN weberp_periods
			LEFT JOIN weberp_chartdetails ON weberp_chartmaster.accountcode = weberp_chartdetails.accountcode
				AND weberp_periods.periodno = weberp_chartdetails.period
		WHERE (weberp_periods.periodno BETWEEN '"  . $CreateFrom . "' AND '" . $CreateTo . "')
		AND weberp_chartdetails.accountcode IS NULL
		GROUP BY weberp_chartmaster.accountcode";

$ChartDetailsNotSetUpResult = DB_query($sql,_('Could not test to see that all chart detail records properly initiated'));

if(DB_num_rows($ChartDetailsNotSetUpResult)>0){

	/*Now insert the weberp_chartdetails records that do not already exist */
	$sql = "INSERT INTO weberp_chartdetails (accountcode, period)
			SELECT weberp_chartmaster.accountcode, weberp_periods.periodno
		FROM weberp_chartmaster CROSS JOIN weberp_periods
			LEFT JOIN weberp_chartdetails ON weberp_chartmaster.accountcode = weberp_chartdetails.accountcode
				AND weberp_periods.periodno = weberp_chartdetails.period
		WHERE (weberp_periods.periodno BETWEEN '"  . $CreateFrom . "' AND '" . $CreateTo . "')
		AND weberp_chartdetails.accountcode IS NULL";

	$ErrMsg = _('Inserting new chart details records required failed because');
	$InsChartDetailsRecords = DB_query($sql,$ErrMsg);


	While ($AccountRow = DB_fetch_array($ChartDetailsNotSetUpResult)){

		/*Now run through each of the new chartdetail records created for each account and update them with the B/Fwd and B/Fwd budget no updates would be required where there were previously no chart details set up ie FirstPeriodPostedTo > 0 */

		$sql = "SELECT actual,
				bfwd,
				budget,
				bfwdbudget,
				period
			FROM weberp_chartdetails
			WHERE period >='" . ($AccountRow['period']-1) . "'
			AND accountcode='" . $AccountRow['accountcode'] . "'
			ORDER BY period";
		$ChartDetails = DB_query($sql);

		DB_Txn_Begin();
		$BFwd = '';
		$BFwdBudget ='';
		$CFwd=0;
		$CFwdBudget=0;
		while ($myrow = DB_fetch_array($ChartDetails)){
			if ($BFwd =''){
				$BFwd = $myrow['bfwd'];
				$BFwdBudget = $myrow['bfwdbudget'];
			} else {
				$BFwd +=$myrow['actual'];
				$BFwdBudget += $myrow['budget'];
				$sql = "UPDATE weberp_chartdetails SET bfwd ='" . $BFwd . "',
							bfwdbudget ='" . $BFwdBudget . "'
					WHERE accountcode = '" . $AccountRow['accountcode'] . "'
					AND period ='" . ($myrow['period']+1) . "'";

				$UpdChartDetails = DB_query($sql, '', '', '', false);
			}
		}

		DB_Txn_Commit();

		DB_free_result($ChartDetailsCFwd);
	}

	prnMsg(_('Chart Details Created successfully'),'success');

} else {

	prnMsg(_('No additional chart details were required to be added'),'success');
}

include('includes/footer.inc');
?>