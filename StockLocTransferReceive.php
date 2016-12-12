<?php
/* $Id: StockLocTransferReceive.php 7343 2015-08-19 07:37:57Z tehonu $*/
/* Inventory Transfer - Receive */

include('includes/DefineSerialItems.php');
include('includes/DefineStockTransfers.php');

include('includes/session.inc');
$Title = _('Inventory Transfer') . ' - ' . _('Receiving');// Screen identification.
$ViewTopic = 'Inventory';// Filename's id in ManualContents.php's TOC.
$BookMark = 'LocationTransfers';// Anchor's id in the manual's html document.
include('includes/header.inc');

include('includes/SQL_CommonFunctions.inc');

if(isset($_GET['NewTransfer'])) {
	unset($_SESSION['Transfer']);
}
if(isset($_SESSION['Transfer']) and $_SESSION['Transfer']->TrfID == '') {
	unset($_SESSION['Transfer']);
}


if(isset($_POST['ProcessTransfer'])) {
/*Ok Time To Post transactions to Inventory Transfers, and Update Posted variable & received Qty's  to LocTransfers */

	$PeriodNo = GetPeriod ($_SESSION['Transfer']->TranDate, $db);
	$SQLTransferDate = FormatDateForSQL($_SESSION['Transfer']->TranDate);

	$InputError = False; /*Start off hoping for the best */
	$i=0;
	$TotalQuantity = 0;
	foreach ($_SESSION['Transfer']->TransferItem AS $TrfLine) {
		if(is_numeric(filter_number_format($_POST['Qty' . $i]))) {
		/*Update the quantity received from the inputs */
			$_SESSION['Transfer']->TransferItem[$i]->Quantity= round(filter_number_format($_POST['Qty' . $i]),$_SESSION['Transfer']->TransferItem[$i]->DecimalPlaces);
  		} elseif($_POST['Qty' . $i]=='') {
			$_SESSION['Transfer']->TransferItem[$i]->Quantity= 0;
		} else {
			prnMsg(_('The quantity entered for'). ' ' . $TrfLine->StockID . ' '. _('is not numeric') . '. ' . _('All quantities must be numeric'),'error');
			$InputError = True;
		}
		if(filter_number_format($_POST['Qty' . $i])<0) {
			prnMsg(_('The quantity entered for'). ' ' . $TrfLine->StockID . ' '. _('is negative') . '. ' . _('All quantities must be for positive numbers greater than zero'),'error');
			$InputError = True;
		}
		if($TrfLine->PrevRecvQty + $TrfLine->Quantity > $TrfLine->ShipQty) {
			prnMsg( _('The Quantity entered plus the Quantity Previously Received can not be greater than the Total Quantity shipped for').' '. $TrfLine->StockID , 'error');
			$InputError = True;
		}
		if(isset($_POST['CancelBalance' . $i]) and $_POST['CancelBalance' . $i]==1) {
			$_SESSION['Transfer']->TransferItem[$i]->CancelBalance=1;
		} else {
			 $_SESSION['Transfer']->TransferItem[$i]->CancelBalance=0;
		}
		$TotalQuantity += $TrfLine->Quantity;
		$i++;
	} /*end loop to validate and update the SESSION['Transfer'] data */
	if($TotalQuantity < 0) {
		prnMsg( _('All quantities entered are less than zero') . '. ' . _('Please correct that and try again'), 'error' );
		$InputError = True;
	}
//exit;
	if(!$InputError) {
	/*All inputs must be sensible so make the stock movement records and update the locations stocks */

		$Result = DB_Txn_Begin(); // The Txn should affect the full transfer

		foreach ($_SESSION['Transfer']->TransferItem AS $TrfLine) {
			if($TrfLine->Quantity >= 0) {

				/* Need to get the current location quantity will need it later for the stock movement */
				$SQL="SELECT weberp_locstock.quantity
						FROM weberp_locstock
						WHERE weberp_locstock.stockid='" . $TrfLine->StockID . "'
						AND loccode= '" . $_SESSION['Transfer']->StockLocationFrom . "'";

				$Result = DB_query($SQL, _('Could not retrieve the stock quantity at the dispatch stock location prior to this transfer being processed') );
				if(DB_num_rows($Result)==1) {
					$LocQtyRow = DB_fetch_row($Result);
					$QtyOnHandPrior = $LocQtyRow[0];
				} else {
					/* There must actually be some error this should never happen */
					$QtyOnHandPrior = 0;
				}

				/* Insert the stock movement for the stock going out of the from location */
				$SQL = "INSERT INTO weberp_stockmoves (stockid,
												type,
												transno,
												loccode,
												trandate,
												userid,
												prd,
												reference,
												qty,
												newqoh)
					VALUES (
						'" . $TrfLine->StockID . "',
						16,
						'" . $_SESSION['Transfer']->TrfID . "',
						'" . $_SESSION['Transfer']->StockLocationFrom . "',
						'" . $SQLTransferDate . "',
						'" . $_SESSION['UserID'] . "',
						'" . $PeriodNo . "',
						'" . _('To') . ' ' . DB_escape_string($_SESSION['Transfer']->StockLocationToName) . "',
						'" . round(-$TrfLine->Quantity, $TrfLine->DecimalPlaces) . "',
						'" . round($QtyOnHandPrior - $TrfLine->Quantity, $TrfLine->DecimalPlaces) . "'
					)";

				$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The stock movement record cannot be inserted because');
				$DbgMsg = _('The following SQL to insert the stock movement record was used');
				$Result = DB_query($SQL,$ErrMsg, $DbgMsg, true);

				/*Get the ID of the StockMove... */
				$StkMoveNo = DB_Last_Insert_ID($db,'weberp_stockmoves','stkmoveno');

		/*Insert the StockSerialMovements and update the StockSerialItems  for controlled items*/

				if($TrfLine->Controlled ==1) {
					foreach($TrfLine->SerialItems as $Item) {
					/*We need to add or update the StockSerialItem record and
					The StockSerialMoves as well */

						/*First need to check if the serial items already exists or not in the location from */
						$SQL = "SELECT COUNT(*)
							FROM weberp_stockserialitems
							WHERE
							stockid='" . $TrfLine->StockID . "'
							AND loccode='" . $_SESSION['Transfer']->StockLocationFrom . "'
							AND serialno='" . $Item->BundleRef . "'";

						$Result = DB_query($SQL,'<br />' . _('Could not determine if the serial item exists') );
						$SerialItemExistsRow = DB_fetch_row($Result);

						if($SerialItemExistsRow[0]==1) {

							$SQL = "UPDATE weberp_stockserialitems SET
								quantity= quantity - " . $Item->BundleQty . "
								WHERE
								stockid='" . $TrfLine->StockID . "'
								AND loccode='" . $_SESSION['Transfer']->StockLocationFrom . "'
								AND serialno='" . $Item->BundleRef . "'";

							$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The serial stock item record could not be updated because');
							$DbgMsg = _('The following SQL to update the serial stock item record was used');
							$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);
						} else {
							/*Need to insert a new serial item record */
							$SQL = "INSERT INTO weberp_stockserialitems (stockid,
												loccode,
												serialno,
												quantity)
								VALUES ('" . $TrfLine->StockID . "',
								'" . $_SESSION['Transfer']->StockLocationFrom . "',
								'" . $Item->BundleRef . "',
								'" . -$Item->BundleQty . "')";

							$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The serial stock item for the stock being transferred out of the existing location could not be inserted because');
							$DbgMsg = _('The following SQL to update the serial stock item record was used');
							$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);
						}


						/* now insert the serial stock movement */

						$SQL = "INSERT INTO weberp_stockserialmoves (
								stockmoveno,
								stockid,
								serialno,
								moveqty
							) VALUES (
								'" . $StkMoveNo . "',
								'" . $TrfLine->StockID . "',
								'" . $Item->BundleRef . "',
								'" . -$Item->BundleQty . "'
							)";
						$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The serial stock movement record could not be inserted because');
						$DbgMsg =  _('The following SQL to insert the serial stock movement records was used');
						$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);

					}/* foreach controlled item in the serialitems array */
				} /*end if the transferred item is a controlled item */


				/* Need to get the current location quantity will need it later for the stock movement */
				$SQL="SELECT weberp_locstock.quantity
						FROM weberp_locstock
						WHERE weberp_locstock.stockid='" . $TrfLine->StockID . "'
						AND loccode= '" . $_SESSION['Transfer']->StockLocationTo . "'";

				$Result = DB_query($SQL,  _('Could not retrieve the quantity on hand at the location being transferred to') );
				if(DB_num_rows($Result)==1) {
					$LocQtyRow = DB_fetch_row($Result);
					$QtyOnHandPrior = $LocQtyRow[0];
				} else {
					// There must actually be some error this should never happen
					$QtyOnHandPrior = 0;
				}

				// Insert outgoing inventory GL transaction if any of the locations has a GL account code:
				if(($_SESSION['Transfer']->StockLocationFromAccount !='' or $_SESSION['Transfer']->StockLocationToAccount !='')) {
					// Get the account code:
					if($_SESSION['Transfer']->StockLocationFromAccount !='') {
						$AccountCode = $_SESSION['Transfer']->StockLocationFromAccount;
					} else {
						$StockGLCode = GetStockGLCode($TrfLine->StockID, $db);// Get Category's account codes.
						$AccountCode = $StockGLCode['stockact'];// Select account code for stock.
					}
					// Get the item cost:
					$SQLstandardcost = "SELECT weberp_stockmaster.materialcost + weberp_stockmaster.labourcost + weberp_stockmaster.overheadcost AS standardcost
										FROM weberp_stockmaster
										WHERE weberp_stockmaster.stockid ='" . $TrfLine->StockID . "'";
					$ErrMsg = _('The standard cost of the item cannot be retrieved because');
					$DbgMsg = _('The SQL that failed was');
					$myrow = DB_fetch_array(DB_query($SQLstandardcost,$ErrMsg,$DbgMsg));
					$StandardCost = $myrow['standardcost'];// QUESTION: Standard cost for: Assembly (value="A") and Manufactured (value="M") items ?
					// Insert record:
					$SQL = "INSERT INTO weberp_gltrans (
							periodno,
							trandate,
							type,
							typeno,
							account,
							narrative,
							amount)
						VALUES ('" .
							$PeriodNo . "','" .
							$SQLTransferDate .
							"',16,'" .
							$_SESSION['Transfer']->TrfID . "','" .
							$AccountCode . "','" .
							$_SESSION['Transfer']->StockLocationFrom.' - '.$TrfLine->StockID.' x '.$TrfLine->Quantity.' @ '. $StandardCost . "','" .
							-$TrfLine->Quantity * $StandardCost . "')";
					$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The outgoing inventory GL transacction record could not be inserted because');
					$DbgMsg =  _('The following SQL to insert records was used');
					$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);
				}

				// Insert the stock movement for the stock coming into the to location
				$SQL = "INSERT INTO weberp_stockmoves (stockid,
												type,
												transno,
												loccode,
												trandate,
												userid,
												prd,
												reference,
												qty,
												newqoh)
					VALUES (
						'" . $TrfLine->StockID . "',
						16,
						'" . $_SESSION['Transfer']->TrfID . "',
						'" . $_SESSION['Transfer']->StockLocationTo . "',
						'" . $SQLTransferDate . "',
						'" . $_SESSION['UserID'] . "',
						'" . $PeriodNo . "',
						'" . _('From') . ' ' . DB_escape_string($_SESSION['Transfer']->StockLocationFromName) ."',
						'" . round($TrfLine->Quantity, $TrfLine->DecimalPlaces) . "',
						'" . round($QtyOnHandPrior + $TrfLine->Quantity, $TrfLine->DecimalPlaces) . "'
						)";

				$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The stock movement record for the incoming stock cannot be added because');
				$DbgMsg =  _('The following SQL to insert the stock movement record was used');
				$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);


				/*Get the ID of the StockMove... */
				$StkMoveNo = DB_Last_Insert_ID($db,'weberp_stockmoves','stkmoveno');

				/*Insert the StockSerialMovements and update the StockSerialItems  for controlled items*/
				if($TrfLine->Controlled ==1) {
					foreach($TrfLine->SerialItems as $Item) {
					/*We need to add or update the StockSerialItem record and the StockSerialMoves as well */

						/*First need to check if the serial items already exists or not in the location to */
						$SQL = "SELECT COUNT(*)
							FROM weberp_stockserialitems
							WHERE
							stockid='" . $TrfLine->StockID . "'
							AND loccode='" . $_SESSION['Transfer']->StockLocationTo . "'
							AND serialno='" . $Item->BundleRef . "'";

						$Result = DB_query($SQL,'<br />' .  _('Could not determine if the serial item exists') );
						$SerialItemExistsRow = DB_fetch_row($Result);


						if($SerialItemExistsRow[0]==1) {

							$SQL = "UPDATE weberp_stockserialitems SET
								quantity= quantity + '" . $Item->BundleQty . "'
								WHERE
								stockid='" . $TrfLine->StockID . "'
								AND loccode='" . $_SESSION['Transfer']->StockLocationTo . "'
								AND serialno='" . $Item->BundleRef . "'";

							$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The serial stock item record could not be updated for the quantity coming in because');
							$DbgMsg =  _('The following SQL to update the serial stock item record was used');
							$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);
						} else {
							/*Need to insert a new serial item record */
							$SQL = "INSERT INTO weberp_stockserialitems (stockid,
											loccode,
											serialno,
											quantity)
								VALUES ('" . $TrfLine->StockID . "',
								'" . $_SESSION['Transfer']->StockLocationTo . "',
								'" . $Item->BundleRef . "',
								'" . $Item->BundleQty . "')";

							$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The serial stock item record for the stock coming in could not be added because');
							$DbgMsg =  _('The following SQL to update the serial stock item record was used');
							$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);
						}


						/* now insert the serial stock movement */

						$SQL = "INSERT INTO weberp_stockserialmoves (
											stockmoveno,
											stockid,
											serialno,
											moveqty)
								VALUES (" . $StkMoveNo . ",
									'" . $TrfLine->StockID . "',
									'" . $Item->BundleRef . "',
									'" . $Item->BundleQty . "')";
						$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The serial stock movement record could not be inserted because');
						$DbgMsg =  _('The following SQL to insert the serial stock movement records was used');
						$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);

					}/* foreach controlled item in the serialitems array */
				} /*end if the transfer item is a controlled item */

				$SQL = "UPDATE weberp_locstock
					SET quantity = quantity - '" . round($TrfLine->Quantity, $TrfLine->DecimalPlaces) . "'
					WHERE stockid='" . $TrfLine->StockID . "'
					AND loccode='" . $_SESSION['Transfer']->StockLocationFrom . "'";

				$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The location stock record could not be updated because');
				$DbgMsg =  _('The following SQL to update the stock record was used');
				$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);

				$SQL = "UPDATE weberp_locstock
					SET quantity = quantity + '" . round($TrfLine->Quantity, $TrfLine->DecimalPlaces) . "'
					WHERE stockid='" . $TrfLine->StockID . "'
					AND loccode='" . $_SESSION['Transfer']->StockLocationTo . "'";

				$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The location stock record could not be updated because');
				$DbgMsg =  _('The following SQL to update the stock record was used');
				$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);

				// Insert incoming inventory GL transaction if any of the locations has a GL account code:
				if(($_SESSION['Transfer']->StockLocationFromAccount !='' or $_SESSION['Transfer']->StockLocationToAccount !='')) {
					// Get the account code:
					if($_SESSION['Transfer']->StockLocationToAccount !='') {
						$AccountCode = $_SESSION['Transfer']->StockLocationToAccount;
					} else {
						$StockGLCode = GetStockGLCode($TrfLine->StockID, $db);// Get Category's account codes.
						$AccountCode = $StockGLCode['stockact'];// Select account code for stock.
					}
					// Get the item cost:
					$SQLstandardcost = "SELECT weberp_stockmaster.materialcost + weberp_stockmaster.labourcost + weberp_stockmaster.overheadcost AS standardcost
										FROM weberp_stockmaster
										WHERE weberp_stockmaster.stockid ='" . $TrfLine->StockID . "'";
					$ErrMsg = _('The standard cost of the item cannot be retrieved because');
					$DbgMsg = _('The SQL that failed was');
					$myrow = DB_fetch_array(DB_query($SQLstandardcost,$ErrMsg,$DbgMsg));
					$StandardCost = $myrow['standardcost'];// QUESTION: Standard cost for: Assembly (value="A") and Manufactured (value="M") items ?
					// Insert record:
					$SQL = "INSERT INTO weberp_gltrans (
							periodno,
							trandate,
							type,
							typeno,
							account,
							narrative,
							amount)
						VALUES ('" .
							$PeriodNo . "','" .
							$SQLTransferDate . "',
							16,'" .
							$_SESSION['Transfer']->TrfID . "','" .
							$AccountCode . "','" .
							$_SESSION['Transfer']->StockLocationTo.' - '.$TrfLine->StockID.' x '.$TrfLine->Quantity.' @ '. $StandardCost . "','" .
							$TrfLine->Quantity * $StandardCost . "')";
					$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The incoming inventory GL transacction record could not be inserted because');
					$DbgMsg =  _('The following SQL to insert records was used');
					$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);
				}

				prnMsg(_('A stock transfer for item code'). ' - '  . $TrfLine->StockID . ' ' . $TrfLine->ItemDescription . ' '. _('has been created from').' ' . $_SESSION['Transfer']->StockLocationFromName . ' '. _('to'). ' ' . $_SESSION['Transfer']->StockLocationToName . ' ' . _('for a quantity of'). ' '. $TrfLine->Quantity,'success');

				if($TrfLine->CancelBalance==1) {
					RecordItemCancelledInTransfer($_SESSION['Transfer']->TrfID, $TrfLine->StockID, $TrfLine->Quantity);
					$sql = "UPDATE weberp_loctransfers SET recqty = recqty + '". round($TrfLine->Quantity, $TrfLine->DecimalPlaces) . "',
						shipqty = recqty + '". round($TrfLine->Quantity, $TrfLine->DecimalPlaces) . "',
								recdate = '".Date('Y-m-d H:i:s'). "'
						WHERE reference = '". $_SESSION['Transfer']->TrfID . "'
						AND stockid = '".  $TrfLine->StockID."'";
				} else {
					$sql = "UPDATE weberp_loctransfers SET recqty = recqty + '". round($TrfLine->Quantity, $TrfLine->DecimalPlaces) . "',
								recdate = '".Date('Y-m-d H:i:s'). "'
						WHERE reference = '". $_SESSION['Transfer']->TrfID . "'
						AND stockid = '".  $TrfLine->StockID."'";
				}
				$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('Unable to update the Location Transfer Record');
				$Result = DB_query($sql, $ErrMsg, $DbgMsg, true);
				unset ($_SESSION['Transfer']->LineItem[$i]);
				unset ($_POST['Qty' . $i]);
			} /*end if Quantity >= 0 */
			if($TrfLine->CancelBalance==1) {
				$sql = "UPDATE weberp_loctransfers SET shipqty = recqty
						WHERE reference = '". $_SESSION['Transfer']->TrfID . "'
						AND stockid = '".  $TrfLine->StockID."'";
				$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('Unable to set the quantity received to the quantity shipped to cancel the balance on this transfer line');
				$Result = DB_query($sql, $ErrMsg, $DbgMsg, true);
				// send an email to the inventory manager about this cancellation (as can lead to employee fraud)
				if($_SESSION['InventoryManagerEmail']!='') {
					$ConfirmationText = _('Cancelled balance of transfer'). ': ' . $_SESSION['Transfer']->TrfID .
										"\r\n" . _('From Location') . ': ' . $_SESSION['Transfer']->StockLocationFrom .
										"\r\n" . _('To Location') . ': ' . $_SESSION['Transfer']->StockLocationTo .
										"\r\n" . _('Stock code') . ': ' . $TrfLine->StockID .
										"\r\n" . _('Qty received') . ': ' . round($TrfLine->Quantity, $TrfLine->DecimalPlaces) .
										"\r\n" . _('By user') . ': ' . $_SESSION['UserID'] .
										"\r\n" . _('At') . ': ' . Date('Y-m-d H:i:s');
					$EmailSubject = _('Cancelled balance of transfer'). ' ' . $_SESSION['Transfer']->TrfID;
					if($_SESSION['SmtpSetting']==0) {
						      mail($_SESSION['InventoryManagerEmail'],$EmailSubject,$ConfirmationText);
					} else{
						include('includes/htmlMimeMail.php');
						$mail = new htmlMimeMail();
						$mail->setSubject($EmailSubject);
						$mail->setText($ConfirmationText);
						$result = SendmailBySmtp($mail,array($_SESSION['InventoryManagerEmail']));
					}
				}
			}
			$i++;
		} /*end of foreach TransferItem */

		$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('Unable to COMMIT the Stock Transfer transaction');
		DB_Txn_Commit();

		unset($_SESSION['Transfer']->LineItem);
		unset($_SESSION['Transfer']);
	} /* end of if no input errors */

} /*end of PRocess Transfer */

