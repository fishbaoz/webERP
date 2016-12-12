<?php

/* $Id: SelectSalesOrder.php 7651 2016-10-20 07:25:57Z daintree $*/

include('includes/session.inc');
$Title = _('Search Outstanding Sales Orders');
/* webERP manual links before header.inc */
$ViewTopic= "SalesOrders";
$BookMark = "SelectSalesOrder";
include('includes/header.inc');
include('includes/SQL_CommonFunctions.inc');
if (isset($_POST['Reset'])) {
	unset($_POST);
}

if (isset($_GET['SelectedStockItem'])) {
	$SelectedStockItem = $_GET['SelectedStockItem'];
} elseif (isset($_POST['SelectedStockItem'])){
	$SelectedStockItem = $_POST['SelectedStockItem'];
} else {
	unset($SelectedStockItem);
}

if (isset($_GET['SelectedCustomer'])) {
	$SelectedCustomer = $_GET['SelectedCustomer'];
} elseif (isset($_POST['SelectedCustomer'])){
	$SelectedCustomer = $_POST['SelectedCustomer'];
} else {
	unset($SelectedCustomer);
}

if (isset($_POST['PlacePO'])){ /*user hit button to place PO for selected orders */

	/*Note the button would not have been displayed if the user had no authority to create purchase orders */
	$OrdersToPlacePOFor = '';
	for ($i=0;$i<=count($_POST['PlacePO_']);$i++){
		if ($OrdersToPlacePOFor==''){
			$OrdersToPlacePOFor .= " orderno='" . $_POST['PlacePO_'][$i] . "'";
		} else {
			$OrdersToPlacePOFor .= " OR orderno='" . $_POST['PlacePO_'][$i] . "'";
		}
	}
	if (mb_strlen($OrdersToPlacePOFor)==''){
		prnMsg(_('There were no sales orders checked to place purchase orders for. No purchase orders will be created.'),'info');
	} else {
   /*  Now build SQL of items to purchase with purchasing data and preferred suppliers - sorted by preferred supplier */
		$sql = "SELECT weberp_purchdata.supplierno,
						weberp_purchdata.stockid,
						weberp_purchdata.price,
						weberp_purchdata.suppliers_partno,
						weberp_purchdata.supplierdescription,
						weberp_purchdata.conversionfactor,
						weberp_purchdata.leadtime,
						weberp_purchdata.suppliersuom,
						weberp_stockmaster.grossweight,
						weberp_stockmaster.volume,
						weberp_stockcategory.stockact,
						SUM(weberp_salesorderdetails.quantity-weberp_salesorderdetails.qtyinvoiced) AS orderqty
				FROM weberp_purchdata INNER JOIN weberp_salesorderdetails ON
				weberp_purchdata.stockid = weberp_salesorderdetails.stkcode
				INNER JOIN weberp_stockmaster  ON
				weberp_purchdata.stockid = weberp_stockmaster.stockid
				INNER JOIN weberp_stockcategory ON
				weberp_stockmaster.categoryid = weberp_stockcategory.categoryid
				WHERE weberp_purchdata.preferred=1
				AND weberp_purchdata.effectivefrom <='" . Date('Y-m-d') . "'
				AND (" . $OrdersToPlacePOFor . ")
				GROUP BY weberp_purchdata.supplierno,
					weberp_purchdata.stockid,
					weberp_purchdata.price,
					weberp_purchdata.suppliers_partno,
					weberp_purchdata.supplierdescription,
					weberp_purchdata.conversionfactor,
					weberp_purchdata.leadtime,
					weberp_purchdata.suppliersuom,
					weberp_stockmaster.grossweight,
					weberp_stockmaster.volume,
					weberp_stockcategory.stockact
				ORDER BY weberp_purchdata.supplierno,
					 weberp_purchdata.stockid";

		$ErrMsg = _('Unable to retrieve the items on the selected orders for creating purchase orders for');
		$ItemResult = DB_query($sql,$ErrMsg);

		$ItemArray = array();

		while ($myrow = DB_fetch_array($ItemResult)){
			$ItemArray[$myrow['stockid']] = $myrow;
		}

		/* Now figure out if there are any components of Assembly items that  need to be ordered too */
		$sql = "SELECT weberp_purchdata.supplierno,
						weberp_purchdata.stockid,
						weberp_purchdata.price,
						weberp_purchdata.suppliers_partno,
						weberp_purchdata.supplierdescription,
						weberp_purchdata.conversionfactor,
						weberp_purchdata.leadtime,
						weberp_purchdata.suppliersuom,
						weberp_stockmaster.grossweight,
						weberp_stockmaster.volume,
						weberp_stockcategory.stockact,
						SUM(weberp_bom.quantity *(weberp_salesorderdetails.quantity-weberp_salesorderdetails.qtyinvoiced)) AS orderqty
				FROM weberp_purchdata INNER JOIN weberp_bom
				ON weberp_purchdata.stockid=weberp_bom.component
				INNER JOIN weberp_salesorderdetails ON
				weberp_bom.parent=weberp_salesorderdetails.stkcode
				INNER JOIN weberp_stockmaster ON
				weberp_purchdata.stockid = weberp_stockmaster.stockid
				INNER JOIN weberp_stockmaster AS stockmaster2
				ON stockmaster2.stockid=weberp_salesorderdetails.stkcode
				INNER JOIN weberp_stockcategory ON
				weberp_stockmaster.categoryid = weberp_stockcategory.categoryid
				WHERE weberp_purchdata.preferred=1
				AND stockmaster2.mbflag='A'
				AND weberp_bom.loccode ='" . $_SESSION['UserStockLocation'] . "'
				AND weberp_purchdata.effectivefrom <='" . Date('Y-m-d') . "'
				AND weberp_bom.effectiveafter <='" . Date('Y-m-d') . "'
				AND weberp_bom.effectiveto > '" . Date('Y-m-d') . "'
				AND (" . $OrdersToPlacePOFor . ")
				GROUP BY weberp_purchdata.supplierno,
					weberp_purchdata.stockid,
					weberp_purchdata.price,
					weberp_purchdata.suppliers_partno,
					weberp_purchdata.supplierdescription,
					weberp_purchdata.conversionfactor,
					weberp_purchdata.leadtime,
					weberp_purchdata.suppliersuom,
					weberp_stockmaster.grossweight,
					weberp_stockmaster.volume,
					weberp_stockcategory.stockact
				ORDER BY weberp_purchdata.supplierno,
					 weberp_purchdata.stockid";
		$ErrMsg = _('Unable to retrieve the items on the selected orders for creating purchase orders for');
		$ItemResult = DB_query($sql,$ErrMsg);

		/* add any assembly item components from weberp_salesorders to the ItemArray */
		while ($myrow = DB_fetch_array($ItemResult)){
			if (isset($ItemArray[$myrow['stockid']])){
			  /* if the item is already in the ItemArray then just add the quantity to the existing item */
			   $ItemArray[$myrow['stockid']]['orderqty'] += $myrow['orderqty'];
			} else { /*it is not already in the ItemArray so add it */
				$ItemArray[$myrow['stockid']] = $myrow;
			}
		}


		/* We need the items to order to be in supplier order so that only a single order is created for a supplier - so need to sort the multi-dimensional array to ensure it is listed by supplier sequence. To use array_multisort we need to get arrays of supplier with the same keys as the main array of rows
		 */
		$SupplierArray =array();
		foreach ($ItemArray as $key => $row) {
			//to make the Supplier array with the keys of the $ItemArray
			$SupplierArray[$key]  = $row['supplierno'];
		}

		/* Use array_multisort to Sort the ItemArray with supplierno ascending
		Add $ItemArray as the last parameter, to sort by the common key
		*/
		if (count($SupplierArray)>1) {
			array_multisort($SupplierArray, SORT_ASC, $ItemArray);
		}

		if (count($ItemArray)==0){
			prnMsg(_('There might be no supplier purchasing data set up for any items on the selected sales order(s). No purchase orders have been created'),'warn');
		} else {
			/*Now get the default delivery address details from the users default stock location */
			$sql = "SELECT locationname,
							deladd1,
							deladd2,
							deladd3,
							deladd4,
							deladd5,
							deladd6,
							tel,
							contact
						FROM weberp_locations
						INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locations.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canupd=1
						WHERE weberp_locations.loccode = '" .$_SESSION['UserStockLocation']  . "'";
			$ErrMsg = _('The delivery address for the order could not be obtained from the user default stock location');
			$DelAddResult = DB_query($sql,$ErrMsg);
			$DelAddRow = DB_fetch_array($DelAddResult);

			$SupplierID = '';

			if (IsEmailAddress($_SESSION['UserEmail'])){
				$UserDetails  = ' <a href="mailto:' . $_SESSION['UserEmail'] . '">' . $_SESSION['UsersRealName']. '</a>';
			} else {
				$UserDetails  = ' ' . $_SESSION['UsersRealName'] . ' ';
			}

			foreach ($ItemArray as $ItemRow) {

				if ($SupplierID != $ItemRow['supplierno']){
				/* This order item is purchased from a different supplier so need to finish off the authorisation of the previous order and start a new order */

					if ($SupplierID !='' AND $_SESSION['AutoAuthorisePO']==1) {
						/* if an order is/has been created already and the supplier of this item has changed - so need to finish off the order */
						//if the user has authority to authorise the PO then it should be created as authorised
						$AuthSQL ="SELECT authlevel
					 				FROM weberp_purchorderauth
								    WHERE userid='" . $_SESSION['UserID'] . "'
									AND currabrev='" . $SuppRow['currcode'] . "'";

						$AuthResult=DB_query($AuthSQL);
						$AuthRow=DB_fetch_array($AuthResult);
						if ($AuthRow['authlevel']==''){
							$AuthRow['authlevel'] = 0;
						}

						if (DB_num_rows($AuthResult) > 0 AND $AuthRow['authlevel'] > $Order_Value) { //user has authority to authrorise as well as create the order
							$StatusComment = date($_SESSION['DefaultDateFormat']).' - ' . _('Order Created and Authorised by') . ' ' . $UserDetails . ' - '._('Auto created from sales orders')  . '<br />';
							$ErrMsg = _('Could not update purchase order status to Authorised');
							$DbgMsg = _('The SQL that failed was');
							$result = DB_query("UPDATE weberp_purchorders SET allowprint=1,
												   status='Authorised',
												   stat_comment='" . $StatusComment . "'
												WHERE orderno='" . $PO_OrderNo . "'",
												$ErrMsg,
												$DbgMsg,
												true);
						} else { // no authority to authorise this order
							if (DB_num_rows($AuthResult) ==0){
								$AuthMessage = _('Your authority to approve purchase orders in') . ' ' .$SuppRow['currcode'] . ' ' . _('has not yet been set up') . '<br />';
							} else {
								$AuthMessage = _('You can only authorise up to') . ' ' . $SuppRow['currcode'] . ' ' . $AuthRow['authlevel'] . '.<br />';
							}

							prnMsg( _('You do not have permission to authorise this purchase order').'.<br />' .  _('This order is for').' '.
							$SuppRow['currcode'] . ' '. $Order_Value .'. '.
							$AuthMessage . _('If you think this is a mistake please contact the systems administrator') . '<br />' .
							_('The order has been created with a status of pending and will require authorisation'), 'warn');
						}
					} //end of authorisation status settings

					if ($SupplierID !=''){ //then we have just added a purchase order
						echo '<br />';
						prnMsg(_('Purchase Order') . ' ' . $PO_OrderNo . ' ' . _('on') . ' ' . $SupplierID . ' ' . _('has been created'),'success');
						DB_Txn_Commit();
					}

		      /*Starting a new purchase order with a different supplier */
					$result = DB_Txn_Begin();

					$PO_OrderNo =  GetNextTransNo(18, $db); //get the next PO number

					$SupplierID = $ItemRow['supplierno'];
					$Order_Value = 0;
					/*Now get all the required details for the supplier */
					$sql = "SELECT address1,
	 							address2,
	 							address3,
	 							address4,
	 							address5,
	 							address6,
	 							telephone,
	 							paymentterms,
	 							currcode,
	 							rate
						 FROM weberp_suppliers INNER JOIN weberp_currencies
						    ON weberp_suppliers.currcode = weberp_currencies.currabrev
						    WHERE supplierid='" . $SupplierID . "'";

					$ErrMsg = _('Could not get the supplier information for the order');
					$SuppResult = DB_query($sql, $ErrMsg);
					$SuppRow = DB_fetch_array($SuppResult);

					$StatusComment=date($_SESSION['DefaultDateFormat']).' - ' . _('Order Created by') . ' ' . $UserDetails . ' - '._('Auto created from sales orders')  . '<br />';
					/*Insert to purchase order header record */
					$sql = "INSERT INTO weberp_purchorders ( orderno,
		  									  supplierno,
		  									  orddate,
		  									  rate,
		  									  initiator,
		  									  intostocklocation,
		  									  deladd1,
		  									  deladd2,
		  									  deladd3,
		  									  deladd4,
		  									  deladd5,
		  									  deladd6,
		  									  tel,
		  									  suppdeladdress1,
		  									  suppdeladdress2,
		  									  suppdeladdress3,
		  									  suppdeladdress4,
		  									  suppdeladdress5,
		  									  suppdeladdress6,
		  									  supptel,
		  									  version,
		  									  revised,
		  									  deliveryby,
		  									  status,
		  									  stat_comment,
		  									  deliverydate,
		  									  paymentterms,
		  									  allowprint)
		  									VALUES(	'" . $PO_OrderNo . "',
		  										'" . $SupplierID . "',
		  										'" . Date('Y-m-d') . "',
		  										'" . $SuppRow['rate'] . "',
		  										'" . $_SESSION['UserID'] . "',
		  										'" . $_SESSION['UserStockLocation'] . "',
		  										'" . $DelAddRow['locationname'] . "',
		  										'" . $DelAddRow['deladd1'] . "',
		  										'" . $DelAddRow['deladd2'] . "',
		  										'" . $DelAddRow['deladd3'] . "',
		  										'" . $DelAddRow['deladd4'] . "',
		  										'" . $DelAddRow['deladd5'] . ' ' . $DelAddRow['deladd6'] . "',
		  										'" . $DelAddRow['tel'] . "',
		  										'" . $SuppRow['address1'] . "',
		  										'" . $SuppRow['address2'] . "',
		  										'" . $SuppRow['address3'] . "',
		  										'" . $SuppRow['address4'] . "',
		  										'" . $SuppRow['address5'] . "',
		  										'" . $SuppRow['address6'] . "',
		  										'" . $SuppRow['telephone'] . "',
		  										'1.0',
		  										'" . Date('Y-m-d') . "',
		  										'" . $_SESSION['Default_Shipper'] . "',
		  										'Pending',
		  										'" . $StatusComment . "',
		  										'" . Date('Y-m-d') . "',
		  										'" . $SuppRow['paymentterms'] . "',
		  										0)";

					$ErrMsg =  _('The purchase order header record could not be inserted into the database because');
					$DbgMsg = _('The SQL statement used to insert the purchase order header record and failed was');
					$result = DB_query($sql,$ErrMsg,$DbgMsg,true);
				} //end if it's a new supplier and PO to create

				/*reminder we are in a loop of the total of each item to place a purchase order for based on a selection of sales orders */
				$DeliveryDate = DateAdd(Date($_SESSION['DefaultDateFormat']),'d',$ItemRow['leadtime']);
				$sql = "INSERT INTO weberp_purchorderdetails ( orderno,
		      									itemcode,
		      									deliverydate,
		      									itemdescription,
		      									glcode,
		      									unitprice,
		      									quantityord,
		      									suppliersunit,
		      									suppliers_partno,
		      									conversionfactor )
					      VALUES ('" . $PO_OrderNo . "',
		      						     '" . $ItemRow['stockid'] . "',
		      						     '" . FormatDateForSQL($DeliveryDate) . "',
		      						     '" . $ItemRow['suppliers_partno']  . '  ' . $ItemRow['supplierdescription']  . "',
		      						     '" . $ItemRow['stockact'] . "',
		      						     '" . $ItemRow['price'] . "',
		      						     '" . $ItemRow['orderqty'] . "',
		      						     '" . $ItemRow['suppliersuom'] . "',
		      						     '" . $ItemRow['suppliers_partno'] . "',
		      						     '" . $ItemRow['conversionfactor']  . "')";
				$ErrMsg =_('One of the purchase order detail records could not be inserted into the database because');
				$DbgMsg =_('The SQL statement used to insert the purchase order detail record and failed was');

				$result =DB_query($sql,$ErrMsg,$DbgMsg,true);
				$Order_Value  += ($ItemRow['price']*$ItemRow['orderqty']);
			} /* end of the loop round the items on the sales order  that we wish to place purchase orders for */


			/* The last line to be purchase ordered was reach so there will be an order which is not yet completed in progress now to completed it */

			if ($SupplierID !='' AND $_SESSION['AutoAuthorisePO']==1) {
				//if the user has authority to authorise the PO then it should be created as authorised
				$AuthSQL ="SELECT authlevel
							FROM weberp_purchorderauth
							WHERE userid='".$_SESSION['UserID']."'
							AND currabrev='".$SuppRow['currcode']."'";

				$AuthResult=DB_query($AuthSQL);
				$AuthRow=DB_fetch_array($AuthResult);
				if ($AuthRow['authlevel']==''){
				      $AuthRow['authlevel'] = 0;
				}

				if (DB_num_rows($AuthResult) > 0 AND $AuthRow['authlevel'] > $Order_Value) { //user has authority to authrorise as well as create the order
					$StatusComment = date($_SESSION['DefaultDateFormat']).' - ' . _('Order Created and Authorised by') . $UserDetails . ' - '._('Auto created from sales orders')  . '<br />';
					$ErrMsg = _('Could not update purchase order status to Authorised');
					$DbgMsg = _('The SQL that failed was');
					$result = DB_query("UPDATE weberp_purchorders SET allowprint=1,
															status='Authorised',
															stat_comment='" . $StatusComment . "'
												 WHERE orderno='" . $PO_OrderNo . "'",
												$ErrMsg,
												$DbgMsg,
												true);
				} else { // no authority to authorise this order
					if (DB_num_rows($AuthResult) ==0){
						$AuthMessage = _('Your authority to approve purchase orders in') . ' ' .$SuppRow['currcode'] . ' ' . _('has not yet been set up') . '<br />';
					} else {
						$AuthMessage = _('You can only authorise up to').' '.$SuppRow['currcode'].' '.$AuthRow['authlevel'].'.<br />';
					}

					prnMsg( _('You do not have permission to authorise this purchase order').'.<br />' .  _('This order is for').' '. $SuppRow['currcode'] . ' '. $Order_Value .'. '. $AuthMessage . _('If you think this is a mistake please contact the systems administrator') . '<br />' .  _('The order has been created with a status of pending and will require authorisation'), 'warn');
				}
			} //end of authorisation status settings

			if ($SupplierID !=''){ //then we have just added a purchase order irrespective of autoauthorise status
				echo '<br />';
				prnMsg(_('Purchase Order') . ' ' . $PO_OrderNo . ' ' . _('on') . ' ' . $SupplierID . ' ' . _('has been created'),'success');
				DB_Txn_Commit();
			}
			$result = DB_query("UPDATE weberp_salesorders SET poplaced=1 WHERE " . $OrdersToPlacePOFor);
		}/*There were items that had purchasing data set up to create POs for */
	} /* there were sales orders checked to place POs for */
}/*end of purchase order creation code */
/* ******************************************************************************************* */

