<?php

/* $Id: Z_ReApplyCostToSA.php 6941 2014-10-26 23:18:08Z daintree $*/

include('includes/session.inc');
$Title=_('Apply Current Cost to Sales Analysis');
include('includes/header.inc');

$Period = 42;

echo "<form method='post' action='" . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '?' . SID . "'>";
echo '<div>';
echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';

$SQL = "SELECT MonthName(lastdate_in_period) AS mnth,
		YEAR(lastdate_in_period) AS yr,
		periodno
		FROM weberp_periods";
echo '<br /><div class="centre">' . _('Select the Period to update the costs for') . ':<select name="PeriodNo">';
$result = DB_query($SQL);

echo '<option selected="selected" value="0">' . _('No Period Selected') . '</option>';

while ($PeriodInfo=DB_fetch_array($result)){

	echo '<option value="' . $PeriodInfo['periodno'] . '">' . $PeriodInfo['mnth'] . ' ' . $PeriodInfo['Yr'] . '</option>';

}

echo '</select>';

echo '<br /><input type="submit" name="UpdateSalesAnalysis" value="' . _('Update Sales Analysis Costs') .'" /></div>';
echo '</div></form>';

if (isset($_POST['UpdateSalesAnalysis']) AND $_POST['PeriodNo']!=0){
	$sql = "SELECT weberp_stockmaster.stockid,
			materialcost+overheadcost+labourcost AS standardcost,
			weberp_stockmaster.mbflag
		FROM weberp_salesanalysis INNER JOIN weberp_stockmaster
			ON weberp_salesanalysis.stockid=weberp_stockmaster.stockid
		WHERE periodno='" . $_POST['PeriodNo']  . "'
		AND weberp_stockmaster.mbflag<>'D'
		GROUP BY weberp_stockmaster.stockid,
			weberp_stockmaster.materialcost,
			weberp_stockmaster.overheadcost,
			weberp_stockmaster.labourcost,
			weberp_stockmaster.mbflag";


	$ErrMsg = _('Could not retrieve the sales analysis records to be updated because');
	$result = DB_query($sql,$ErrMsg);

	while ($ItemsToUpdate = DB_fetch_array($result)){

		if ($ItemsToUpdate['mbflag']=='A'){
			$SQL = "SELECT SUM(materialcost + labourcost + overheadcost) AS standardcost
					FROM weberp_stockmaster INNER JOIN weberp_BOM
						ON weberp_stockmaster.stockid = weberp_bom.component
					WHERE weberp_bom.parent = '" . $ItemsToUpdate['stockid'] . "'
					AND weberp_bom.effectiveto > '" . Date('Y-m-d') . "'
					AND weberp_bom.effectiveafter < '" . Date('Y-m-d') . "'";

			$ErrMsg = _('Could not recalculate the current cost of the assembly item') . $ItemsToUpdate['stockid'] . ' ' . _('because');
			$AssemblyCostResult = DB_query($SQL,$ErrMsg);
			$AssemblyCost = DB_fetch_row($AssemblyCostResult);
			$Cost = $AssemblyCost[0];
		} else {
			$Cost = $ItemsToUpdate['standardcost'];
		}

		$SQL = "UPDATE weberp_salesanalysis SET cost = (qty * " . $Cost . ")
				WHERE stockid='" . $ItemsToUpdate['stockid'] . "'
				AND periodno ='" . $_POST['PeriodNo'] . "'";

		$ErrMsg = _('Could not update the sales analysis records for') . ' ' . $ItemsToUpdate['stockid'] . ' ' . _('because');
		$UpdResult = DB_query($SQL,$ErrMsg);


		prnMsg(_('Updated sales analysis for period') . ' ' . $_POST['PeriodNo'] . ' ' . _('and stock item') . ' ' . $ItemsToUpdate['stockid'] . ' ' . _('using a cost of') . ' ' . $Cost,'success');
	}


	prnMsg(_('Updated the sales analysis cost data for period') . ' '. $_POST['PeriodNo'],'success');
}
include('includes/footer.inc');
?>