if(isset($_GET['Trf_ID'])) {

	unset($_SESSION['Transfer']);

	$sql = "SELECT weberp_loctransfers.stockid,
				weberp_stockmaster.description,
				weberp_stockmaster.units,
				weberp_stockmaster.controlled,
				weberp_stockmaster.serialised,
				weberp_stockmaster.perishable,
				weberp_stockmaster.decimalplaces,
				weberp_loctransfers.shipqty,
				weberp_loctransfers.recqty,
				weberp_locations.locationname as shiplocationname,
				weberp_locations.glaccountcode as shipaccountcode,
				reclocations.locationname as reclocationname,
				reclocations.glaccountcode as recaccountcode,
				weberp_loctransfers.shiploc,
				weberp_loctransfers.recloc
			FROM weberp_loctransfers INNER JOIN weberp_locations
			ON weberp_loctransfers.shiploc=weberp_locations.loccode
			INNER JOIN weberp_locations as reclocations
			ON weberp_loctransfers.recloc = reclocations.loccode
			INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=reclocations.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canupd=1
			INNER JOIN weberp_stockmaster
			ON weberp_loctransfers.stockid=weberp_stockmaster.stockid
			WHERE reference ='" . $_GET['Trf_ID'] . "' ORDER BY weberp_loctransfers.stockid";


	$ErrMsg = _('The details of transfer number') . ' ' . $_GET['Trf_ID'] . ' ' . _('could not be retrieved because') .' ';
	$DbgMsg = _('The SQL to retrieve the transfer was');
	$result = DB_query($sql,$ErrMsg,$DbgMsg);

	if(DB_num_rows($result) == 0) {
		echo '<h3>' . _('Transfer') . ' #' . $_GET['Trf_ID'] . ' '. _('Does Not Exist') . '</h3><br />';
		include('includes/footer.inc');
		exit;
	}

	$myrow=DB_fetch_array($result);

	$_SESSION['Transfer']= new StockTransfer($_GET['Trf_ID'],
											$myrow['shiploc'],
											$myrow['shiplocationname'],
											$myrow['shipaccountcode'],
											$myrow['recloc'],
											$myrow['reclocationname'],
											$myrow['recaccountcode'],
											Date($_SESSION['DefaultDateFormat']) );
	/*Populate the StockTransfer TransferItem s array with the lines to be transferred */
	$i = 0;
	do {
		$_SESSION['Transfer']->TransferItem[$i]= new LineItem ($myrow['stockid'],
																$myrow['description'],
																$myrow['shipqty'],
																$myrow['units'],
																$myrow['controlled'],
																$myrow['serialised'],
																$myrow['perishable'],
																$myrow['decimalplaces'] );
		$_SESSION['Transfer']->TransferItem[$i]->PrevRecvQty = $myrow['recqty'];
		$_SESSION['Transfer']->TransferItem[$i]->Quantity = $myrow['shipqty']-$myrow['recqty'];

		$i++; /*numerical index for the TransferItem[] array of LineItem s */

	} while ($myrow=DB_fetch_array($result));

} /* $_GET['Trf_ID'] is set */

