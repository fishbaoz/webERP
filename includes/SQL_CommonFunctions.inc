<?php

/* $Id: SQL_CommonFunctions.inc 7618 2016-09-12 02:35:30Z exsonqu $*/

/* Common SQL Functions */


Function GetNextTransNo ($TransType, &$db){

/* SQL to get the next transaction number these are maintained in the table SysTypes - Transaction Types
Also updates the transaction number

10 sales invoice
11 sales credit note
12 sales receipt
etc
*
*/
	DB_query("SELECT typeno FROM weberp_systypes WHERE typeid='" . $TransType ."' FOR UPDATE");
	$SQL = "UPDATE weberp_systypes SET typeno = typeno + 1 WHERE typeid = '" . $TransType . "'";
	$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The transaction number could not be incremented');
	$DbgMsg =  _('The following SQL to increment the transaction number was used');
	$UpdTransNoResult = DB_query($SQL,$ErrMsg,$DbgMsg);
	$SQL = "SELECT typeno FROM weberp_systypes WHERE typeid= '" . $TransType . "'";
	$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': <BR>' . _('The next transaction number could not be retrieved from the database because');
	$DbgMsg =  _('The following SQL to retrieve the transaction number was used');
	$GetTransNoResult = DB_query($SQL,$ErrMsg,$DbgMsg);
	$myrow = DB_fetch_row($GetTransNoResult);
	return $myrow[0];
	
}


Function GetStockGLCode ($StockID, &$db){

/*Gets the GL Codes relevant to the stock item account from the stock category record */
	$QuerySQL = "SELECT stockact,
						adjglact,
						issueglact,
						purchpricevaract,
						materialuseagevarac,
						wipact
				FROM weberp_stockmaster INNER JOIN weberp_stockcategory
				ON weberp_stockmaster.categoryid=weberp_stockcategory.categoryid
				WHERE weberp_stockmaster.stockid = '" . $StockID . "'";

	$ErrMsg =  _('The stock GL codes could not be retrieved because');
	$GetStkGLResult = DB_query($QuerySQL, $ErrMsg);

	$myrow = DB_fetch_array($GetStkGLResult);
	return $myrow;
}

Function GetTaxRate ($TaxAuthority, $DispatchTaxProvince, $TaxCategory, &$db){

/*Gets the Tax rate applicable to an item from the TaxAuthority of the branch and TaxLevel of the item */

	$QuerySQL = "SELECT taxrate
				FROM weberp_taxauthrates
				WHERE taxauthority='" . $TaxAuthority . "'
				AND dispatchtaxprovince='" . $DispatchTaxProvince . "'
				AND taxcatid = '" . $TaxCategory . "'";

	$ErrMsg = _('The tax rate for this item could not be retrieved because');
	$GetTaxRateResult = DB_query($QuerySQL,$ErrMsg);

	if (DB_num_rows($GetTaxRateResult)==1){
		$myrow = DB_fetch_row($GetTaxRateResult);
		return $myrow[0];
	} else {
		/*The tax rate is not defined for this Tax Authority and Dispatch Tax Authority */
		return 0;
	}

}

Function GetTaxes ($TaxGroup, $DispatchTaxProvince, $TaxCategory, &$db) {

	$SQL = "SELECT weberp_taxgrouptaxes.calculationorder,
					weberp_taxauthorities.description,
					weberp_taxgrouptaxes.taxauthid,
					weberp_taxauthorities.taxglcode,
					weberp_taxgrouptaxes.taxontax,
					weberp_taxauthrates.taxrate
			FROM weberp_taxauthrates INNER JOIN weberp_taxgrouptaxes ON
				weberp_taxauthrates.taxauthority=weberp_taxgrouptaxes.taxauthid
				INNER JOIN weberp_taxauthorities ON
				weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid
			WHERE weberp_taxgrouptaxes.taxgroupid='" . $TaxGroup . "'
			AND weberp_taxauthrates.dispatchtaxprovince='" . $DispatchTaxProvince . "'
			AND weberp_taxauthrates.taxcatid = '" . $TaxCategory . "'
			ORDER BY weberp_taxgrouptaxes.calculationorder";


	$ErrMsg = _('The taxes and rate for this tax group could not be retrieved because');
	$GetTaxesResult = DB_query($SQL,$ErrMsg);

	if (DB_num_rows($GetTaxesResult)>=1){
		return $GetTaxesResult;
	} else {
		/*The tax group is not defined with rates */
		return 0;
	}
}



