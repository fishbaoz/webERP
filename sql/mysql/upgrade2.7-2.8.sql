begin;

ALTER TABLE weberp_Locations ADD TaxAuthority tinyint(4) NOT NULL default 1;

ALTER TABLE weberp_StockMaster ADD TaxLevel tinyint(4) NOT NULL default 1;

CREATE TABLE weberp_TaxAuthLevels (
  TaxAuthority tinyint NOT NULL default '1',
  DispatchTaxAuthority tinyint NOT NULL default '1',
  Level tinyint NOT NULL default '0',
  TaxRate double NOT NULL default '0',
  PRIMARY KEY  (TaxAuthority,DispatchTaxAuthority,Level),
  KEY (TaxAuthority),
  KEY (DispatchTaxAuthority)
) TYPE=Innodb;

INSERT INTO weberp_TaxAuthLevels VALUES (1, 1, 1, 0.1);
INSERT INTO weberp_TaxAuthLevels VALUES (1, 1, 2, 0);

ALTER TABLE weberp_TaxAuthorities DROP COLUMN Rate;
ALTER TABLE weberp_TaxAuthorities CHANGE TaxID TaxID tinyint(4) NOT NULL default '0';


ALTER TABLE weberp_StockMoves ADD COLUMN TaxRate float NOT NULL default 0;
ALTER TABLE weberp_DebtorTrans ADD COLUMN EDISent tinyint(4) NOT NULL default 0;
ALTER TABLE weberp_DebtorTrans ADD INDEX(`EDISent`);

ALTER TABLE weberp_CustBranch ADD CustBranchCode VARCHAR(30) NOT NULL default '';

ALTER TABLE weberp_WWW_Users ADD COLUMN Blocked tinyint(4) NOT NULL default 0;

ALTER TABLE weberp_DebtorsMaster ADD EDIInvoices tinyint(4) NOT NULL default '0';
ALTER TABLE weberp_DebtorsMaster ADD EDIOrders tinyint(4) NOT NULL default '0';
ALTER TABLE weberp_DebtorsMaster ADD EDIReference varchar(20) NOT NULL default '';
ALTER TABLE weberp_DebtorsMaster ADD EDITransport varchar(5) NOT NULL default 'email';
ALTER TABLE weberp_DebtorsMaster ADD EDIAddress varchar(50) NOT NULL default '';
ALTER TABLE weberp_DebtorsMaster ADD EDIServerUser varchar(20) NOT NULL default '';
ALTER TABLE weberp_DebtorsMaster ADD EDIServerPwd varchar(20) NOT NULL default '';
ALTER TABLE weberp_DebtorsMaster ADD INDEX (EDIInvoices);
ALTER TABLE weberp_DebtorsMaster ADD INDEX (EDIOrders);

CREATE TABLE weberp_EDIItemMapping (
  SuppOrCust varchar(4) NOT NULL default '',
  PartnerCode varchar(10) NOT NULL default '',
  StockID varchar(20) NOT NULL default '',
  PartnerStockID varchar(50) NOT NULL default '',
  PRIMARY KEY  (SuppOrCust,PartnerCode,StockID),
  KEY PartnerCode (PartnerCode),
  KEY StockID (StockID),
  KEY PartnerStockID (PartnerStockID),
  KEY SuppOrCust (SuppOrCust)
) TYPE=Innodb;

CREATE TABLE weberp_EDIMessageFormat (
  PartnerCode varchar(10) NOT NULL default '',
  MessageType varchar(6) NOT NULL default '',
  Section varchar(7) NOT NULL default '',
  SequenceNo int(11) NOT NULL default '0',
  LineText varchar(70) NOT NULL default '',
  PRIMARY KEY  (PartnerCode,MessageType,SequenceNo),
  KEY Section (Section)
) TYPE=Innodb;


INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Heading', 10, 'UNH+[EDITransNo]+INVOIC:D:96A:UN:EAN008\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Heading', 20, 'BGM+[InvOrCrd]+[TransNo]+[OrigOrDup]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Heading', 30, 'DTM+137:[TranDate]:102\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Heading', 60, 'RFF+ON:[OrderNo]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Heading', 70, 'NAD+BY+[CustBranchCode]::92\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Heading', 80, 'NAD+SU+[CompanyEDIReference]::91\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Heading', 90, 'NAD+UD++[BranchName]+[BranchStreet]+[BranchCity]+[BranchState]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Heading', 100, 'RFF+AMT:[TaxAuthorityRef]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Heading', 110, 'PAT+1++5:3:D:30\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Heading', 120, 'DTM+13:[DatePaymentDue]:102\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Heading', 130, 'TAX+7+GST+++:::10\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Heading', 150, 'MOA+124:[TaxTotal]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Detail', 160, 'LIN+[LineNumber]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Detail', 170, 'PIA+5+[StockID]:SA+[CustStockID]:IN\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Detail', 180, 'IMD+F++:::[ItemDescription]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Heading', 85, 'NAD+IV+[CustEDIReference]::9\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Detail', 200, 'QTY+47:[QtyInvoiced]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Detail', 220, 'MOA+128:[LineTotalExclTax]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Detail', 230, 'PRI+AAA:[UnitPrice]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Detail', 240, 'TAX+7+GST+++:::10\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Detail', 250, 'MOA+124:[LineTaxAmount]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Summary', 260, 'UNS+S\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Summary', 270, 'CNT+2:[NoLines]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Summary', 280, 'MOA+128:[TotalAmountExclTax]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Summary', 290, 'TAX+7+GST+++:::10\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Summary', 300, 'MOA+128:[TaxTotal]\'');
INSERT INTO weberp_EDIMessageFormat VALUES ('DEFAULT', 'INVOIC', 'Summary', 310, 'UNT+[NoSegments]+[EDITransNo]\'');

ALTER TABLE weberp_AccountGroups ENGINE = INNODB;
ALTER TABLE weberp_Areas ENGINE = INNODB;
ALTER TABLE weberp_BOM ENGINE = INNODB;
ALTER TABLE weberp_BankAccounts ENGINE = INNODB;
ALTER TABLE weberp_BankTrans ENGINE = INNODB;
ALTER TABLE weberp_Buckets ENGINE = INNODB;
ALTER TABLE weberp_COGSGLPostings ENGINE = INNODB;
ALTER TABLE weberp_ChartMaster ENGINE = INNODB;
ALTER TABLE weberp_Companies ENGINE = INNODB;
ALTER TABLE weberp_ContractBOM ENGINE = INNODB;
ALTER TABLE weberp_ContractReqts ENGINE = INNODB;
ALTER TABLE weberp_Contracts ENGINE = INNODB;
ALTER TABLE weberp_Currencies ENGINE = INNODB;
ALTER TABLE weberp_CustBranch ENGINE = INNODB;
ALTER TABLE weberp_DebtorsMaster ENGINE = INNODB;
ALTER TABLE weberp_DiscountMatrix ENGINE = INNODB;
ALTER TABLE weberp_FreightCosts ENGINE = INNODB;
ALTER TABLE weberp_HoldReasons ENGINE = INNODB;
ALTER TABLE weberp_LastCostRollUp ENGINE = INNODB;
ALTER TABLE weberp_PaymentTerms ENGINE = INNODB;
ALTER TABLE weberp_Prices ENGINE = INNODB;
ALTER TABLE weberp_PurchData ENGINE = INNODB;
ALTER TABLE weberp_ReportColumns ENGINE = INNODB;
ALTER TABLE weberp_ReportHeaders ENGINE = INNODB;
ALTER TABLE weberp_SalesGLPostings ENGINE = INNODB;
ALTER TABLE weberp_SalesTypes ENGINE = INNODB;
ALTER TABLE weberp_Salesman ENGINE = INNODB;
ALTER TABLE weberp_ShipmentCharges ENGINE = INNODB;
ALTER TABLE weberp_Shippers ENGINE = INNODB;
ALTER TABLE weberp_StockCategory ENGINE = INNODB;
ALTER TABLE weberp_StockCheckFreeze ENGINE = INNODB;
ALTER TABLE weberp_StockCounts ENGINE = INNODB;
ALTER TABLE weberp_SupplierContacts ENGINE = INNODB;
ALTER TABLE weberp_Suppliers ENGINE = INNODB;
ALTER TABLE weberp_TaxAuthorities ENGINE = INNODB;
ALTER TABLE weberp_WORequirements ENGINE = INNODB;
ALTER TABLE weberp_WWW_Users ENGINE = INNODB;
ALTER TABLE weberp_WorkCentres ENGINE = INNODB;
ALTER TABLE weberp_Locations ENGINE = INNODB;


