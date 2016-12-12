<?php

/* $Id: Z_ReverseSuppPaymentRun.php 6941 2014-10-26 23:18:08Z daintree $*/

/* Script to delete all supplier payments entered or created from a payment run on a specified day
 */

include ('includes/session.inc');
$Title = _('Reverse and Delete Supplier Payments');
include('includes/header.inc');


/*Only do deletions if user hits the button */
if (isset($_POST['RevPayts']) AND Is_Date($_POST['PaytDate'])==1){

	$SQLTranDate = FormatDateForSQL($_POST['PaytDate']);

	$SQL = "SELECT id,
			transno,
			supplierno,
			ovamount,
			suppreference,
			rate
		FROM weberp_supptrans
		WHERE weberp_supptrans.type = 22
		AND trandate = '" . $SQLTranDate . "'";

	$Result = DB_query($SQL);
	prnMsg(_('The number of payments that will be deleted is') . ' :' . DB_num_rows($Result),'info');

	while ($Payment = DB_fetch_array($Result)){
		prnMsg(_('Deleting payment number') . ' ' . $Payment['transno'] . ' ' . _('to supplier code') . ' ' . $Payment['supplierno'] . ' ' . _('for an amount of') . ' ' . $Payment['ovamount'],'info');

		$SQL = "SELECT weberp_supptrans.transno,
				weberp_supptrans.type,
				weberp_suppallocs.amt
			FROM weberp_supptrans INNER JOIN weberp_suppallocs
			ON weberp_supptrans.id=weberp_suppallocs.transid_allocto
			WHERE weberp_suppallocs.transid_allocfrom = " .  $Payment['id'];

		$AllocsResult = DB_query($SQL);
		while ($Alloc = DB_fetch_array($AllocsResult)){

			$SQL= "UPDATE weberp_supptrans SET settled=0,
										alloc=alloc-" . $Alloc['amt'] . ",
										diffonexch = diffonexch - ((" . $Alloc['amt'] . "/rate ) - " . $Alloc['amt']/$Payment['rate'] . ")
					WHERE weberp_supptrans.type='" . $Alloc['type'] . "'
					AND transno='" . $Alloc['transno'] . "'";

			$ErrMsg =_('The update to the suppliers charges that were settled by the payment failed because');
			$UpdResult = DB_query($SQL,$ErrMsg);

		}

		prnMsg(' ... ' . _('reversed the allocations'),'info');
		$SQL= "DELETE FROM weberp_suppallocs WHERE transid_allocfrom='" . $Payment['id'] . "'";
		$DelResult = DB_query($SQL);
		prnMsg(' ... ' . _('deleted the SuppAllocs records'),'info');

		$SQL = "DELETE FROM weberp_supptrans
			WHERE type=22
			AND transno='" . $Payment['transno'] . "'
			AND trandate='" . $SQLTranDate . "'";

		$DelResult = DB_query($SQL);
		prnMsg(_('Deleted the SuppTran record'),'success');


		$SQL= "DELETE FROM weberp_gltrans WHERE typeno='" . $Payment['transno'] . "' AND type=22";
		$DelResult = DB_query($SQL);
		prnMsg(' .... ' . _('the GLTrans records (if any)'),'info');

		$SQL= "DELETE FROM weberp_banktrans
				WHERE ref='" . $Payment['suppreference'] . ' ' . $Payment['supplierno'] . "'
				AND amount=" . $Payment['ovamount'] . "
				AND transdate = '" . $SQLTranDate . "'";
		$DelResult = DB_query($SQL);
		prnMsg(' .... ' . _('and the BankTrans record'),'info');

	}
}


echo '<form method="post" action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '">';
echo '<div class="centre">';
echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';
echo '<br />' . _('Enter the date of the payment run') . ': <input type="text" name="PaytDate" maxlength="11" size="11" value="' . $_POST['PaytDate'] . '" />';
echo '<input type="submit" name="RevPayts" value="' . _('Reverse Supplier Payments on the Date Entered') . '" />';
echo '</div>
      </form>';

include('includes/footer.inc');
?>