/*To the sales order selection form */

echo '<p class="page_title_text"><img src="'.$RootPath.'/css/'.$Theme.'/images/sales.png" title="' . _('Sales') . '" alt="" />' . ' ' . _('Outstanding Sales Orders') . '</p> ';

echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') .'" method="post">';
echo '<div>';
echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';


if (isset($_POST['ResetPart'])){
     unset($SelectedStockItem);
}

echo '<br /><div class="centre">';

if (isset($_GET['OrderNumber'])){
	$OrderNumber = $_GET['OrderNumber'];
} elseif (isset($_POST['OrderNumber'])){
	$OrderNumber = $_POST['OrderNumber'];
} else {
	unset($OrderNumber);
}
if (isset($_POST['CustomerRef'])) {
	$CustomerRef = $_POST['CustomerRef'];
}

if (isset($OrderNumber) AND $OrderNumber!='') {
	$OrderNumber = trim($OrderNumber);
	if (!is_numeric($OrderNumber)){
		echo '<br />
			<b>' . _('The Order Number entered MUST be numeric') . '</b>
			<br />';
		unset ($OrderNumber);
		include('includes/footer.inc');
		exit;
	} else {
		echo _('Order Number') . ' - ' . $OrderNumber;
	}
} else {
	if (isset($SelectedCustomer)) {
		echo _('For customer') . ': ' . $SelectedCustomer . ' ' . _('and') . ' ';
		echo '<input type="hidden" name="SelectedCustomer" value="' . $SelectedCustomer . '" />';
	}
	if (isset($SelectedStockItem)) {
		 echo _('for the part') . ': ' . $SelectedStockItem . ' ' . _('and') . ' <input type="hidden" name="SelectedStockItem" value="' . $SelectedStockItem . '" />';
	}
}