ALTER TABLE weberp_TaxAuthLevels ADD FOREIGN KEY (TaxAuthority) REFERENCES TaxAuthorities (TaxID);
ALTER TABLE weberp_TaxAuthLevels ADD FOREIGN KEY (DispatchTaxAuthority) REFERENCES TaxAuthorities (TaxID);

ALTER TABLE weberp_BOM ADD FOREIGN KEY (Parent) REFERENCES StockMaster (StockID);
ALTER TABLE weberp_BOM ADD FOREIGN KEY (Component) REFERENCES StockMaster (StockID);
ALTER TABLE weberp_BOM ADD FOREIGN KEY (WorkCentreAdded) REFERENCES WorkCentres (Code);
ALTER TABLE weberp_BOM ADD FOREIGN KEY (LocCode) REFERENCES Locations (LocCode);

ALTER TABLE weberp_BankAccounts ADD FOREIGN KEY (AccountCode) REFERENCES ChartMaster (AccountCode);


ALTER TABLE weberp_BankTrans ADD FOREIGN KEY (Type) REFERENCES SysTypes (TypeID);
ALTER TABLE weberp_BankTrans ADD FOREIGN KEY (BankAct) REFERENCES BankAccounts (AccountCode);


ALTER TABLE weberp_Buckets ADD FOREIGN KEY (WorkCentre) REFERENCES WorkCentres (Code);

ALTER TABLE weberp_ChartDetails ADD FOREIGN KEY (AccountCode) REFERENCES ChartMaster (AccountCode);
ALTER TABLE weberp_ChartDetails ADD FOREIGN KEY (Period) REFERENCES Periods (PeriodNo);


ALTER TABLE weberp_ChartMaster ADD FOREIGN KEY (Group_) REFERENCES AccountGroups (GroupName);


ALTER TABLE weberp_ContractBOM ADD INDEX (WorkCentreAdded);

ALTER TABLE weberp_ContractBOM ADD FOREIGN KEY (WorkCentreAdded) REFERENCES WorkCentres (Code);

ALTER TABLE weberp_ContractBOM ADD FOREIGN KEY (LocCode) REFERENCES Locations (LocCode);
ALTER TABLE weberp_ContractBOM ADD FOREIGN KEY (Component) REFERENCES StockMaster (StockID);


ALTER TABLE weberp_ContractReqts ADD FOREIGN KEY (Contract) REFERENCES Contracts (ContractRef);


ALTER TABLE `weberp_Contracts` DROP INDEX `DebtorNo` , DROP INDEX `BranchCode`, ADD INDEX `DebtorNo` ( `DebtorNo` , `BranchCode` );

ALTER TABLE weberp_Contracts ADD FOREIGN KEY (DebtorNo, BranchCode) REFERENCES CustBranch (DebtorNo, BranchCode);
ALTER TABLE weberp_Contracts ADD FOREIGN KEY (CategoryID) REFERENCES StockCategory (CategoryID);

ALTER TABLE weberp_Contracts ADD FOREIGN KEY (TypeAbbrev) REFERENCES SalesTypes (TypeAbbrev);


ALTER TABLE weberp_CustAllocns ADD FOREIGN KEY (TransID_AllocFrom) REFERENCES DebtorTrans (ID);
ALTER TABLE weberp_CustAllocns ADD FOREIGN KEY (TransID_AllocTo) REFERENCES DebtorTrans (ID);

ALTER TABLE weberp_CustBranch ADD FOREIGN KEY (DebtorNo) REFERENCES DebtorsMaster (DebtorNo);