Function GetCreditAvailable($DebtorNo,&$db) {

	$sql = "SELECT weberp_debtorsmaster.debtorno,
			weberp_debtorsmaster.creditlimit,
			SUM(weberp_debtortrans.ovamount + weberp_debtortrans.ovgst + weberp_debtortrans.ovfreight + weberp_debtortrans.ovdiscount - weberp_debtortrans.alloc) as balance
		FROM weberp_debtorsmaster INNER JOIN weberp_debtortrans
			ON weberp_debtorsmaster.debtorno=weberp_debtortrans.debtorno
		WHERE weberp_debtorsmaster.debtorno='" . $DebtorNo . "'
		GROUP BY weberp_debtorsmaster.debtorno,
			weberp_debtorsmaster.creditlimit";

	$ErrMsg =  _('The current account balance of the customer could not be retrieved because');
	$GetAccountBalanceResult = DB_query($sql, $ErrMsg);

	if (DB_num_rows($GetAccountBalanceResult)==1){

		$myrow = DB_fetch_array($GetAccountBalanceResult);
		$CreditAvailable = $myrow['creditlimit'] - $myrow['balance'];
	} else {
		$sql = "SELECT creditlimit
				FROM weberp_debtorsmaster
				WHERE debtorno='" . $DebtorNo . "'";
		$GetAccountBalanceResult = DB_query($sql, $ErrMsg);
		$myrow = DB_fetch_array($GetAccountBalanceResult);
		$CreditAvailable = $myrow['creditlimit'];
	}
	/*Take into account the value of outstanding sales orders too */
	$sql = "SELECT SUM(weberp_salesorderdetails.unitprice *
				(weberp_salesorderdetails.quantity - weberp_salesorderdetails.qtyinvoiced) *
				(1 - weberp_salesorderdetails.discountpercent)) AS ordervalue
				FROM weberp_salesorders INNER JOIN weberp_salesorderdetails
				ON weberp_salesorders.orderno = weberp_salesorderdetails.orderno
				WHERE weberp_salesorders.debtorno = '" . $DebtorNo . "'
				AND weberp_salesorderdetails.completed = 0
				AND weberp_salesorders.quotation = 0";

	$ErrMsg =  _('The value of outstanding orders for the customer could not be retrieved because');
	$GetOSOrdersResult = DB_query($sql, $ErrMsg);

	$myrow = DB_fetch_array($GetOSOrdersResult);
	$CreditAvailable -= $myrow['ordervalue'];

	return $CreditAvailable;
}

function ItemCostUpdateGL($db, $StockID, $NewCost, $OldCost, $QOH) {
	if ($_SESSION['CompanyRecord']['gllink_stock']==1 
		AND $QOH!=0
		AND (abs($NewCost - $OldCost) > pow(10,-($_SESSION['StandardCostDecimalPlaces']+1)))){

		$CostUpdateNo = GetNextTransNo(35, $db);
		$PeriodNo = GetPeriod(date($_SESSION['DefaultDateFormat']), $db);
		$StockGLCode = GetStockGLCode($StockID,$db);

		$ValueOfChange = $QOH * ($NewCost - $OldCost);

		$SQL = "INSERT INTO weberp_gltrans (type,
									typeno,
									trandate,
									periodno,
									account,
									narrative,
									amount)
						VALUES ('35',
						'" . $CostUpdateNo . "',
						'" . Date('Y-m-d') . "',
						'" . $PeriodNo . "',
						'" . $StockGLCode['adjglact'] . "',
						'" . $StockID . ' ' . _('cost was') . ' ' . $OldCost . ' ' . _('changed to') . ' ' . $NewCost . ' x ' . _('Quantity on hand of') . ' ' . $QOH . "',
						'" . -$ValueOfChange . "')";

		$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The GL credit for the stock cost adjustment posting could not be inserted because');
		$DbgMsg = _('The following SQL to insert the GLTrans record was used');
		$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);

		$SQL = "INSERT INTO weberp_gltrans (type,
						typeno,
						trandate,
						periodno,
						account,
						narrative,
						amount)
					VALUES ('35',
						'" . $CostUpdateNo . "',
						'" . Date('Y-m-d') . "',
						'" . $PeriodNo . "',
						'" . $StockGLCode['stockact'] . "',
						'" . $StockID . ' ' . _('cost was') . ' ' . $OldCost . ' ' . _('changed to') .' ' . $NewCost . ' x ' . _('Quantity on hand of') . ' ' . $QOH . "',
						'" . $ValueOfChange . "')";

		$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The GL debit for stock cost adjustment posting could not be inserted because');
		$DbgMsg = _('The following SQL to insert the GLTrans record was used');
		$Result = DB_query($SQL,$ErrMsg,$DbgMsg,true);
	}
}