if (isset($_POST['SearchParts'])){

	$StockItemsResult = GetSearchItems();

}

if (isset($_POST['StockID'])){
	$StockID = trim(mb_strtoupper($_POST['StockID']));
} elseif (isset($_GET['StockID'])){
	$StockID = trim(mb_strtoupper($_GET['StockID']));
}

if (!isset($StockID)) {

     /* Not appropriate really to restrict search by date since may miss older
     ouststanding orders
	$OrdersAfterDate = Date('d/m/Y',Mktime(0,0,0,Date('m')-2,Date('d'),Date('Y')));
     */

	if (!isset($OrderNumber) OR $OrderNumber==''){

		echo '<table class="selection">
			<tr>
				<td>' . _('Order number') . ': </td>
				<td><input type="text" name="OrderNumber" maxlength="8" size="9" /></td>
				<td>' . _('From Stock Location') . ':</td>
				<td><select name="StockLocation"> ';

		$sql = "SELECT weberp_locations.loccode, locationname, canview FROM weberp_locations
					INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_locations.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canview=1";
		$resultStkLocs = DB_query($sql);

		while ($myrow=DB_fetch_array($resultStkLocs)){
			if (isset($_POST['StockLocation'])){
				if ($myrow['loccode'] == $_POST['StockLocation']){
				     echo '<option selected="selected" value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
				} else {
				     echo '<option value="' . $myrow['loccode'] . '">' . $myrow['locationname']. '</option>';
				}
			} elseif ($myrow['loccode']==$_SESSION['UserStockLocation']){
				 echo '<option selected="selected" value="' . $myrow['loccode'] . '">' . $myrow['locationname']. '</option>';
			} else {
				 echo '<option value="' . $myrow['loccode'] . '">' . $myrow['locationname']. '</option>';
			}
		}

		echo '</select></td>
			<td><select name="Quotations">';

		if (isset($_GET['Quotations']) AND $_GET['Quotations']=='Quotes_Only'){
			$_POST['Quotations']='Quotes_Only';
		}

		if (isset($_POST['Quotations']) AND $_POST['Quotations']=='Quotes_Only'){
			echo '<option selected="selected" value="Quotes_Only">' . _('Quotations Only') . '</option>';
			echo '<option value="Orders_Only">' . _('Orders Only')  . '</option>';
			echo '<option value="Overdue_Only">' . _('Overdue Only') . '</option>';
		} elseif (isset($_POST['Quotations']) AND $_POST['Quotations'] == 'Overdue_Only'){
			echo '<option selected="selected" value="Overdue_Only">' . _('Overdue Only') . '</option>';
			echo '<option value="Quotes_Only">' . _('Quotations Only') . '</option>';
			echo '<option value="Orders_Only">' . _('Orders Only') . '</option>';
		} else {
			echo '<option selected="selected" value="Orders_Only">' . _('Orders Only') . '</option>';
			echo '<option value="Quotes_Only">' . _('Quotations Only') . '</option>';
			echo '<option value="Overdue_Only">' . _('Overdue Only') . '</option>';
		}
		if (!isset($_POST['DueDateFrom'])) {
			$_POST['DueDateFrom'] = '';
		}
		if (!isset($_POST['DueDateTo'])) {
			$_POST['DueDateTo'] = '';
		}
		if (!isset($_POST['CustomerRef'])) {
			$_POST['CustomerRef'] = '';
		}
		if (!isset($_POST['OrderDateFrom'])) {
			$_POST['OrderDateFrom'] = '';
		}
		if (!isset($_POST['OrderDateTo'])) {
			$_POST['OrderDateTo'] = '';
		}


		echo '</select> </td>
			<td>' . _('Due Date From') . '</td>
			<td><input type="text" class="date" name="DueDateFrom" value="' . $_POST['DueDateFrom'] . '" alt="' . $_SESSION['DefaultDateFormat'] . '" size="10" /></td>
			<td>' . _('Due Date To') . '</td>
			<td><input type="text" class="date" name="DueDateTo" value="' . $_POST['DueDateTo'] . '" alt="' . $_SESSION['DefaultDateFormat'] . '" size="10" /></td>
				<td><input type="submit" name="SearchOrders" value="' . _('Search') . '" /></td>
				<td><input type="submit" name="Reset" value="' . _('Reset') . '" /></td>
				<td><a href="' . $RootPath . '/SelectOrderItems.php?NewOrder=Yes">' . _('Add Sales Order') . '</a></td>
			</tr>
			<tr>
				<td>' . _('Customer Ref') . '</td>
				<td><input type="text" name="CustomerRef" value="' . $_POST['CustomerRef'] . '" size="12" /></td>
				<td>' . _('Order Date From') . '</td>
				<td><input type="text" name="OrderDateFrom" value="' . $_POST['OrderDateFrom'] . '" size="10" class="date" alt="' . $_SESSION['DefaultDateFormat'] . '" /></td>
				<td>' . _('Order Date To') . '</td>
				<td><input type="text" name="OrderDateTo" value="' . $_POST['OrderDateTo'] . '" size="10" class="date" alt="' . $_SESSION['DefaultDateFormat'] . '" /></td>
			</tr>
			</table>';
	}

	$SQL="SELECT categoryid,
			categorydescription
		FROM weberp_stockcategory
		ORDER BY categorydescription";

	$result1 = DB_query($SQL);

	echo '<br />
		<table class="selection">
		<tr>
			<th colspan="6"><h3>' . _('To search for sales orders for a specific part use the part selection facilities below') . '</h3></th>
		</tr>
		<tr>
      		<td>' . _('Select a stock category') . ':
      			<select name="StockCat">';
		echo '<option value="All">' . _('All') . '</option>';

	while ($myrow1 = DB_fetch_array($result1)) {
		echo '<option value="'. $myrow1['categoryid'] . '">' . $myrow1['categorydescription'] . '</option>';
	}

	echo '</select></td>
			<td>' . _('Enter text extract(s) in the description') . ':</td>
			<td><input type="text" name="Keywords" size="20" maxlength="25" /></td>
		</tr>
      	<tr>
			<td></td>
      		<td><b>' . _('OR') . ' </b>' . _('Enter extract of the Stock Code') . ':</td>
      		<td><input type="text" name="StockCode" size="15" maxlength="18" /></td>
      	</tr>
      </table>';
	echo '<br />
			<input type="submit" name="SearchParts" value="' . _('Search Parts Now') . '" />
			<input type="submit" name="ResetPart" value="' . _('Show All') . '" />
		</div>
		<br />';

if (isset($StockItemsResult)
	AND DB_num_rows($StockItemsResult)>1) {

	echo '<table cellpadding="2" class="selection">';
	echo '<tr>
			<th class="ascending" >' . _('Code') . '</th>
			<th class="ascending" >' . _('Description') . '</th>
			<th class="ascending" >' . _('On Hand') . '</th>
			<th>' . _('Units') . '</th>
		</tr>';

	$k=0; //row colour counter

	while ($myrow=DB_fetch_array($StockItemsResult)) {

		if ($k==1){
			echo '<tr class="EvenTableRows">';
			$k=0;
		} else {
			echo '<tr class="OddTableRows">';
			$k++;
		}

		printf('<td><input type="submit" name="SelectedStockItem" value="%s" /></td>
				<td>%s</td>
				<td class="number">%s</td>
				<td>%s</td>
				</tr>',
				$myrow['stockid'],
				$myrow['description'],
				locale_number_format($myrow['qoh'],$myrow['decimalplaces']),
				$myrow['units']);
//end of page full new headings if
	}
//end of while loop

	echo '</table>';

}
//end if stock search results to show
  else {
	 if (isset($StockItemsResult) AND DB_num_rows($StockItemsResult) == 1) {
		 $mystkrow = DB_fetch_array($StockItemsResult);
		 $SelectedStockItem = $mystkrow['stockid'];
	 }

	//figure out the SQL required from the inputs available
	if (isset($_POST['Quotations']) AND $_POST['Quotations']=='Orders_Only'){
		$Quotations = 0;
	} elseif(isset($_POST['Quotations']) AND $_POST['Quotations'] == 'Quotations_Only') {
		$Quotations =1;
	} elseif(isset($_POST['Quotations']) AND $_POST['Quotations'] == 'Overdue_Only') {
		$Quotations = "0 AND itemdue<'" . Date('Y-m-d') . "'";
	} else {
		$Quotations = 0;
	}
	if (isset($_POST['DueDateFrom']) AND is_date($_POST['DueDateFrom'])) {
		$DueDateFrom = " AND itemdue>='"  . FormatDateForSQL($_POST['DueDateFrom']) . "' ";
	} else {
		$DueDateFrom = '';
	}
	if (isset($_POST['DueDateTo']) AND is_date($_POST['DueDateTo'])) {
		$DueDateTo = " AND itemdue<='" . FormatDateForSQL($_POST['DueDateTo']) . "'";
	} else {
		$DueDateTo = '';
	}
	if (isset($_POST['OrderDateFrom']) AND is_date($_POST['OrderDateFrom'])) {
		$OrderDateFrom = " AND orddate >='" . FormatDateForSQL($_POST['OrderDateFrom']) . "' ";
	} else {
		$OrderDateFrom = '';
	}
	if (isset($_POST['OrderDateTo']) AND is_date($_POST['OrderDateTo'])) {
		$OrderDateTo = " AND orddate <='" . FormatDateForSQL($_POST['OrderDateTo']) . "' ";
	} else {
		$OrderDateTo = '';
	}

	if(!isset($_POST['StockLocation'])) {
		$_POST['StockLocation'] = '';
	}
	//Harmonize the ordervalue with SUM function since webERP allowed same items appeared several times in one sales orders. If there is no sum value, this situation not inclued.
	//We should separate itemdue inquiry from normal inquiry.
	if (($Quotations === 0 OR $Quotations === 1)
		AND (!isset($DueDateFrom) OR !is_date($DueDateFrom))
		AND (!isset($DueDateTo) OR !is_date($DueDateTo))) {

			$SQL = "SELECT weberp_salesorders.orderno,
					weberp_debtorsmaster.name,
					weberp_custbranch.brname,
					weberp_salesorders.customerref,
					weberp_salesorders.orddate,
					weberp_salesorders.deliverydate,
					weberp_salesorders.deliverto,
					weberp_salesorders.printedpackingslip,
					weberp_salesorders.poplaced,
					SUM(weberp_salesorderdetails.unitprice*(weberp_salesorderdetails.quantity-weberp_salesorderdetails.qtyinvoiced)*(1-weberp_salesorderdetails.discountpercent)/weberp_currencies.rate) AS ordervalue
				FROM weberp_salesorders INNER JOIN weberp_salesorderdetails
					ON weberp_salesorders.orderno = weberp_salesorderdetails.orderno
					INNER JOIN weberp_debtorsmaster
					ON weberp_salesorders.debtorno = weberp_debtorsmaster.debtorno
					INNER JOIN weberp_custbranch
					ON weberp_debtorsmaster.debtorno = weberp_custbranch.debtorno
					AND weberp_salesorders.branchcode = weberp_custbranch.branchcode
					INNER JOIN weberp_currencies
					ON weberp_debtorsmaster.currcode = weberp_currencies.currabrev
					WHERE weberp_salesorderdetails.completed=0 ";
			$SQL .= $OrderDateFrom . $OrderDateTo;
		} else {
			if ($Quotations !==0 AND $Quotations !==1) {//overdue inquiry only
				$SQL = "SELECT weberp_salesorders.orderno,
						weberp_debtorsmaster.name,
						weberp_custbranch.brname,
						weberp_salesorders.customerref,
						weberp_salesorders.orddate,
						weberp_salesorders.deliverydate,
						weberp_salesorders.deliverto,
						weberp_salesorders.printedpackingslip,
						weberp_salesorders.poplaced,
						SUM(CASE WHEN itemdue<'" . Date('Y-m-d') . "'
						     THEN weberp_salesorderdetails.unitprice*(weberp_salesorderdetails.quantity-weberp_salesorderdetails.qtyinvoiced)*(1-weberp_salesorderdetails.discountpercent)/weberp_currencies.rate
						     ELSE 0 END) as ordervalue";
			} elseif (isset($DueDateFrom) AND is_date($DueDateFrom) AND (!isset($DueDateTo) OR !is_date($DueDateTo))) {
					$SQL = "SELECT weberp_salesorders.orderno,
						weberp_debtorsmaster.name,
						weberp_custbranch.brname,
						weberp_salesorders.customerref,
						weberp_salesorders.orddate,
						weberp_salesorders.deliverydate,
						weberp_salesorders.deliverto,
						weberp_salesorders.printedpackingslip,
						weberp_salesorders.poplaced,
						SUM(CASE WHEN itemdue>='" . FormatDateFromSQL($DueDateFrom) . "'
						     THEN weberp_salesorderdetails.unitprice*(weberp_salesorderdetails.quantity-weberp_salesorderdetails.qtyinvoiced)*(1-weberp_salesorderdetails.discountpercent)/weberp_currencies.rate
						     ELSE 0 END) as ordervalue";
			} elseif (isset($DueDateFrom) AND is_date($DueDateFrom) AND isset($DueDateTo) AND is_date($DueDateTo)) {
					$SQL = "SELECT weberp_salesorders.orderno,
						weberp_debtorsmaster.name,
						weberp_custbranch.brname,
						weberp_salesorders.customerref,
						weberp_salesorders.orddate,
						weberp_salesorders.deliverydate,
						weberp_salesorders.deliverto,
						weberp_salesorders.printedpackingslip,
						weberp_salesorders.poplaced,
						SUM (CASE WHEN itemdue>='" . FormatDateForSQL($DueDateFrom) . "' AND itemdue<='" . FormatDateForSQL($DueDateTo) ."'
						     THEN weberp_salesorderdetails.unitprice*(weberp_salesorderdetails.quantity-weberp_salesorderdetails.qtyinvoiced)*(1-weberp_salesorderdetails.discountpercent)/weberp_currencies.rate
						     ELSE 0 END) as ordervalue";
			} elseif ((!isset($DueDateFrom) OR !is_date($DueDateFrom)) AND isset($DueDateTo) AND is_date($DueDateTo)) {
						$SQL = "SELECT weberp_salesorders.orderno,
						weberp_debtorsmaster.name,
						weberp_custbranch.brname,
						weberp_salesorders.customerref,
						weberp_salesorders.orddate,
						weberp_salesorders.deliverydate,
						weberp_salesorders.deliverto,
						weberp_salesorders.printedpackingslip,
						weberp_salesorders.poplaced,
						SUM(CASE WHEN AND itemdue<='" . FormatDateForSQL($DueDateTo) ."'
						     THEN weberp_salesorderdetails.unitprice*(weberp_salesorderdetails.quantity-weberp_salesorderdetails.qtyinvoiced)*(1-weberp_salesorderdetails.discountpercent)/weberp_currencies.rate
						     ELSE 0 END) as ordervalue";
			}//end of due date inquiry
				$SQL .= $OrderDateFrom . $OrderDateTo;


				$SQL .=" FROM weberp_salesorders INNER JOIN weberp_salesorderdetails
						ON weberp_salesorders.orderno = weberp_salesorderdetails.orderno
						INNER JOIN weberp_debtorsmaster
						ON weberp_salesorders.debtorno = weberp_debtorsmaster.debtorno
						INNER JOIN weberp_custbranch
						ON weberp_debtorsmaster.debtorno = weberp_custbranch.debtorno
						AND weberp_salesorders.branchcode = weberp_custbranch.branchcode
						INNER JOIN weberp_currencies
						ON weberp_debtorsmaster.currcode = weberp_currencies.currabrev
						WHERE weberp_salesorderdetails.completed=0 ";
		}

		//Add salesman role control
			if ($_SESSION['SalesmanLogin'] != '') {
				$SQL .= " AND weberp_salesorders.salesperson='" . $_SESSION['SalesmanLogin'] . "'";
			}

			if (isset($OrderNumber)
				AND $OrderNumber !='') {

				$SQL .= "AND weberp_salesorders.orderno=". $OrderNumber ."
				    AND weberp_salesorders.quotation=" .$Quotations;

			} elseif (isset($CustomerRef) AND $CustomerRef != ''){
				$SQL .= "AND weberp_salesorders.customerref='" . $CustomerRef . "'
					AND weberp_salesorders.quotation=" . $Quotations;

			} else {
	      			/* $DateAfterCriteria = FormatDateforSQL($OrdersAfterDate); */

				if (isset($SelectedCustomer)) {

					if (isset($SelectedStockItem)) {
						$SQL .= "AND weberp_salesorders.quotation =" .$Quotations . "
							AND weberp_salesorderdetails.stkcode='". $SelectedStockItem ."'
							AND weberp_salesorders.debtorno='" . $SelectedCustomer ."'
							AND weberp_salesorders.fromstkloc = '". $_POST['StockLocation'] . "'";

					} else {
						$SQL .= "AND  weberp_salesorders.quotation =" .$Quotations . "
							AND weberp_salesorders.debtorno='" . $SelectedCustomer . "'
							AND weberp_salesorders.fromstkloc = '". $_POST['StockLocation'] . "'";

					}
				} else { //no customer selected
					if (isset($SelectedStockItem)) {
							$SQL .= "AND weberp_salesorders.quotation =" .$Quotations . "
								AND weberp_salesorderdetails.stkcode='". $SelectedStockItem . "'
								AND weberp_salesorders.fromstkloc = '". $_POST['StockLocation'] . "'";
					} else {
							$SQL .= "AND weberp_salesorders.quotation =" .$Quotations . "
								AND weberp_salesorders.fromstkloc = '". $_POST['StockLocation'] . "'";
					}

				} //end selected customer
				$SQL .= $DueDateFrom . $DueDateTo;

				$SQL .= ' GROUP BY weberp_salesorders.orderno,
							weberp_debtorsmaster.name,
							weberp_custbranch.brname,
							weberp_salesorders.customerref,
							weberp_salesorders.orddate,
							weberp_salesorders.deliverydate,
							weberp_salesorders.deliverto,
							weberp_salesorders.printedpackingslip,
							weberp_salesorders.poplaced
							ORDER BY weberp_salesorders.orderno';
			} //end not order number selected

	$ErrMsg = _('No orders or quotations were returned by the SQL because');
	$SalesOrdersResult = DB_query($SQL,$ErrMsg);

	/*show a table of the orders returned by the SQL */
	if (DB_num_rows($SalesOrdersResult)>0) {

		/* Get users authority to place POs */
		$AuthSQL="SELECT cancreate
					FROM weberp_purchorderauth
					WHERE userid='". $_SESSION['UserID'] . "'";

		/*we don't know what currency these orders might be in but if no authority at all then don't show option*/
		$AuthResult=DB_query($AuthSQL);

		$AuthRow=DB_fetch_array($AuthResult);

		echo '<table cellpadding="2" width="95%" class="selection">';

		if (isset($_POST['Quotations']) AND ($_POST['Quotations']=='Orders_Only' OR $_POST['Quotations'] == 'Overdue_Only')){
			$TableHeader = '<tr>
								<th class="ascending" >' . _('Modify') . '</th>
								<th>' . _('Invoice') . '</th>
								<th>' . _('Dispatch Note') . '</th>
								<th class="ascending" >' . _('Customer') . '</th>
								<th class="ascending" >' . _('Branch') . '</th>
								<th class="ascending" >' . _('Cust Order') . ' #</th>
								<th class="ascending" >' . _('Order Date') . '</th>
								<th class="ascending" >' . _('Req Del Date') . '</th>
								<th class="ascending" >' . _('Delivery To') . '</th>
								<th class="ascending" >' . _('Order Total') . '<br />' . $_SESSION['CompanyRecord']['currencydefault'] . '</th>';

			if ($AuthRow['cancreate']==0){ //If cancreate==0 then this means the user can create orders hmmm!!
				$TableHeader .= '<th>' . _('Place PO') . '</th></tr>';
			} else {
				$TableHeader .= '</tr>';
			}
		} else {  /* displaying only quotations */
			$TableHeader = '<tr>
								<th>' . _('Modify') . '</th>
								<th>' . _('Print Quote') . '</th>
								<th class="ascending" >' . _('Customer') . '</th>
								<th class="ascending" >' . _('Branch') . '</th>
								<th class="ascending" >' . _('Cust Ref') . ' #</th>
								<th class="ascending" >' . _('Quote Date') . '</th>
								<th class="ascending" >' . _('Req Del Date') . '</th>
								<th class="ascending" >' . _('Delivery To') . '</th>
								<th class="ascending" >' . _('Quote Total') .  '<br />' . $_SESSION['CompanyRecord']['currencydefault'] . '</th>
							</tr>';
		}

		echo $TableHeader;

		$i = 1;
		  $j = 1;
		$k=0; //row colour counter
		$OrdersTotal =0;

		while ($myrow=DB_fetch_array($SalesOrdersResult)) {


			if ($k==1){
				echo '<tr class="EvenTableRows">';
				$k=0;
			} else {
				echo '<tr class="OddTableRows">';
				$k++;
			}

			$ModifyPage = $RootPath . '/SelectOrderItems.php?ModifyOrderNumber=' . $myrow['orderno'];
			$Confirm_Invoice = $RootPath . '/ConfirmDispatch_Invoice.php?OrderNumber=' .$myrow['orderno'];

			if ($_SESSION['PackNoteFormat']==1){ /*Laser printed A4 default */
				$PrintDispatchNote = $RootPath . '/PrintCustOrder_generic.php?TransNo=' . $myrow['orderno'];
			} else { /*pre-printed stationery default */
				$PrintDispatchNote = $RootPath . '/PrintCustOrder.php?TransNo=' . $myrow['orderno'];
			}
			$PrintQuotation = $RootPath . '/PDFQuotation.php?QuotationNo=' . $myrow['orderno'];
			$PrintQuotationPortrait = $RootPath . '/PDFQuotationPortrait.php?QuotationNo=' . $myrow['orderno'];
			$FormatedDelDate = ConvertSQLDate($myrow['deliverydate']);
			$FormatedOrderDate = ConvertSQLDate($myrow['orddate']);
			$FormatedOrderValue = locale_number_format($myrow['ordervalue'],$_SESSION['CompanyRecord']['decimalplaces']);
			if ($myrow['customerref'] !== '') {
				$CustomerRef = '<a href="' . $RootPath . '/SelectCompletedOrder.php?CustomerRef=' . $myrow['customerref'] . '" target="_blank">' . $myrow['customerref'] . '</a>';
			} else {
				$CustomerRef = '';
			}

			if ($myrow['printedpackingslip']==0) {
			  $PrintText = _('Print');
			} else {
			  $PrintText = _('Reprint');
			}

			if ($_POST['Quotations']=='Orders_Only' OR $_POST['Quotations']=='Overdue_Only'){

			 /*Check authority to create POs if user has authority then show the check boxes to select sales orders to place POs for otherwise don't provide this option */
				if ($AuthRow['cancreate']==0 AND $myrow['poplaced']==0){ //cancreate==0 if the user can create POs and not already placed
					printf('<td><a href="%s">%s</a></td>
							<td><a href="%s">' . _('Invoice') . '</a></td>
		 				<td><a target="_blank" href="%s">' . $PrintText . ' <img src="' .$RootPath.'/css/'.$Theme.'/images/pdf.png" title="' . _('Click for PDF') . '" alt="" /></a></td>
		 				<td>%s</td>
		 				<td>%s</td>
		 				<td>%s</td>
		 				<td>%s</td>
		 				<td>%s</td>
		 				<td>%s</td>
		 				<td class="number">%s</td>
		 				<td><input type="checkbox" name="PlacePO_[]" value="%s"/></td>
		 				</tr>',
		 				$ModifyPage,
		 				$myrow['orderno'],
						$Confirm_Invoice,
		 				$PrintDispatchNote,
		 				$myrow['name'],
		 				$myrow['brname'],
		 				$CustomerRef,
		 				$FormatedOrderDate,
		 				$FormatedDelDate,
		 				html_entity_decode($myrow['deliverto'],ENT_QUOTES,'UTF-8'),
		 				$FormatedOrderValue,
						$myrow['orderno']);
				} else {  /*User is not authorised to create POs so don't even show the option */
					printf('<td><a href="%s">%s</a></td>
							<td><a href="%s">' . _('Invoice') . '</a></td>
							<td><a target="_blank" href="%s">' . $PrintText . ' <img src="' .$RootPath . '/css/' . $Theme .'/images/pdf.png" title="' . _('Click for PDF') . '" alt="" /></a></td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td>%s</td>
							<td class="number">%s</td>
							</tr>',
							$ModifyPage,
							$myrow['orderno'],
							$Confirm_Invoice,
							$PrintDispatchNote,
							$myrow['name'],
							$myrow['brname'],
							$myrow['customerref'],
							$FormatedOrderDate,
							$FormatedDelDate,
							html_entity_decode($myrow['deliverto'],ENT_QUOTES,'UTF-8'),
							$FormatedOrderValue);
				}

			} else { /*must be quotes only */
				printf('<td><a href="%s">%s</a></td>
						<td><a target="_blank" href="%s">' . _('Landscape') . '</a>&nbsp;&nbsp;<a target="_blank" href="%s">' . _('Portrait') . '</a></td>
						<td>%s</td>
						<td>%s</td>
						<td>%s</td>
						<td>%s</td>
						<td>%s</td>
						<td>%s</td>
						<td class="number">%s</td>
						</tr>',
						$ModifyPage,
						$myrow['orderno'],
						$PrintQuotation,
						$PrintQuotationPortrait,
						$myrow['name'],
						$myrow['brname'],
						$myrow['customerref'],
						$FormatedOrderDate,
						$FormatedDelDate,
						html_entity_decode($myrow['deliverto'],ENT_QUOTES,'UTF-8'),
						$FormatedOrderValue);
			}
			$i++;
			$OrdersTotal += $myrow['ordervalue'];
		//end of page full new headings if
		}//end while loop through orders to display

		if ($_POST['Quotations']=='Orders_Only'
			AND $AuthRow['cancreate']==0){ //cancreate==0 means can create POs

			echo '<tfoot>
					<tr>
						<td colspan="11" class="number"><input type="submit" name="PlacePO" value="' . _('Place') . " " . _('PO') . '" onclick="return confirm(\'' . _('This will create purchase orders for all the items on the checked sales orders above, based on the preferred supplier purchasing data held in the system. Are You Absolutely Sure?') . '\');" /></td>
					</tr>
				</tfoot>';
		}
		echo '<tfoot><tr><td colspan="9" class="number">';
		if ($_POST['Quotations']=='Orders_Only'){
			echo '<b>' . _('Total Order(s) Value in');
		} else {
			echo '<b>' . _('Total Quotation(s) Value in');
		}
		echo ' ' . $_SESSION['CompanyRecord']['currencydefault'] . ' :</b></td>
			<td class="number"><b>' . locale_number_format($OrdersTotal,$_SESSION['CompanyRecord']['decimalplaces']) . '</b></td>
			</tr></tfoot>
			</table>';
	} //end if there are some orders to show
}

echo '</div>
      </form>';

} //end StockID already selected