ALTER TABLE weberp_CustBranch ADD INDEX (Area);
ALTER TABLE weberp_CustBranch ADD FOREIGN KEY (Area) REFERENCES Areas (AreaCode);
ALTER TABLE weberp_CustBranch ADD FOREIGN KEY (Salesman) REFERENCES Salesman (SalesmanCode);

ALTER TABLE `weberp_CustBranch` ADD INDEX ( `DefaultLocation` );
ALTER TABLE `weberp_CustBranch` ADD INDEX ( `TaxAuthority` );
ALTER TABLE `weberp_CustBranch` ADD INDEX ( `DefaultShipVia` );

ALTER TABLE weberp_CustBranch ADD FOREIGN KEY (DefaultLocation) REFERENCES Locations (LocCode);

ALTER TABLE `weberp_CustBranch` CHANGE `TaxAuthority` `TaxAuthority` TINYINT DEFAULT '1' NOT NULL;

ALTER TABLE weberp_CustBranch ADD FOREIGN KEY (TaxAuthority) REFERENCES TaxAuthorities (TaxID);
ALTER TABLE weberp_CustBranch ADD FOREIGN KEY (DefaultShipVia) REFERENCES Shippers (Shipper_ID);

ALTER TABLE weberp_DebtorTrans ADD FOREIGN KEY (DebtorNo) REFERENCES CustBranch (DebtorNo);
ALTER TABLE weberp_DebtorTrans ADD FOREIGN KEY (Type) REFERENCES SysTypes (TypeID);
ALTER TABLE weberp_DebtorTrans ADD FOREIGN KEY (Prd) REFERENCES Periods (PeriodNo);

ALTER TABLE weberp_DebtorsMaster ADD FOREIGN KEY (HoldReason) REFERENCES HoldReasons (ReasonCode);
ALTER TABLE `weberp_DebtorsMaster` CHANGE `CurrCode` `CurrCode` VARCHAR( 3 ) NOT NULL;

ALTER TABLE weberp_DebtorsMaster ADD FOREIGN KEY (CurrCode) REFERENCES Currencies (CurrAbrev);
ALTER TABLE weberp_DebtorsMaster ADD FOREIGN KEY (PaymentTerms) REFERENCES PaymentTerms (TermsIndicator);
ALTER TABLE weberp_DebtorsMaster ADD FOREIGN KEY (SalesType) REFERENCES SalesTypes (TypeAbbrev);
ALTER TABLE weberp_DiscountMatrix ADD FOREIGN KEY (SalesType) REFERENCES SalesTypes (TypeAbbrev);
ALTER TABLE weberp_EDIItemMapping ADD FOREIGN KEY (StockID) REFERENCES StockMaster (StockID);
ALTER TABLE weberp_FreightCosts ADD FOREIGN KEY (LocationFrom) REFERENCES Locations (LocCode);

ALTER TABLE weberp_FreightCosts ADD FOREIGN KEY (ShipperID) REFERENCES Shippers (Shipper_ID);
ALTER TABLE weberp_GLTrans ADD FOREIGN KEY (Account) REFERENCES ChartMaster (AccountCode);
ALTER TABLE weberp_GLTrans ADD FOREIGN KEY (Type) REFERENCES SysTypes (TypeID);
ALTER TABLE weberp_GLTrans ADD FOREIGN KEY (PeriodNo) REFERENCES Periods (PeriodNo);
ALTER TABLE weberp_GRNs ADD FOREIGN KEY (SupplierID) REFERENCES Suppliers (SupplierID);
ALTER TABLE weberp_GRNs ADD FOREIGN KEY (PODetailItem) REFERENCES PurchOrderDetails (PODetailItem);

ALTER TABLE weberp_LocStock ADD FOREIGN KEY (LocCode) REFERENCES Locations (LocCode);
ALTER TABLE weberp_LocStock ADD FOREIGN KEY (StockID) REFERENCES StockMaster (StockID);

ALTER TABLE weberp_OrderDeliveryDifferencesLog ADD FOREIGN KEY (StockID) REFERENCES StockMaster (StockID);