/* Calculates the material cost of a bill of materials, given parent code*/
function BomMaterialCost($Parent, $db) {
	$SQL = "SELECT materialcost FROM weberp_stockmaster WHERE stockid='" . $Parent . "'";
	$result1 = DB_query($SQL);
	$MyRow1 = DB_fetch_row($result1);
	$OldCost = $MyRow1[0];
	$SQL = "SELECT sum(quantity) as qoh from weberp_locstock where stockid='" . $Parent . "'";
	$result1 = DB_query($SQL);
	$MyRow1 = DB_fetch_row($result1);
	$QOH = $MyRow1[0];
	$SQL = "SELECT Sum(weberp_stockmaster.materialcost*weberp_bom.quantity) AS SumOfmaterialcost
	   					FROM weberp_bom LEFT JOIN weberp_stockmaster
						ON weberp_bom.component = weberp_stockmaster.stockid
						WHERE weberp_bom.parent='". $Parent . "'
                        AND weberp_bom.effectiveafter <= '" . date('Y-m-d') . "'
                        AND weberp_bom.effectiveto > '" . date('Y-m-d') . "'";
	$result = DB_query($SQL);
	$MyRow = DB_fetch_row($result);
	$MaterialCost = $MyRow[0];
	$Result = DB_Txn_Begin();
	if (abs($MaterialCost-$OldCost)>0) {
		ItemCostUpdateGL($db, $Parent, $MaterialCost, $OldCost, $QOH);
	}
	$Result = DB_Txn_Commit();
	return $MaterialCost;
}

/*Iterates through the levels of the weberp_bom, recalculating each weberp_bom it meets*/
function UpdateCost($db, $Item) {
	$SQL = "SELECT parent FROM weberp_bom where component = '" . $Item . "'";
	$Result = DB_query($SQL);
	while ($MyRow=DB_fetch_array($Result)){
		$NewParent = $MyRow['parent'];
		$MaterialCost = BomMaterialCost($NewParent, $db);
		$SQL = "UPDATE weberp_stockmaster SET materialcost=" . $MaterialCost . " WHERE stockid='" . $NewParent . "'";
		$result1 = DB_query($SQL);
		if (DB_error_no()!=0) {
			return 1;
		}
		UpdateCost($db, $NewParent);
	}
	return 0;
}

/* Accepts work order information and iterates through the weberp_bom, inserting real components (dissolving phantom assemblies) */
function WoRealRequirements($db, $WO, $LocCode, $StockID, $Qty=1, $ParentID='') {

	// remember, 'G' is for ghost (phantom part type)

	// all components should be referenced to the initial parent
	if ($ParentID == '') {
		$ParentID = $StockID;
	}

	// insert new real immediate components of this item
	$sql = "INSERT INTO weberp_worequirements (wo,
				parentstockid,
				stockid,
				qtypu,
				stdcost,
				autoissue)
			SELECT '" . $WO . "',
				'" . $ParentID . "',
				weberp_bom.component,
				weberp_bom.quantity*" . $Qty . ",
				materialcost+labourcost+overheadcost,
				weberp_bom.autoissue
			FROM weberp_bom INNER JOIN weberp_stockmaster
			ON weberp_bom.component=weberp_stockmaster.stockid
			WHERE weberp_bom.parent='" . $StockID . "'
			AND weberp_bom.loccode ='" . $LocCode . "'
            AND weberp_bom.effectiveafter <= '" . date('Y-m-d') . "'
            AND weberp_bom.effectiveto > '" . date('Y-m-d') . "'
			AND weberp_stockmaster.mbflag<>'G'
			AND weberp_bom.component NOT IN (
				SELECT stockid
				FROM weberp_worequirements
				WHERE wo = '" . $WO . "'
				AND parentstockid = '" . $ParentID . "'
			)";
	$result = DB_query($sql);

	// combine real immediate components of this item with other occurrences in this work order
	// otherwise, we could encounter a uniqueness violation:
	//     - the same component could occur in multiple dissolved phantom assemblies
	//     - need to sum quantities of multiple component occurrences
	if ($ParentID != $StockID) {
		$sql = "UPDATE weberp_worequirements
					INNER JOIN (
						SELECT CAST('" . $WO . "' AS SIGNED) as wo,
							CAST('NODE-1' AS CHAR) as parentstockid,
							weberp_bom.component AS stockid,
							weberp_bom.quantity*1 AS qtypu,
							materialcost+labourcost+overheadcost AS stdcost,
							weberp_bom.autoissue
						FROM weberp_bom INNER JOIN weberp_stockmaster
						ON weberp_bom.component=weberp_stockmaster.stockid
						WHERE weberp_bom.parent='" . $StockID . "'
						AND weberp_bom.loccode ='" . $LocCode . "'
                        AND weberp_bom.effectiveafter <= '" . date('Y-m-d') . "'
                        AND weberp_bom.effectiveto > '" . date('Y-m-d') . "'
						AND weberp_stockmaster.mbflag<>'G'
						AND weberp_bom.component IN (
							SELECT stockid
							FROM weberp_worequirements
							WHERE wo = '" . $WO . "'
							AND parentstockid = '". $ParentID . "'
						)
					) AS g ON g.wo=weberp_worequirements.wo
						AND g.parentstockid=weberp_worequirements.parentstockid
						AND g.stockid=weberp_worequirements.stockid
					SET weberp_worequirements.qtypu=weberp_worequirements.qtypu+g.qtypu";
		$result = DB_query($sql);
	}

	// dissolve phantom assemblies
	$sql = "SELECT
				weberp_bom.component,
				weberp_bom.quantity
			FROM weberp_bom INNER JOIN weberp_stockmaster
			ON weberp_bom.component=weberp_stockmaster.stockid
			WHERE parent='" . $StockID . "'
			AND loccode ='" . $LocCode . "'
            AND weberp_bom.effectiveafter <= '" . date('Y-m-d') . "'
            AND weberp_bom.effectiveto > '" . date('Y-m-d') . "'
			AND weberp_stockmaster.mbflag='G'";
	$result = DB_query($sql);
	while ($MyRow=DB_fetch_array($result)) {
		WoRealRequirements($db, $WO, $LocCode, $MyRow['component'], $MyRow['quantity'], $ParentID);
	}

}

