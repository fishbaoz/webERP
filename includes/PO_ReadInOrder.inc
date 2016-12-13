<?php
/* $Id: PO_ReadInOrder.inc 6941 2014-10-26 23:18:08Z daintree $*/
/*PO_ReadInOrder.inc is used by the modify existing order code in PO_Header.php and also by GoodsReceived.php */

	if (isset($_SESSION['PO'.$identifier])){
		unset ($_SESSION['PO'.$identifier]->LineItems);
		unset ($_SESSION['PO'.$identifier]);
	}

	$_SESSION['ExistingOrder']=$_GET['ModifyOrderNumber'];
	$_SESSION['RequireSupplierSelection'] = 0;
	$_SESSION['PO'.$identifier] = new PurchOrder;

	$_SESSION['PO'.$identifier]->GLLink = $_SESSION['CompanyRecord']['gllink_stock'];

/*read in all the guff from the selected order into the PO PurchOrder Class variable  */

	$OrderHeaderSQL = "SELECT weberp_purchorders.supplierno,
								weberp_suppliers.suppname,
								weberp_purchorders.comments,
								weberp_purchorders.orddate,
								weberp_purchorders.rate,
								weberp_purchorders.dateprinted,
								weberp_purchorders.deladd1,
								weberp_purchorders.deladd2,
								weberp_purchorders.deladd3,
								weberp_purchorders.deladd4,
								weberp_purchorders.deladd5,
								weberp_purchorders.deladd6,
								weberp_purchorders.tel,
								weberp_purchorders.suppdeladdress1,
								weberp_purchorders.suppdeladdress2,
								weberp_purchorders.suppdeladdress3,
								weberp_purchorders.suppdeladdress4,
								weberp_purchorders.suppdeladdress5,
								weberp_purchorders.suppdeladdress6,
								weberp_purchorders.suppliercontact,
								weberp_purchorders.supptel,
								weberp_purchorders.contact,
								weberp_purchorders.allowprint,
								weberp_purchorders.requisitionno,
								weberp_purchorders.intostocklocation,
								weberp_purchorders.initiator,
								weberp_purchorders.version,
								weberp_purchorders.status,
								weberp_purchorders.stat_comment,
								weberp_purchorders.deliverydate,
								weberp_purchorders.deliveryby,
								weberp_purchorders.port,
								weberp_suppliers.currcode,
								INTO weberp_locations.managed,
								weberp_purchorders.paymentterms,
								weberp_currencies.decimalplaces
							FROM weberp_purchorders
							INNER JOIN weberp_locations ON weberp_purchorders.intostocklocation=INTO weberp_locations.loccode
							INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=INTO weberp_locations.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canupd=1
							INNER JOIN weberp_suppliers ON weberp_purchorders.supplierno = weberp_suppliers.supplierid
							INNER JOIN weberp_currencies ON weberp_suppliers.currcode=weberp_currencies.currabrev
							WHERE weberp_purchorders.orderno = '" . $_GET['ModifyOrderNumber'] . "'";

	   $ErrMsg =  _('The order cannot be retrieved because');
	   $DbgMsg =  _('The SQL statement that was used and failed was');
	   $GetOrdHdrResult = DB_query($OrderHeaderSQL,$ErrMsg,$DbgMsg);

	if (DB_num_rows($GetOrdHdrResult)==1 and !isset($_SESSION['PO'.$identifier]->OrderNo )) {

			$myrow = DB_fetch_array($GetOrdHdrResult);
			$_SESSION['PO'.$identifier]->OrderNo = $_GET['ModifyOrderNumber'];
			$_SESSION['PO'.$identifier]->SupplierID = $myrow['supplierno'];
			$_SESSION['PO'.$identifier]->SupplierName = $myrow['suppname'];
			$_SESSION['PO'.$identifier]->CurrCode = $myrow['currcode'];
			$_SESSION['PO'.$identifier]->CurrDecimalPlaces = $myrow['decimalplaces'];
			$_SESSION['PO'.$identifier]->Orig_OrderDate = $myrow['orddate'];
			$_SESSION['PO'.$identifier]->AllowPrintPO = $myrow['allowprint'];
			$_SESSION['PO'.$identifier]->DatePurchaseOrderPrinted = $myrow['dateprinted'];
			$_SESSION['PO'.$identifier]->Comments = $myrow['comments'];
			$_SESSION['PO'.$identifier]->ExRate = $myrow['rate'];
			$_SESSION['PO'.$identifier]->Location = $myrow['intostocklocation'];
			$_SESSION['PO'.$identifier]->Initiator = $myrow['initiator'];
			$_SESSION['PO'.$identifier]->RequisitionNo = $myrow['requisitionno'];
			$_SESSION['PO'.$identifier]->DelAdd1 = $myrow['deladd1'];
			$_SESSION['PO'.$identifier]->DelAdd2 = $myrow['deladd2'];
			$_SESSION['PO'.$identifier]->DelAdd3 = $myrow['deladd3'];
			$_SESSION['PO'.$identifier]->DelAdd4 = $myrow['deladd4'];
			$_SESSION['PO'.$identifier]->DelAdd5 = $myrow['deladd5'];
			$_SESSION['PO'.$identifier]->DelAdd6 = $myrow['deladd6'];
			$_SESSION['PO'.$identifier]->Tel = $myrow['tel'];
			$_SESSION['PO'.$identifier]->SuppDelAdd1 = $myrow['suppdeladdress1'];
			$_SESSION['PO'.$identifier]->SuppDelAdd2 = $myrow['suppdeladdress2'];
			$_SESSION['PO'.$identifier]->SuppDelAdd3 = $myrow['suppdeladdress3'];
			$_SESSION['PO'.$identifier]->SuppDelAdd4 = $myrow['suppdeladdress4'];
			$_SESSION['PO'.$identifier]->SuppDelAdd5 = $myrow['suppdeladdress5'];
			$_SESSION['PO'.$identifier]->SuppDelAdd6 = $myrow['suppdeladdress6'];
			$_SESSION['PO'.$identifier]->SupplierContact = $myrow['suppliercontact'];
			$_SESSION['PO'.$identifier]->SuppTel= $myrow['supptel'];
			$_SESSION['PO'.$identifier]->Contact = $myrow['contact'];
			$_SESSION['PO'.$identifier]->Managed = $myrow['managed'];
			$_SESSION['PO'.$identifier]->Version = $myrow['version'];
			$_SESSION['PO'.$identifier]->Port = $myrow['port'];
			$_SESSION['PO'.$identifier]->DeliveryBy = $myrow['deliveryby'];
			$_SESSION['PO'.$identifier]->Status = $myrow['status'];
			$_SESSION['PO'.$identifier]->StatusComments = html_entity_decode($myrow['stat_comment'],ENT_QUOTES,'UTF-8');
			$_SESSION['PO'.$identifier]->DeliveryDate = ConvertSQLDate($myrow['deliverydate']);
			$_SESSION['ExistingOrder'] = $_SESSION['PO'.$identifier]->OrderNo;
			$_SESSION['PO'.$identifier]->PaymentTerms= $myrow['paymentterms'];

			$SupplierSQL = "SELECT weberp_suppliers.supplierid,
									weberp_suppliers.suppname,
									weberp_suppliers.address1,
									weberp_suppliers.address2,
									weberp_suppliers.address3,
									weberp_suppliers.address4,
									weberp_suppliers.address5,
									weberp_suppliers.address6,
									weberp_suppliers.currcode
							FROM weberp_suppliers
							WHERE weberp_suppliers.supplierid='" . $_SESSION['PO'.$identifier]->SupplierID."'
							ORDER BY weberp_suppliers.supplierid";

			$ErrMsg = _('The searched supplier records requested cannot be retrieved because');
			$result_SuppSelect = DB_query($SupplierSQL,$ErrMsg);

			if (DB_num_rows($result_SuppSelect)==1){
				$myrow=DB_fetch_array($result_SuppSelect);
			} elseif (DB_num_rows($result_SuppSelect)==0){
				prnMsg( _('No supplier records contain the selected text') . ' - ' .
					_('please alter your search criteria and try again'),'info');
			}

/*now populate the line PO array with the purchase order details records */

			  $LineItemsSQL = "SELECT podetailitem,
									weberp_purchorderdetails.itemcode,
									weberp_stockmaster.description,
									weberp_purchorderdetails.deliverydate,
									weberp_purchorderdetails.itemdescription,
									glcode,
									accountname,
									weberp_purchorderdetails.qtyinvoiced,
									weberp_purchorderdetails.unitprice,
									weberp_stockmaster.units,
									weberp_purchorderdetails.quantityord,
									weberp_purchorderdetails.quantityrecd,
									weberp_purchorderdetails.shiptref,
									weberp_purchorderdetails.completed,
									weberp_purchorderdetails.jobref,
									weberp_purchorderdetails.stdcostunit,
									weberp_stockmaster.controlled,
									weberp_stockmaster.serialised,
									weberp_stockmaster.decimalplaces,
									weberp_purchorderdetails.assetid,
									weberp_purchorderdetails.conversionfactor,
									weberp_purchorderdetails.suppliersunit,
									weberp_purchorderdetails.suppliers_partno
									FROM weberp_purchorderdetails
									LEFT JOIN weberp_stockmaster
									ON weberp_purchorderdetails.itemcode=weberp_stockmaster.stockid
									INNER JOIN weberp_purchorders
									ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
									LEFT JOIN weberp_chartmaster
									ON weberp_purchorderdetails.glcode=weberp_chartmaster.accountcode
									WHERE weberp_purchorderdetails.completed=0
									AND weberp_purchorderdetails.orderno ='" . $_GET['ModifyOrderNumber'] . "'
									ORDER BY podetailitem";

			$ErrMsg =  _('The lines on the purchase order cannot be retrieved because');
			$DbgMsg =  _('The SQL statement that was used to retrieve the purchase order lines was');
			$LineItemsResult = DB_query($LineItemsSQL,$ErrMsg,$DbgMsg);

		  if (DB_num_rows($LineItemsResult) > 0) {

				while ($myrow=DB_fetch_array($LineItemsResult)) {

					 if (is_null($myrow['glcode'])){
						$GLCode = '';
					 } else {
						$GLCode = $myrow['glcode'];
					 }
					if (is_null($myrow['units'])){
						$Units = _('each');
					} else {
						$Units = $myrow['units'];
					}
					if (is_null($myrow['itemcode'])){
						$StockID = '';
					} else {
						$StockID = $myrow['itemcode'];
					}

					$_SESSION['PO'.$identifier]->add_to_order($_SESSION['PO'.$identifier]->LinesOnOrder+1,
															$StockID,
															$myrow['serialised'],
															$myrow['controlled'],
															$myrow['quantityord'],
															stripslashes($myrow['itemdescription']),
															$myrow['unitprice'],
															$Units,
															$GLCode,
															ConvertSQLDate($myrow['deliverydate']),
															$myrow['shiptref'],
															$myrow['completed'],
															$myrow['jobref'],
															$myrow['qtyinvoiced'],
															$myrow['quantityrecd'],
															$myrow['accountname'],
															$myrow['decimalplaces'],
															$myrow['suppliersunit'],
															$myrow['conversionfactor'],
															1,
															$myrow['suppliers_partno'],
															$myrow['assetid'] );

					$_SESSION['PO'.$identifier]->LineItems[$_SESSION['PO'.$identifier]->LinesOnOrder]->PODetailRec = $myrow['podetailitem'];
					$_SESSION['PO'.$identifier]->LineItems[$_SESSION['PO'.$identifier]->LinesOnOrder]->StandardCost = $myrow['stdcostunit'];  /*Needed for receiving goods and GL interface */
			 } /* line PO from purchase order details */
	  } //end is there were lines on the order
   } // end if there was a header for the order
?>