ALTER TABLE weberp_OrderDeliveryDifferencesLog ADD FOREIGN KEY (DebtorNo,Branch) REFERENCES CustBranch (DebtorNo,BranchCode);
ALTER TABLE `weberp_OrderDeliveryDifferencesLog` ADD INDEX ( `OrderNo` );
ALTER TABLE weberp_OrderDeliveryDifferencesLog ADD FOREIGN KEY (OrderNo) REFERENCES SalesOrders (OrderNo);

ALTER TABLE weberp_Prices ADD FOREIGN KEY (StockID) REFERENCES StockMaster (StockID);
ALTER TABLE weberp_Prices ADD FOREIGN KEY (CurrAbrev) REFERENCES Currencies (CurrAbrev);
ALTER TABLE weberp_Prices ADD FOREIGN KEY (TypeAbbrev) REFERENCES SalesTypes (TypeAbbrev);

ALTER TABLE weberp_PurchData ADD FOREIGN KEY (StockID) REFERENCES StockMaster (StockID);
ALTER TABLE weberp_PurchData ADD FOREIGN KEY (SupplierNo) REFERENCES Suppliers (SupplierID);

ALTER TABLE weberp_PurchOrderDetails ADD FOREIGN KEY (OrderNo) REFERENCES PurchOrders (OrderNo);

ALTER TABLE weberp_PurchOrders ADD FOREIGN KEY (SupplierNo) REFERENCES Suppliers (SupplierID);
ALTER TABLE weberp_PurchOrders ADD FOREIGN KEY (IntoStockLocation) REFERENCES Locations (LocCode);

ALTER TABLE weberp_ReportColumns ADD FOREIGN KEY (ReportID) REFERENCES ReportHeaders (ReportID);

ALTER TABLE `weberp_SalesAnalysis` CHANGE `PeriodNo` `PeriodNo` SMALLINT( 6 ) DEFAULT '0' NOT NULL ;
ALTER TABLE weberp_SalesAnalysis ADD FOREIGN KEY (PeriodNo) REFERENCES Periods (PeriodNo);

ALTER TABLE weberp_SalesOrderDetails ADD FOREIGN KEY (OrderNo) REFERENCES SalesOrders (OrderNo);
ALTER TABLE weberp_SalesOrderDetails ADD FOREIGN KEY (StkCode) REFERENCES StockMaster (StockID);

ALTER TABLE `weberp_SalesOrders` DROP INDEX `BranchCode`;
ALTER TABLE `weberp_SalesOrders` ADD INDEX ( `BranchCode`,`DebtorNo` );

ALTER TABLE weberp_SalesOrders ADD FOREIGN KEY (BranchCode, DebtorNo) REFERENCES CustBranch (BranchCode, DebtorNo);
ALTER TABLE `weberp_SalesOrders` ADD INDEX ( `ShipVia` );
ALTER TABLE weberp_SalesOrders ADD FOREIGN KEY (ShipVia) REFERENCES Shippers (Shipper_ID);
ALTER TABLE weberp_SalesOrders ADD FOREIGN KEY (FromStkLoc) REFERENCES Locations (LocCode);

ALTER TABLE weberp_Shipments CHANGE ShiptRef ShiptRef INT(11) NOT NULL;
ALTER TABLE `weberp_ShipmentCharges` CHANGE `ShiptRef` `ShiptRef` INT( 11 ) NOT NULL;
ALTER TABLE weberp_ShipmentCharges ADD FOREIGN KEY (ShiptRef) REFERENCES Shipments (ShiptRef);
ALTER TABLE `weberp_ShipmentCharges` ADD INDEX ( `TransType` );
ALTER TABLE weberp_ShipmentCharges ADD FOREIGN KEY (TransType) REFERENCES SysTypes (TypeID);
ALTER TABLE weberp_ShipmentCharges ADD FOREIGN KEY (StockID) REFERENCES StockMaster (StockID);

ALTER TABLE `weberp_Shipments` ADD FOREIGN KEY (SupplierID) REFERENCES Suppliers (SupplierID);