/*Ensures general ledger entries balance for a given transaction */
function EnsureGLEntriesBalance ($TransType, $TransTypeNo, $db) {

	$result = DB_query("SELECT SUM(amount)
						FROM weberp_gltrans
						WHERE type = '" . $TransType . "'
						AND typeno = '" . $TransTypeNo . "'");
	$myrow = DB_fetch_row($result);
	$Difference = $myrow[0];
	if (abs($Difference)!=0){
		if (abs($Difference)>0.1){
			prnMsg(_('The general ledger entries created do not balance. See your system administrator'),'error');
		} else {
			$result = DB_query("SELECT counterindex,
										MAX(amount)
								FROM weberp_gltrans
								WHERE type = '" . $TransType . "'
								AND typeno = '" . $TransTypeNo . "'
								GROUP BY counterindex");
			$myrow = DB_fetch_array($result);
			$TransToAmend = $myrow['counterindex'];
			$result = DB_query("UPDATE weberp_gltrans SET amount = amount - " . $Difference . "
								WHERE counterindex = '" . $TransToAmend . "'");

		}
	}
}

/* 	GetQuantityOnOrderDueToPurchaseOrders return the QOO for an item due to Purchase orders (not WO).
	If Location is empty, it returns the QOO for all locations
	If location is NOT empty, returns the QOO for that specific location.
*/
function GetQuantityOnOrderDueToPurchaseOrders($StockID, $Location){

	global $db;

	if ($Location == ""){
		// All locations to be considered
		$WhereLocation = "";
		$ErrMsg = _('The quantity on order due to purchase orders for') . ' ' . $StockID . ' ' . _('to be received into all locations cannot be retrieved because');
	}else{
		// Just 1 location to consider
		$WhereLocation = " AND weberp_purchorders.intostocklocation = '" . $Location . "'";
		$ErrMsg = _('The quantity on order due to purchase orders for') . ' ' . $StockID . ' ' . _('to be received into') . ' ' . $Location . ' ' . _('cannot be retrieved because');
	}

	$SQL="SELECT SUM(weberp_purchorderdetails.quantityord -weberp_purchorderdetails.quantityrecd) AS QtyOnOrder
		FROM weberp_purchorders
			INNER JOIN weberp_purchorderdetails
				ON weberp_purchorders.orderno=weberp_purchorderdetails.orderno
			INNER JOIN weberp_locationusers
				ON weberp_locationusers.loccode=weberp_purchorders.intostocklocation
					AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "'
					AND weberp_locationusers.canview=1
		WHERE weberp_purchorderdetails.itemcode='" . $StockID . "'
			AND weberp_purchorderdetails.completed = 0
			AND weberp_purchorders.status<>'Cancelled'
			AND weberp_purchorders.status<>'Pending'
			AND weberp_purchorders.status<>'Rejected'
			AND weberp_purchorders.status<>'Completed'" .
			$WhereLocation;

	$QOOResult = DB_query($SQL, $ErrMsg);
	if (DB_num_rows($QOOResult) == 0) {
		$QOO = 0;
	} else {
		$QOORow = DB_fetch_row($QOOResult);
		$QOO = $QOORow[0];
	}
	return $QOO;
}


/* 	GetQuantityOnOrderDueToWorkOrders return the QOO for an item due to Work orders (not PO).
	If Location is empty, it returns the QOO for all locations
	If location is NOT empty, returns the QOO for that specific location.
*/
function GetQuantityOnOrderDueToWorkOrders($StockID, $Location){

	global $db;

	if ($Location == ''){
		// All locations to be considered
		$WhereLocation = '';
		$ErrMsg = _('The quantity on order due to work orders for') . ' ' . $StockID . ' ' . _('to be received into all locations cannot be retrieved because');
	}else{
		// Just 1 location to consider
		$WhereLocation = " AND weberp_workorders.loccode='" . $Location . "'";
		$ErrMsg = _('The quantity on order due to work orders for') . ' ' . $StockID . ' ' . _('to be received into') . ' ' . $Location . ' ' . _('cannot be retrieved because');
	}

	$SQL="SELECT SUM(weberp_woitems.qtyreqd-weberp_woitems.qtyrecd) AS qtywo
		FROM weberp_woitems
			INNER JOIN weberp_workorders
				ON weberp_woitems.wo=weberp_workorders.wo
			INNER JOIN weberp_locationusers
				ON weberp_locationusers.loccode=weberp_workorders.loccode
					AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "'
					AND weberp_locationusers.canview=1
		WHERE weberp_workorders.closed=0
			AND weberp_woitems.stockid='" . $StockID . "'" .
			$WhereLocation;

	$QOOResult = DB_query($SQL, $ErrMsg);
	if (DB_num_rows($QOOResult) == 0) {
		$QOO = 0;
	} else {
		$QOORow = DB_fetch_row($QOOResult);
		$QOO = $QOORow[0];
	}
	return $QOO;
}

/*Creates sample and testresults */
function CreateQASample ($ProdSpecKey, $LotKey, $Identifier, $Comments, $Cert, $DuplicateOK, $db) {
	$result = DB_query("SELECT COUNT(testid) FROM weberp_prodspecs
							WHERE keyval='" . $ProdSpecKey . "'
							AND active='1'",	$db);
	$myrow = DB_fetch_row($result);
	if ($myrow[0]>0) {
		if ($DuplicateOK==0) {
			$result = DB_query("SELECT COUNT(sampleid) FROM weberp_qasamples
								WHERE prodspeckey='" . $ProdSpecKey . "'
								AND lotkey='" . $LotKey ."'",	$db);
			$myrow2 = DB_fetch_row($result);
		} else {
			$myrow2[0]=0;
		}
		if ($myrow2[0]==0 OR $DuplicateOK==1) {
			$SQL = "INSERT INTO weberp_qasamples (prodspeckey,
											lotkey,
											identifier,
											comments,
											cert,
											createdby,
											sampledate)
								VALUES('" . $ProdSpecKey . "',
										'" . $LotKey  . "',
										'" . $Identifier  . "',
										'" . $Comments  . "',
										'" . $Cert  . "',
										'" . $_SESSION['UserID'] . "',
										'" . date('Y-m-d') . "')";
			$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The create of the qasamples record failed');
			$DbgMsg = _('The following SQL to create the weberp_qasamples was used');
			$Result = DB_query($SQL, $db, $ErrMsg, $DbgMsg, true);
			$SampleID=DB_Last_Insert_ID($db,'weberp_qasamples','sampleid');
			$SQL = "INSERT INTO weberp_sampleresults (sampleid,
											testid,
											defaultvalue,
											targetvalue,
											rangemin,
											rangemax,
											showoncert,
											showontestplan)
								SELECT '" . $SampleID . "',
											testid,
											defaultvalue,
											targetvalue,
											rangemin,
											rangemax,
											showoncert,
											showontestplan
											FROM weberp_prodspecs WHERE keyval='" .$ProdSpecKey. "'
											AND weberp_prodspecs.active='1'";
			$ErrMsg = _('CRITICAL ERROR') . '! ' . _('NOTE DOWN THIS ERROR AND SEEK ASSISTANCE') . ': ' . _('The create of the sampleresults record failed');
			$DbgMsg = _('The following SQL to create the weberp_sampleresults was used');
			$Result = DB_query($SQL, $db, $ErrMsg, $DbgMsg, true);
			
		} //$myrow2[0]=0
	} //$myrow[0]>0
}

?>
