<?php

/* Define error codes that are returned by api functions*/
	Define('NoAuthorisation', 1);
	Define('IncorrectDebtorNumberLength', 1000);
	Define('DebtorNoAlreadyExists', 1001);
	Define('IncorrectDebtorNameLength', 1002);
	Define('InvalidAddressLine', 1003);
	Define('CurrencyCodeNotSetup', 1004);
	Define('SalesTypeNotSetup', 1005);
	Define('InvalidClientSinceDate', 1006);
	Define('HoldReasonNotSetup', 1007);
	Define('PaymentTermsNotSetup', 1008);
	Define('InvalidDiscount', 1009);
	Define('InvalidPaymentDiscount', 1010);
	Define('InvalidLastPaid', 1011);
	Define('InvalidLastPaidDate', 1012);
	Define('InvalidCreditLimit', 1013);
	Define('InvalidInvAddrBranch', 1014);
	Define('InvalidDiscountCode', 1015);
	Define('InvalidEDIInvoices', 1016);
	Define('InvalidEDIOrders', 1017);
	Define('InvalidEDIReference', 1018);
	Define('InvalidEDITransport', 1019);
	Define('InvalidEDIAddress', 1020);
	Define('InvalidEDIServerUser', 1021);
	Define('InvalidEDIServerPassword', 1022);
	Define('InvalidTaxRef', 1023);
	Define('InvalidCustomerPOLine', 1024);
	Define('DatabaseUpdateFailed', 1025);
	Define('NoDebtorNumber', 1026);
	Define('DebtorDoesntExist', 1027);
	Define('IncorrectBranchNumberLength', 1028);
	Define('BranchNoAlreadyExists', 1029);
	Define('IncorrectBranchNameLength', 1030);
	Define('InvalidEstDeliveryDays', 1031);
	Define('AreaCodeNotSetup', 1032);
	Define('SalesmanCodeNotSetup', 1033);
	Define('InvalidFwdDate', 1034);
	Define('InvalidPhoneNumber', 1035);
	Define('InvalidFaxNumber', 1036);
	Define('InvalidContactName', 1037);
	Define('InvalidEmailAddress', 1038);
	Define('LocationCodeNotSetup', 1039);
	Define('TaxGroupIdNotSetup', 1040);
	Define('ShipperNotSetup', 1041);
	Define('InvalidDeliverBlind', 1042);
	Define('InvalidDisableTrans', 1043);
	Define('InvalidSpecialInstructions', 1044);
	Define('InvalidCustBranchCode', 1045);
	Define('BranchNoDoesntExist', 1046);
	Define('StockCodeDoesntExist', 1047);
	Define('StockCategoryDoesntExist', 1048);
	Define('IncorrectStockDescriptionLength', 1049);
	Define('IncorrectUnitsLength', 1050);
	Define('IncorrectMBFlag', 1051);
	Define('InvalidCurCostDate', 1052);
	Define('InvalidActualCost', 1053);
	Define('InvalidLowestLevel', 1054);
	Define('InvalidDiscontinued', 1055);
	Define('InvalidEOQ', 1056);
	Define('InvalidVolume', 1057);
	Define('InvalidKgs', 1058);
	Define('IncorrectBarCodeLength', 1059);
	Define('IncorrectDiscountCategory', 1060);
	Define('TaxCategoriesDoesntExist', 1061);
	Define('InvalidSerialised', 1062);
	Define('IncorrectAppendFile', 1063);
	Define('InvalidPerishable', 1064);
	Define('InvalidDecmalPlaces', 1065);
	Define('IncorrectLongStockDescriptionLength', 1066);
	Define('StockCodeAlreadyExists', 1067);
	Define('TransactionNumberAlreadyExists', 1068);
	Define('InvalidTranDate', 1069);
	Define('InvalidSettled', 1070);
	Define('IncorrectReference', 1071);
	Define('IncorrectTpe', 1072);
	Define('InvalidOrderNumbers', 1073);
	Define('InvalidExchangeRate', 1074);
	Define('InvalidOVAmount', 1075);
	Define('InvalidOVGst', 1076);
	Define('InvalidOVFreight', 1077);
	Define('InvalidDiffOnExchange', 1078);
	Define('InvalidAllocation', 1079);
	Define('IncorrectInvoiceText', 1080);
	Define('InvalidShipVia', 1081);
	Define('InvalidEdiSent', 1082);
	Define('InvalidConsignment', 1083);
	Define('InvalidLastCost', 1084);
	Define('InvalidMaterialCost', 1085);
	Define('InvalidLabourCost', 1086);
	Define('InvalidOverheadCost', 1087);
	Define('InvalidCustomerRef', 1088);
	Define('InvalidBuyerName', 1089);
	Define('InvalidComments', 1090);
	Define('InvalidOrderDate', 1091);
	Define('InvalidDeliverTo', 1092);
	Define('InvalidFreightCost', 1094);
	Define('InvalidDeliveryDate', 1095);
	Define('InvalidQuotationFlag', 1096);
	Define('OrderHeaderNotSetup', 1097);
	Define('InvalidUnitPrice', 1098);
	Define('InvalidQuantity', 1099);
	Define('InvalidDiscountPercent', 1100);
	Define('InvalidNarrative', 1101);
	Define('InvalidItemDueDate', 1102);
	Define('InvalidPOLine', 1103);
	Define('GLAccountCodeAlreadyExists', 1104);
	Define('IncorrectAccountNameLength', 1105);
	Define('AccountGroupDoesntExist', 1106);
	Define('GLAccountSectionAlreadyExists', 1107);
	Define('IncorrectSectionNameLength', 1108);
	Define('GLAccountGroupAlreadyExists', 1109);
	Define('GLAccountSectionDoesntExist', 1110);
	Define('InvalidPandL', 1111);
	Define('InvalidSequenceInTB', 1112);
	Define('GLAccountGroupDoesntExist', 1113);
	Define('InvalidLatitude', 1114);
	Define('InvalidLongitude', 1115);
	Define('CustomerTypeNotSetup', 1116);
	Define('NoPricesSetup', 1117);
	Define('InvalidInvoicedQuantity', 1118);
	Define('InvalidActualDispatchDate', 1119);
	Define('InvalidCompletedFlag', 1120);
	Define('InvalidCategoryID', 1121);
	Define('InvalidCategoryDescription', 1122);
	Define('InvalidStockType', 1123);
	Define('GLAccountCodeDoesntExists', 1124);
	Define('StockCategoryAlreadyExists', 1125);