ALTER TABLE `weberp_StockCheckFreeze` ADD FOREIGN KEY (StockID) REFERENCES StockMaster (StockID);
ALTER TABLE `weberp_StockCheckFreeze` ADD FOREIGN KEY (LocCode) REFERENCES Locations (LocCode);

ALTER TABLE `weberp_StockCounts` ADD FOREIGN KEY (StockID) REFERENCES StockMaster (StockID);
ALTER TABLE `weberp_StockCounts` ADD FOREIGN KEY (LocCode) REFERENCES Locations (LocCode);

ALTER TABLE `weberp_StockMaster` ADD FOREIGN KEY (CategoryID) REFERENCES StockCategory (CategoryID);

ALTER TABLE `weberp_StockMoves` ADD FOREIGN KEY (StockID) REFERENCES StockMaster (StockID);
ALTER TABLE `weberp_StockMoves` ADD FOREIGN KEY (Type) REFERENCES SysTypes (TypeID);
ALTER TABLE `weberp_StockMoves` ADD FOREIGN KEY (LocCode) REFERENCES Locations (LocCode);
ALTER TABLE `weberp_StockMoves` ADD FOREIGN KEY (Prd) REFERENCES Periods (PeriodNo);

DELETE FROM SuppAllocs WHERE ID=4;

ALTER TABLE weberp_SuppAllocs ADD FOREIGN KEY (TransID_AllocFrom) REFERENCES SuppTrans (ID);
ALTER TABLE `weberp_SuppAllocs` ADD FOREIGN KEY (TransID_AllocTo) REFERENCES SuppTrans (ID);

ALTER TABLE `weberp_SuppTrans` ADD FOREIGN KEY (Type) REFERENCES SysTypes (TypeID);
ALTER TABLE `weberp_SuppTrans` ADD FOREIGN KEY (SupplierNo) REFERENCES Suppliers (SupplierID);
ALTER TABLE `weberp_SupplierContacts` ADD FOREIGN KEY (SupplierID) REFERENCES Suppliers (SupplierID);
ALTER TABLE `weberp_Suppliers` ADD FOREIGN KEY (CurrCode) REFERENCES Currencies (CurrAbrev);
ALTER TABLE `weberp_Suppliers` ADD FOREIGN KEY (PaymentTerms) REFERENCES PaymentTerms (TermsIndicator);

ALTER TABLE `weberp_Suppliers` CHANGE `TaxAuthority` `TaxAuthority` TINYINT DEFAULT '1' NOT NULL;

ALTER TABLE `weberp_Suppliers` ADD FOREIGN KEY (TaxAuthority) REFERENCES TaxAuthorities (TaxID);
ALTER TABLE `weberp_WOIssues` ADD FOREIGN KEY (WORef) REFERENCES WorksOrders (WORef);
ALTER TABLE `weberp_WOIssues` ADD FOREIGN KEY (StockID) REFERENCES StockMaster (StockID);
ALTER TABLE `weberp_WOIssues` ADD FOREIGN KEY (WorkCentre) REFERENCES WorkCentres (Code);

ALTER TABLE `weberp_WORequirements` ADD FOREIGN KEY (WORef) REFERENCES WorksOrders (WORef);
ALTER TABLE `weberp_WORequirements` ADD FOREIGN KEY (StockID) REFERENCES StockMaster (StockID);
ALTER TABLE `weberp_WORequirements` ADD FOREIGN KEY (WrkCentre) REFERENCES WorkCentres (Code);

ALTER TABLE `weberp_WWW_Users` ADD INDEX ( `DefaultLocation` );

ALTER TABLE `weberp_WWW_Users` ADD FOREIGN KEY (DefaultLocation) REFERENCES Locations (LocCode);

ALTER TABLE `weberp_WorkCentres` ADD FOREIGN KEY (Location) REFERENCES Locations (LocCode);

ALTER TABLE `weberp_WorksOrders` ADD FOREIGN KEY (LocCode) REFERENCES Locations (LocCode);
ALTER TABLE `weberp_WorksOrders` ADD FOREIGN KEY (StockID) REFERENCES StockMaster (StockID);

ALTER TABLE weberp_DebtorsMaster ADD DiscountCode char(2) NOT NULL default '';

commit;