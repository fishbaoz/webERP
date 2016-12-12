<?php
/* $Id: Contract_Readin.php 3692 2010-08-15 09:22:08Z daintree $ */
/*Contract_Readin.php is used by the modify existing Contract in Contracts.php and also by ContractCosting.php */

$ContractHeaderSQL = "SELECT contractdescription,
							weberp_contracts.debtorno,
							weberp_contracts.branchcode,
							weberp_contracts.loccode,
							status,
							categoryid,
							orderno,
							margin,
							wo,
							requireddate,
							drawing,
							exrate,
							weberp_debtorsmaster.name,
							weberp_custbranch.brname,
							weberp_debtorsmaster.currcode
						FROM weberp_contracts INNER JOIN weberp_debtorsmaster
						ON weberp_contracts.debtorno=weberp_debtorsmaster.debtorno
						INNER JOIN weberp_currencies
						ON weberp_debtorsmaster.currcode=weberp_currencies.currabrev
						INNER JOIN weberp_custbranch
						ON weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno
						AND weberp_contracts.branchcode=weberp_custbranch.branchcode
						INNER JOIN weberp_locationusers ON weberp_locationusers.loccode=weberp_contracts.loccode AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "' AND weberp_locationusers.canupd=1
						WHERE contractref= '" . $ContractRef . "'";

$ErrMsg =  _('The contract cannot be retrieved because');
$DbgMsg =  _('The SQL statement that was used and failed was');
$ContractHdrResult = DB_query($ContractHeaderSQL,$ErrMsg,$DbgMsg);

if (DB_num_rows($ContractHdrResult)==1 and !isset($_SESSION['Contract'.$identifier]->ContractRef )) {

	$myrow = DB_fetch_array($ContractHdrResult);
	$_SESSION['Contract'.$identifier]->ContractRef = $ContractRef;
	$_SESSION['Contract'.$identifier]->ContractDescription = $myrow['contractdescription'];
	$_SESSION['Contract'.$identifier]->DebtorNo = $myrow['debtorno'];
	$_SESSION['Contract'.$identifier]->BranchCode = $myrow['branchcode'];
	$_SESSION['Contract'.$identifier]->LocCode = $myrow['loccode'];
	$_SESSION['Contract'.$identifier]->Status = $myrow['status'];
	$_SESSION['Contract'.$identifier]->CategoryID = $myrow['categoryid'];
	$_SESSION['Contract'.$identifier]->OrderNo = $myrow['orderno'];
	$_SESSION['Contract'.$identifier]->Margin = $myrow['margin'];
	$_SESSION['Contract'.$identifier]->WO = $myrow['wo'];
	$_SESSION['Contract'.$identifier]->RequiredDate = ConvertSQLDate($myrow['requireddate']);
	$_SESSION['Contract'.$identifier]->Drawing = $myrow['drawing'];
	$_SESSION['Contract'.$identifier]->ExRate = $myrow['exrate'];
	$_SESSION['Contract'.$identifier]->BranchName = $myrow['brname'];
	$_SESSION['RequireCustomerSelection'] = 0;
	$_SESSION['Contract'.$identifier]->CustomerName = $myrow['name'];
	$_SESSION['Contract'.$identifier]->CurrCode = $myrow['currcode'];


/*now populate the contract BOM array with the items required for the contract */

	$ContractBOMsql = "SELECT weberp_contractbom.stockid,
							weberp_stockmaster.description,
							weberp_contractbom.workcentreadded,
							weberp_contractbom.quantity,
							weberp_stockmaster.units,
							weberp_stockmaster.decimalplaces,
							weberp_stockmaster.materialcost+weberp_stockmaster.labourcost+weberp_stockmaster.overheadcost AS cost
						FROM weberp_contractbom INNER JOIN weberp_stockmaster
						ON weberp_contractbom.stockid=weberp_stockmaster.stockid
						WHERE contractref ='" . $ContractRef . "'";

	$ErrMsg =  _('The bill of material cannot be retrieved because');
	$DbgMsg =  _('The SQL statement that was used to retrieve the contract bill of material was');
	$ContractBOMResult = DB_query($ContractBOMsql,$ErrMsg,$DbgMsg);

	if (DB_num_rows($ContractBOMResult) > 0) {
		while ($myrow=DB_fetch_array($ContractBOMResult)) {
			$_SESSION['Contract'.$identifier]->Add_To_ContractBOM($myrow['stockid'],
																	$myrow['description'],
																	$myrow['workcentreadded'],
																	$myrow['quantity'],
																	$myrow['cost'],
																	$myrow['units'],
																	$myrow['decimalplaces']);
		} /* add contract bill of materials BOM lines*/
	} //end is there was a contract BOM to add
	//Now add the contract requirments
	$ContractReqtsSQL = "SELECT requirement,
								quantity,
								costperunit,
								contractreqid
						FROM weberp_contractreqts
						WHERE contractref ='" . $ContractRef . "'
						ORDER BY contractreqid";

	$ErrMsg =  _('The other contract requirementscannot be retrieved because');
	$DbgMsg =  _('The SQL statement that was used to retrieve the other contract requirments was');
	$ContractReqtsResult = DB_query($ContractReqtsSQL,$ErrMsg,$DbgMsg);

	if (DB_num_rows($ContractReqtsResult) > 0) {
		while ($myrow=DB_fetch_array($ContractReqtsResult)) {
			$_SESSION['Contract'.$identifier]->Add_To_ContractRequirements($myrow['requirement'],
																		   $myrow['quantity'],
																		   $myrow['costperunit'],
																		   $myrow['contractreqid']);
		} /* add other contract requirments lines*/
	} //end is there are contract other contract requirments to add
} // end if there was a header for the contract
?>