/* Array of Descriptions of errors */
	$ErrorDescription['1'] = _('No Authorisation');
	$ErrorDescription['1000'] = _('Incorrect Debtor Number Length');
	$ErrorDescription['1001'] = _('Debtor No Already Exists');
	$ErrorDescription['1002'] = _('Incorrect Debtor Name Length');
	$ErrorDescription['1003'] = _('Invalid Address Line');
	$ErrorDescription['1004'] = _('Currency Code Not Setup');
	$ErrorDescription['1005'] = _('Sales Type Not Setup');
	$ErrorDescription['1006'] = _('Invalid Client Since Date');
	$ErrorDescription['1007'] = _('Hold Reason Not Setup');
	$ErrorDescription['1008'] = _('Payment Terms Not Setup');
	$ErrorDescription['1009'] = _('Invalid Discount');
	$ErrorDescription['1010'] = _('Invalid Payment Discount');
	$ErrorDescription['1011'] = _('Invalid Last Paid');
	$ErrorDescription['1012'] = _('Invalid Last Paid Date');
	$ErrorDescription['1013'] = _('Invalid Credit Limit');
	$ErrorDescription['1014'] = _('Invalid Inv Address Branch');
	$ErrorDescription['1015'] = _('Invalid Discount Code');
	$ErrorDescription['1016'] = _('Invalid EDI Invoices');
	$ErrorDescription['1017'] = _('Invalid EDI Orders');
	$ErrorDescription['1018'] = _('Invalid EDI Reference');
	$ErrorDescription['1019'] = _('Invalid EDI Transport');
	$ErrorDescription['1020'] = _('Invalid EDI Address');
	$ErrorDescription['1021'] = _('Invalid EDI Server User');
	$ErrorDescription['1022'] = _('Invalid EDI Server Password');
	$ErrorDescription['1023'] = _('Invalid Tax Reference');
	$ErrorDescription['1024'] = _('Invalid CustomerPOLine');
	$ErrorDescription['1025'] = _('Database Update Failed');
	$ErrorDescription['1026'] = _('No Debtor Number');
	$ErrorDescription['1027'] = _('Debtor Doesnt Exist');
	$ErrorDescription['1028'] = _('Incorrect Branch Number Length');
	$ErrorDescription['1029'] = _('Branch No Already Exists');
	$ErrorDescription['1030'] = _('Incorrect Branch Name Length');
	$ErrorDescription['1031'] = _('Invalid Est Delivery Days');
	$ErrorDescription['1032'] = _('Area Code Not Setup');
	$ErrorDescription['1033'] = _('Salesman Code Not Setup');
	$ErrorDescription['1034'] = _('Invalid Fwd Date');
	$ErrorDescription['1035'] = _('Invalid Phone Number');
	$ErrorDescription['1036'] = _('Invalid Fax Number');
	$ErrorDescription['1037'] = _('Invalid Contact Name');
	$ErrorDescription['1038'] = _('Invalid Email Address');
	$ErrorDescription['1039'] = _('Location Code Not Setup');
	$ErrorDescription['1040'] = _('Tax Group Id Not Setup');
	$ErrorDescription['1041'] = _('Shipper Not Setup');
	$ErrorDescription['1042'] = _('Invalid Deliver Blind');
	$ErrorDescription['1043'] = _('Invalid Disable Transactions');
	$ErrorDescription['1044'] = _('Invalid Special Instructions');
	$ErrorDescription['1045'] = _('Invalid Customer Branch Code');
	$ErrorDescription['1046'] = _('Branch No Doesnt Exist');
	$ErrorDescription['1047'] = _('Stock Code Doesnt Exist');
	$ErrorDescription['1048'] = _('Stock Category Doesnt Exist');
	$ErrorDescription['1049'] = _('Incorrect Stock Description Length');
	$ErrorDescription['1050'] = _('Incorrect Units Length');
	$ErrorDescription['1051'] = _('Incorrect MB Flag');
	$ErrorDescription['1052'] = _('Invalid Currrent Cost Date');
	$ErrorDescription['1053'] = _('Invalid Actual Cost');
	$ErrorDescription['1054'] = _('Invalid Lowest Level');
	$ErrorDescription['1055'] = _('Invalid Discontinued');
	$ErrorDescription['1056'] = _('Invalid EOQ');
	$ErrorDescription['1057'] = _('Invalid Volume');
	$ErrorDescription['1058'] = _('Invalid Kgs');
	$ErrorDescription['1059'] = _('Incorrect BarCode Length');
	$ErrorDescription['1060'] = _('Incorrect Discount Category');
	$ErrorDescription['1061'] = _('Tax Category Doesnt Exist');
	$ErrorDescription['1062'] = _('Invalid Serialised');
	$ErrorDescription['1063'] = _('Incorrect Append File');
	$ErrorDescription['1064'] = _('Invalid Perishable');
	$ErrorDescription['1065'] = _('Invalid Decimal Places');
	$ErrorDescription['1066'] = _('Incorrect Long Stock Description Length');
	$ErrorDescription['1067'] = _('Stock Code Already Exists');
	$ErrorDescription['1068'] = _('Transaction Number Already Exists');
	$ErrorDescription['1069'] = _('Invalid Transaction Date');
	$ErrorDescription['1070'] = _('Invalid Settled');
	$ErrorDescription['1071'] = _('Incorrect Reference');
	$ErrorDescription['1072'] = _('Incorrect TPE');
	$ErrorDescription['1073'] = _('Invalid Order Numbers');
	$ErrorDescription['1074'] = _('Invalid Exchange Rate');
	$ErrorDescription['1075'] = _('Invalid OV Amount');
	$ErrorDescription['1076'] = _('Invalid OV Gst');
	$ErrorDescription['1077'] = _('Invalid OV Freight');
	$ErrorDescription['1078'] = _('Invalid Diff On Exchange');
	$ErrorDescription['1079'] = _('Invalid Allocation');
	$ErrorDescription['1080'] = _('Incorrect Invoice Text');
	$ErrorDescription['1081'] = _('Invalid Ship Via');
	$ErrorDescription['1082'] = _('Invalid Edi Sent');
	$ErrorDescription['1083'] = _('Invalid Consignment');
	$ErrorDescription['1084'] = _('Invalid Last Cost');
	$ErrorDescription['1085'] = _('Invalid Material Cost');
	$ErrorDescription['1086'] = _('Invalid Labour Cost');
	$ErrorDescription['1087'] = _('Invalid Overhead Cost');
	$ErrorDescription['1088'] = _('Invalid Customer Reference');
	$ErrorDescription['1089'] = _('Invalid Buyer Name');
	$ErrorDescription['1090'] = _('Invalid Comments');
	$ErrorDescription['1091'] = _('Invalid Order Date');
	$ErrorDescription['1092'] = _('Invalid Delivery Name');
	$ErrorDescription['1094'] = _('Invalid Freight Cost');
	$ErrorDescription['1095'] = _('Invalid Delivery Date');
	$ErrorDescription['1096'] = _('Invalid Quotation Flag');
	$ErrorDescription['1097'] = _('Order header not setup');
	$ErrorDescription['1098'] = _('Invalid unit cost');
	$ErrorDescription['1099'] = _('Invalid Quantity');
	$ErrorDescription['1100'] = _('Invalid Discount Percent');
	$ErrorDescription['1101'] = _('Invalid Narrative');
	$ErrorDescription['1102'] = _('Invalid Item Due');
	$ErrorDescription['1103'] = _('Invalid PO line');
	$ErrorDescription['1104'] = _('GL account code already exists');
	$ErrorDescription['1105'] = _('GL account code name is incorrect length');
	$ErrorDescription['1106'] = _('GL account group doesnt exist');
	$ErrorDescription['1107'] = _('GL account section already exists');
	$ErrorDescription['1108'] = _('GL account section name is incorrect length');
	$ErrorDescription['1109'] = _('GL account group already exists');
	$ErrorDescription['1110'] = _('GL account section doesnt exist');
	$ErrorDescription['1111'] = _('Invalid profit and loss flag');
	$ErrorDescription['1112'] = _('Invalid sequenceintb figure');
	$ErrorDescription['1113'] = _('GL account group doesnt exist');
	$ErrorDescription['1114'] = _('Invalid Latitude figure');
	$ErrorDescription['1115'] = _('Invalid Longitude figure');
	$ErrorDescription['1116'] = _('Customer type not set up');
	$ErrorDescription['1117'] = _('No sales prices setup');
	$ErrorDescription['1118'] = _('Invalid invoiced quantity');
	$ErrorDescription['1119'] = _('Invalid actual dispatch date');
	$ErrorDescription['1120'] = _('Invalid completed flag');
	$ErrorDescription['1121'] = _('Invalid category id');
	$ErrorDescription['1122'] = _('Invalid category description');
	$ErrorDescription['1123'] = _('Invalid stock type');
	$ErrorDescription['1124'] = _('GL account code doesnt exist');
	$ErrorDescription['1125'] = _('Stock category already exists');

?>