include('includes/footer.inc');
function GetSearchItems ($SQLConstraint='') {
	global $db;
	if ($_POST['Keywords'] AND $_POST['StockCode']) {
		 echo _('Stock description keywords have been used in preference to the Stock code extract entered');
	}
	$SQL =  "SELECT weberp_stockmaster.stockid,
				   weberp_stockmaster.description,
				   weberp_stockmaster.decimalplaces,
				   SUM(weberp_locstock.quantity) AS qoh,
				   weberp_stockmaster.units
			FROM weberp_salesorderdetails INNER JOIN weberp_stockmaster
				ON weberp_salesorderdetails.stkcode = weberp_stockmaster.stockid AND completed=0
			INNER JOIN weberp_locstock
			  ON weberp_stockmaster.stockid=weberp_locstock.stockid";
	if (isset($_POST['StockCat'])
		AND ((trim($_POST['StockCat']) == '') OR $_POST['StockCat'] == 'All')){
		 $WhereStockCat = '';
	} else {
		 $WhereStockCat = " AND weberp_stockmaster.categoryid='" . $_POST['StockCat'] . "' ";
	}
	if ($_POST['Keywords']) {
		 //insert wildcard characters in spaces
		 $SearchString = '%' . str_replace(' ', '%', $_POST['Keywords']) . '%';

		 $SQL .= " WHERE weberp_stockmaster.description " . LIKE . " '" . $SearchString . "'
			  " . $WhereStockCat ;


	 } elseif (isset($_POST['StockCode'])){
		 $SQL .= " WHERE weberp_stockmaster.stockid " . LIKE . " '%" . $_POST['StockCode'] . "%'" . $WhereStockCat;

	 } elseif (!isset($_POST['StockCode']) AND !isset($_POST['Keywords'])) {
		 $SQL .= " WHERE weberp_stockmaster.categoryid='" . $_POST['StockCat'] ."'";

	 }
	$SQL .= $SQLConstraint;
	$SQL .= " GROUP BY weberp_stockmaster.stockid,
					    weberp_stockmaster.description,
					    weberp_stockmaster.decimalplaces,
					    weberp_stockmaster.units
					    ORDER BY weberp_stockmaster.stockid";

	$ErrMsg =  _('No stock items were returned by the SQL because');
	$DbgMsg = _('The SQL used to retrieve the searched parts was');
	$StockItemsResult = DB_query($SQL,$ErrMsg,$DbgMsg);
	return $StockItemsResult;

}
?>