if(isset($_SESSION['Transfer'])) {
	//Begin Form for receiving shipment

	echo '<p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/supplier.png" title="' . _('Dispatch') .
		'" alt="" />' . ' ' . $Title . '</p>';
	echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '?'. SID . '" method="post">';
    echo '<div>';
	echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';

	prnMsg(_('Please Verify Shipment Quantities Received'),'info');

	$i = 0;//Line Item Array pointer

	echo '<br />
			<table class="selection">';
	echo '<tr>
			<th colspan="7"><h3>' . _('Location Transfer Reference'). ' #' . $_SESSION['Transfer']->TrfID . ' '. _('from').' ' . $_SESSION['Transfer']->StockLocationFromName . ' '. _('to'). ' ' . $_SESSION['Transfer']->StockLocationToName . '</h3></th>
		</tr>';

	$tableheader = '<tr>
						<th>' .  _('Item Code') . '</th>
						<th>' .  _('Item Description'). '</th>
						<th>' .  _('Quantity Dispatched'). '</th>
						<th>' .  _('Quantity Received'). '</th>
						<th>' .  _('Quantity To Receive'). '</th>
						<th>' .  _('Units'). '</th>
						<th>' .  _('Cancel Balance') . '</th>
					</tr>';

	echo $tableheader;
	$k=0;
	foreach ($_SESSION['Transfer']->TransferItem AS $TrfLine) {
		if($k==1) {
			echo '<tr class="EvenTableRows">';
			$k=0;
		} else {
			echo '<tr class="OddTableRows">';
			$k++;
		}

		echo '<td>' . $TrfLine->StockID . '</td>
			<td>' . $TrfLine->ItemDescription . '</td>';

		echo '<td class="number">' . locale_number_format($TrfLine->ShipQty, $TrfLine->DecimalPlaces) . '</td>';
		if(isset($_POST['Qty' . $i]) AND is_numeric(filter_number_format($_POST['Qty' . $i]))) {

			$_SESSION['Transfer']->TransferItem[$i]->Quantity= round(filter_number_format($_POST['Qty' . $i]),$TrfLine->DecimalPlaces);

			$Qty = round(filter_number_format($_POST['Qty' . $i]),$TrfLine->DecimalPlaces);

		} else if($TrfLine->Controlled==1) {
			if(sizeOf($TrfLine->SerialItems)==0) {
				$Qty = 0;
			} else {
				$Qty = $TrfLine->Quantity;
			}
		} else {
			$Qty = $TrfLine->Quantity;
		}
		echo '<td class="number">' . locale_number_format($TrfLine->PrevRecvQty, $TrfLine->DecimalPlaces) . '</td>';

		if($TrfLine->Controlled==1) {
			echo '<td class="number"><input type="hidden" name="Qty' . $i . '" value="' . locale_number_format($Qty,$TrfLine->DecimalPlaces) . '" /><a href="' . $RootPath .'/StockTransferControlled.php?TransferItem=' . $i . '" />' . $Qty . '</a></td>';
		} else {
			echo '<td><input type="text" class="number" name="Qty' . $i . '" maxlength="10" size="auto" value="' . locale_number_format($Qty,$TrfLine->DecimalPlaces) . '" /></td>';
		}

		echo '<td>' . $TrfLine->PartUnit . '</td>';

		echo '<td><input type="checkbox" name="CancelBalance' . $i . '" value="1" /></td>';


		if($TrfLine->Controlled==1) {
			if($TrfLine->Serialised==1) {
				echo '<td><a href="' . $RootPath .'/StockTransferControlled.php?TransferItem=' . $i . '">' . _('Enter Serial Numbers') . '</a></td>';
			} else {
				echo '<td><a href="' . $RootPath .'/StockTransferControlled.php?TransferItem=' . $i . '">' . _('Enter Batch Refs') . '</a></td>';
			}
		}

		echo '</tr>';

		$i++; /* the array of TransferItem s is indexed numerically and i matches the index no */
	} /*end of foreach TransferItem */

	echo '</table>
		<br />
		<div class="centre">
			<input type="submit" name="ProcessTransfer" value="'. _('Process Inventory Transfer'). '" />
			<br />
		</div>
        </div>
		</form>';
	echo '<a href="'.htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8'). '?NewTransfer=true">' .  _('Select A Different Transfer') . '</a>';

} else { /*Not $_SESSION['Transfer'] set */

	echo '<p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/supplier.png" title="' . _('Dispatch') . '" alt="" />' . ' ' . $Title . '</p>';

	echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '" method="post" id="form1">';
    echo '<div>';
	echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';

	$LocResult = DB_query("SELECT locationname, weberp_locations.loccode FROM weberp_locations INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locations.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1 ORDER BY locationname");

	echo '<table class="selection">';
	echo '<tr>
			<td>' .  _('Select Location Receiving Into'). ':</td>
			<td>';
	echo '<select name="RecLocation" onchange="ReloadForm(form1.RefreshTransferList)">';
	if(!isset($_POST['RecLocation'])) {
		$_POST['RecLocation'] = $_SESSION['UserStockLocation'];
	}
	while ($myrow=DB_fetch_array($LocResult)) {
		if($myrow['loccode'] == $_POST['RecLocation']) {
			echo '<option selected="selected" value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
		} else {
			echo '<option value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
		}
	}
	echo '</select>
		<input type="submit" name="RefreshTransferList" value="' . _('Refresh Transfer List') . '" /></td>
		</tr>
		</table>
		<br />';

	$sql = "SELECT DISTINCT reference,
				weberp_locations.locationname as trffromloc,
				shipdate
			FROM weberp_loctransfers INNER JOIN weberp_locations
				ON weberp_loctransfers.shiploc=weberp_locations.loccode
			WHERE recloc='" . $_POST['RecLocation'] . "'
			AND recqty < shipqty";

	$TrfResult = DB_query($sql);
	if(DB_num_rows($TrfResult)>0) {
		$LocSql = "SELECT locationname FROM weberp_locations WHERE loccode='" . $_POST['RecLocation'] . "'";
		$LocResult = DB_query($LocSql);
		$LocRow = DB_fetch_array($LocResult);
		echo '<table class="selection">';
		echo '<tr><th colspan="4"><h3>' . _('Pending Transfers Into').' '.$LocRow['locationname'] . '</h3></th></tr>';
		echo '<tr>
			<th>' .  _('Transfer Ref'). '</th>
			<th>' .  _('Transfer From'). '</th>
			<th>' .  _('Dispatch Date'). '</th></tr>';
		$k=0;
		while ($myrow=DB_fetch_array($TrfResult)) {

			if($k==1) {
				echo '<tr class="EvenTableRows">';
				$k=0;
			} else {
				echo '<tr class="OddTableRows">';
				$k++;
			}
			echo '<td class="number">' . $myrow['reference'] . '</td>
					<td>' . $myrow['trffromloc'] . '</td>
					<td>' . ConvertSQLDateTime($myrow['shipdate']) . '</td>
					<td><a href="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '?Trf_ID=' . $myrow['reference'] . '">' .  _('Receive'). '</a></td>
					</tr>';
		}
		echo '</table>';
	} else if(!isset($_POST['ProcessTransfer'])) {
		prnMsg(_('There are no incoming transfers to this location'), 'info');
	}
	echo '</div>
          </form>';
}
include('includes/footer.inc');

function RecordItemCancelledInTransfer($TransferReference, $StockID, $CancelQty){
	$SQL = "INSERT INTO weberp_loctransfercancellations (
			reference,
			stockid,
			cancelqty,
			canceldate,
			canceluserid)
		VALUES ('" . $TransferReference . "',
			'" . $StockID . "',
			(SELECT (l2.shipqty-l2.recqty)
				FROM weberp_loctransfers AS l2
				WHERE l2.reference = '" . $TransferReference . "'
					AND l2.stockid ='" . $StockID . "') - " . $CancelQty . ",
			'" . Date('Y-m-d H:i:s') . "',
			'" . $_SESSION['UserID'] . "')";
	$ErrMsg =  _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The transfer cancellation record could not be inserted because');
	$DbgMsg =  _('The following SQL to insert records was used');
	$Result = DB_query($SQL, $ErrMsg, $DbgMsg, true);

}
?>