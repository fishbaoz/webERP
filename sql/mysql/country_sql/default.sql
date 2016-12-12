SET FOREIGN_KEY_CHECKS = 0;
-- MySQL dump 10.13  Distrib 5.5.46, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: weberpdemo
-- ------------------------------------------------------
-- Server version	5.5.46-0ubuntu0.14.04.2
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accountgroups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_accountgroups` (
  `groupname` char(30) NOT NULL DEFAULT '',
  `sectioninaccounts` int(11) NOT NULL DEFAULT '0',
  `pandl` tinyint(4) NOT NULL DEFAULT '1',
  `sequenceintb` smallint(6) NOT NULL DEFAULT '0',
  `parentgroupname` varchar(30) NOT NULL,
  PRIMARY KEY (`groupname`),
  KEY `SequenceInTB` (`sequenceintb`),
  KEY `sectioninaccounts` (`sectioninaccounts`),
  KEY `parentgroupname` (`parentgroupname`),
  CONSTRAINT `accountgroups_ibfk_1` FOREIGN KEY (`sectioninaccounts`) REFERENCES `weberp_accountsection` (`sectionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `accountsection`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_accountsection` (
  `sectionid` int(11) NOT NULL DEFAULT '0',
  `sectionname` text NOT NULL,
  PRIMARY KEY (`sectionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `areas`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_areas` (
  `areacode` char(3) NOT NULL,
  `areadescription` varchar(25) NOT NULL DEFAULT '',
  PRIMARY KEY (`areacode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assetmanager`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_assetmanager` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `serialno` varchar(30) NOT NULL DEFAULT '',
  `location` varchar(15) NOT NULL DEFAULT '',
  `cost` double NOT NULL DEFAULT '0',
  `depn` double NOT NULL DEFAULT '0',
  `datepurchased` date NOT NULL DEFAULT '2016-01-01',
  `disposalvalue` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `audittrail`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_audittrail` (
  `transactiondate` datetime NOT NULL DEFAULT '2016-01-01 00:00:00',
  `userid` varchar(20) NOT NULL DEFAULT '',
  `querystring` text,
  KEY `UserID` (`userid`),
  KEY `transactiondate` (`transactiondate`),
  KEY `transactiondate_2` (`transactiondate`),
  KEY `transactiondate_3` (`transactiondate`),
  CONSTRAINT `audittrail_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `weberp_www_users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bankaccounts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_bankaccounts` (
  `accountcode` varchar(20) NOT NULL DEFAULT '0',
  `currcode` char(3) NOT NULL,
  `invoice` smallint(2) NOT NULL DEFAULT '0',
  `bankaccountcode` varchar(50) NOT NULL DEFAULT '',
  `bankaccountname` char(50) NOT NULL DEFAULT '',
  `bankaccountnumber` char(50) NOT NULL DEFAULT '',
  `bankaddress` char(50) DEFAULT NULL,
  `importformat` varchar(10) NOT NULL DEFAULT '''''',
  PRIMARY KEY (`accountcode`),
  KEY `currcode` (`currcode`),
  KEY `BankAccountName` (`bankaccountname`),
  KEY `BankAccountNumber` (`bankaccountnumber`),
  CONSTRAINT `bankaccounts_ibfk_1` FOREIGN KEY (`accountcode`) REFERENCES `weberp_chartmaster` (`accountcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bankaccountusers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_bankaccountusers` (
  `accountcode` varchar(20) NOT NULL COMMENT 'Bank account code',
  `userid` varchar(20) NOT NULL COMMENT 'User code'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `banktrans`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_banktrans` (
  `banktransid` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL DEFAULT '0',
  `transno` bigint(20) NOT NULL DEFAULT '0',
  `bankact` varchar(20) NOT NULL DEFAULT '0',
  `ref` varchar(50) NOT NULL DEFAULT '',
  `amountcleared` double NOT NULL DEFAULT '0',
  `exrate` double NOT NULL DEFAULT '1' COMMENT 'From bank account currency to payment currency',
  `functionalexrate` double NOT NULL DEFAULT '1' COMMENT 'Account currency to functional currency',
  `transdate` date NOT NULL DEFAULT '2016-01-01',
  `banktranstype` varchar(30) NOT NULL DEFAULT '',
  `amount` double NOT NULL DEFAULT '0',
  `currcode` char(3) NOT NULL DEFAULT '',
  PRIMARY KEY (`banktransid`),
  KEY `BankAct` (`bankact`,`ref`),
  KEY `TransDate` (`transdate`),
  KEY `TransType` (`banktranstype`),
  KEY `Type` (`type`,`transno`),
  KEY `CurrCode` (`currcode`),
  KEY `ref` (`ref`),
  CONSTRAINT `banktrans_ibfk_1` FOREIGN KEY (`type`) REFERENCES `weberp_systypes` (`typeid`),
  CONSTRAINT `banktrans_ibfk_2` FOREIGN KEY (`bankact`) REFERENCES `weberp_bankaccounts` (`accountcode`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_bom` (
  `parent` char(20) NOT NULL DEFAULT '',
  `sequence` int(11) NOT NULL DEFAULT '0',
  `component` char(20) NOT NULL DEFAULT '',
  `workcentreadded` char(5) NOT NULL DEFAULT '',
  `loccode` char(5) NOT NULL DEFAULT '',
  `effectiveafter` date NOT NULL DEFAULT '2016-01-01',
  `effectiveto` date NOT NULL DEFAULT '9999-12-31',
  `quantity` double NOT NULL DEFAULT '1',
  `autoissue` tinyint(4) NOT NULL DEFAULT '0',
  `remark` varchar(500) NOT NULL DEFAULT '',
  `digitals` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`parent`,`component`,`workcentreadded`,`loccode`),
  KEY `Component` (`component`),
  KEY `EffectiveAfter` (`effectiveafter`),
  KEY `EffectiveTo` (`effectiveto`),
  KEY `LocCode` (`loccode`),
  KEY `Parent` (`parent`,`effectiveafter`,`effectiveto`,`loccode`),
  KEY `Parent_2` (`parent`),
  KEY `WorkCentreAdded` (`workcentreadded`),
  CONSTRAINT `bom_ibfk_1` FOREIGN KEY (`parent`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `bom_ibfk_2` FOREIGN KEY (`component`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `bom_ibfk_3` FOREIGN KEY (`workcentreadded`) REFERENCES `weberp_workcentres` (`code`),
  CONSTRAINT `bom_ibfk_4` FOREIGN KEY (`loccode`) REFERENCES `weberp_locations` (`loccode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chartdetails`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_chartdetails` (
  `accountcode` varchar(20) NOT NULL DEFAULT '0',
  `period` smallint(6) NOT NULL DEFAULT '0',
  `budget` double NOT NULL DEFAULT '0',
  `actual` double NOT NULL DEFAULT '0',
  `bfwd` double NOT NULL DEFAULT '0',
  `bfwdbudget` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`accountcode`,`period`),
  KEY `Period` (`period`),
  CONSTRAINT `chartdetails_ibfk_1` FOREIGN KEY (`accountcode`) REFERENCES `weberp_chartmaster` (`accountcode`),
  CONSTRAINT `chartdetails_ibfk_2` FOREIGN KEY (`period`) REFERENCES `weberp_periods` (`periodno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chartmaster`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_chartmaster` (
  `accountcode` varchar(20) NOT NULL DEFAULT '0',
  `accountname` char(50) NOT NULL DEFAULT '',
  `group_` char(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`accountcode`),
  KEY `AccountName` (`accountname`),
  KEY `Group_` (`group_`),
  CONSTRAINT `chartmaster_ibfk_1` FOREIGN KEY (`group_`) REFERENCES `weberp_accountgroups` (`groupname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cogsglpostings`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_cogsglpostings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `area` char(3) NOT NULL DEFAULT '',
  `stkcat` varchar(6) NOT NULL DEFAULT '',
  `glcode` varchar(20) NOT NULL DEFAULT '0',
  `salestype` char(2) NOT NULL DEFAULT 'AN',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Area_StkCat` (`area`,`stkcat`,`salestype`),
  KEY `Area` (`area`),
  KEY `StkCat` (`stkcat`),
  KEY `GLCode` (`glcode`),
  KEY `SalesType` (`salestype`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `companies`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_companies` (
  `coycode` int(11) NOT NULL DEFAULT '1',
  `coyname` varchar(50) NOT NULL DEFAULT '',
  `gstno` varchar(20) NOT NULL DEFAULT '',
  `companynumber` varchar(20) NOT NULL DEFAULT '0',
  `regoffice1` varchar(40) NOT NULL DEFAULT '',
  `regoffice2` varchar(40) NOT NULL DEFAULT '',
  `regoffice3` varchar(40) NOT NULL DEFAULT '',
  `regoffice4` varchar(40) NOT NULL DEFAULT '',
  `regoffice5` varchar(20) NOT NULL DEFAULT '',
  `regoffice6` varchar(15) NOT NULL DEFAULT '',
  `telephone` varchar(25) NOT NULL DEFAULT '',
  `fax` varchar(25) NOT NULL DEFAULT '',
  `email` varchar(55) NOT NULL DEFAULT '',
  `currencydefault` varchar(4) NOT NULL DEFAULT '',
  `debtorsact` varchar(20) NOT NULL DEFAULT '70000',
  `pytdiscountact` varchar(20) NOT NULL DEFAULT '55000',
  `creditorsact` varchar(20) NOT NULL DEFAULT '80000',
  `payrollact` varchar(20) NOT NULL DEFAULT '84000',
  `grnact` varchar(20) NOT NULL DEFAULT '72000',
  `exchangediffact` varchar(20) NOT NULL DEFAULT '65000',
  `purchasesexchangediffact` varchar(20) NOT NULL DEFAULT '0',
  `retainedearnings` varchar(20) NOT NULL DEFAULT '90000',
  `gllink_debtors` tinyint(1) DEFAULT '1',
  `gllink_creditors` tinyint(1) DEFAULT '1',
  `gllink_stock` tinyint(1) DEFAULT '1',
  `freightact` varchar(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`coycode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_config` (
  `confname` varchar(35) NOT NULL DEFAULT '',
  `confvalue` text NOT NULL,
  PRIMARY KEY (`confname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contractbom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_contractbom` (
  `contractref` varchar(20) NOT NULL DEFAULT '0',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `workcentreadded` char(5) NOT NULL DEFAULT '',
  `quantity` double NOT NULL DEFAULT '1',
  PRIMARY KEY (`contractref`,`stockid`,`workcentreadded`),
  KEY `Stockid` (`stockid`),
  KEY `ContractRef` (`contractref`),
  KEY `WorkCentreAdded` (`workcentreadded`),
  CONSTRAINT `contractbom_ibfk_1` FOREIGN KEY (`workcentreadded`) REFERENCES `weberp_workcentres` (`code`),
  CONSTRAINT `contractbom_ibfk_3` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contractcharges`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_contractcharges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contractref` varchar(20) NOT NULL,
  `transtype` smallint(6) NOT NULL DEFAULT '20',
  `transno` int(11) NOT NULL DEFAULT '0',
  `amount` double NOT NULL DEFAULT '0',
  `narrative` text NOT NULL,
  `anticipated` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `contractref` (`contractref`,`transtype`,`transno`),
  KEY `contractcharges_ibfk_2` (`transtype`),
  CONSTRAINT `contractcharges_ibfk_1` FOREIGN KEY (`contractref`) REFERENCES `weberp_contracts` (`contractref`),
  CONSTRAINT `contractcharges_ibfk_2` FOREIGN KEY (`transtype`) REFERENCES `weberp_systypes` (`typeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contractreqts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_contractreqts` (
  `contractreqid` int(11) NOT NULL AUTO_INCREMENT,
  `contractref` varchar(20) NOT NULL DEFAULT '0',
  `requirement` varchar(40) NOT NULL DEFAULT '',
  `quantity` double NOT NULL DEFAULT '1',
  `costperunit` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`contractreqid`),
  KEY `ContractRef` (`contractref`),
  CONSTRAINT `contractreqts_ibfk_1` FOREIGN KEY (`contractref`) REFERENCES `weberp_contracts` (`contractref`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contracts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_contracts` (
  `contractref` varchar(20) NOT NULL DEFAULT '',
  `contractdescription` text NOT NULL,
  `debtorno` varchar(10) NOT NULL DEFAULT '',
  `branchcode` varchar(10) NOT NULL DEFAULT '',
  `loccode` varchar(5) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `categoryid` varchar(6) NOT NULL DEFAULT '',
  `orderno` int(11) NOT NULL DEFAULT '0',
  `customerref` varchar(20) NOT NULL DEFAULT '',
  `margin` double NOT NULL DEFAULT '1',
  `wo` int(11) NOT NULL DEFAULT '0',
  `requireddate` date NOT NULL DEFAULT '2016-01-01',
  `drawing` varchar(50) NOT NULL DEFAULT '',
  `exrate` double NOT NULL DEFAULT '1',
  PRIMARY KEY (`contractref`),
  KEY `OrderNo` (`orderno`),
  KEY `CategoryID` (`categoryid`),
  KEY `Status` (`status`),
  KEY `WO` (`wo`),
  KEY `loccode` (`loccode`),
  KEY `DebtorNo` (`debtorno`,`branchcode`),
  CONSTRAINT `contracts_ibfk_1` FOREIGN KEY (`debtorno`, `branchcode`) REFERENCES `weberp_custbranch` (`debtorno`, `branchcode`),
  CONSTRAINT `contracts_ibfk_2` FOREIGN KEY (`categoryid`) REFERENCES `weberp_stockcategory` (`categoryid`),
  CONSTRAINT `contracts_ibfk_3` FOREIGN KEY (`loccode`) REFERENCES `weberp_locations` (`loccode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `currencies`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_currencies` (
  `currency` char(20) NOT NULL DEFAULT '',
  `currabrev` char(3) NOT NULL DEFAULT '',
  `country` char(50) NOT NULL DEFAULT '',
  `hundredsname` char(15) NOT NULL DEFAULT 'Cents',
  `decimalplaces` tinyint(3) NOT NULL DEFAULT '2',
  `rate` double NOT NULL DEFAULT '1',
  `webcart` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'If 1 shown in weberp cart. if 0 no show',
  PRIMARY KEY (`currabrev`),
  KEY `Country` (`country`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `custallocns`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_custallocns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amt` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `datealloc` date NOT NULL DEFAULT '2016-01-01',
  `transid_allocfrom` int(11) NOT NULL DEFAULT '0',
  `transid_allocto` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `DateAlloc` (`datealloc`),
  KEY `TransID_AllocFrom` (`transid_allocfrom`),
  KEY `TransID_AllocTo` (`transid_allocto`),
  CONSTRAINT `custallocns_ibfk_1` FOREIGN KEY (`transid_allocfrom`) REFERENCES `weberp_debtortrans` (`id`),
  CONSTRAINT `custallocns_ibfk_2` FOREIGN KEY (`transid_allocto`) REFERENCES `weberp_debtortrans` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `custbranch`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_custbranch` (
  `branchcode` varchar(10) NOT NULL DEFAULT '',
  `debtorno` varchar(10) NOT NULL DEFAULT '',
  `brname` varchar(40) NOT NULL DEFAULT '',
  `braddress1` varchar(40) NOT NULL DEFAULT '',
  `braddress2` varchar(40) NOT NULL DEFAULT '',
  `braddress3` varchar(40) NOT NULL DEFAULT '',
  `braddress4` varchar(50) NOT NULL DEFAULT '',
  `braddress5` varchar(20) NOT NULL DEFAULT '',
  `braddress6` varchar(40) NOT NULL DEFAULT '',
  `lat` float(10,6) NOT NULL DEFAULT '0.000000',
  `lng` float(10,6) NOT NULL DEFAULT '0.000000',
  `estdeliverydays` smallint(6) NOT NULL DEFAULT '1',
  `area` char(3) NOT NULL,
  `salesman` varchar(4) NOT NULL DEFAULT '',
  `fwddate` smallint(6) NOT NULL DEFAULT '0',
  `phoneno` varchar(20) NOT NULL DEFAULT '',
  `faxno` varchar(20) NOT NULL DEFAULT '',
  `contactname` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(55) NOT NULL DEFAULT '',
  `defaultlocation` varchar(5) NOT NULL DEFAULT '',
  `taxgroupid` tinyint(4) NOT NULL DEFAULT '1',
  `defaultshipvia` int(11) NOT NULL DEFAULT '1',
  `deliverblind` tinyint(1) DEFAULT '1',
  `disabletrans` tinyint(4) NOT NULL DEFAULT '0',
  `brpostaddr1` varchar(40) NOT NULL DEFAULT '',
  `brpostaddr2` varchar(40) NOT NULL DEFAULT '',
  `brpostaddr3` varchar(40) NOT NULL DEFAULT '',
  `brpostaddr4` varchar(50) NOT NULL DEFAULT '',
  `brpostaddr5` varchar(20) NOT NULL DEFAULT '',
  `brpostaddr6` varchar(40) NOT NULL DEFAULT '',
  `specialinstructions` text NOT NULL,
  `custbranchcode` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`branchcode`,`debtorno`),
  KEY `BrName` (`brname`),
  KEY `DebtorNo` (`debtorno`),
  KEY `Salesman` (`salesman`),
  KEY `Area` (`area`),
  KEY `DefaultLocation` (`defaultlocation`),
  KEY `DefaultShipVia` (`defaultshipvia`),
  KEY `taxgroupid` (`taxgroupid`),
  CONSTRAINT `custbranch_ibfk_1` FOREIGN KEY (`debtorno`) REFERENCES `weberp_debtorsmaster` (`debtorno`),
  CONSTRAINT `custbranch_ibfk_2` FOREIGN KEY (`area`) REFERENCES `weberp_areas` (`areacode`),
  CONSTRAINT `custbranch_ibfk_3` FOREIGN KEY (`salesman`) REFERENCES `weberp_salesman` (`salesmancode`),
  CONSTRAINT `custbranch_ibfk_4` FOREIGN KEY (`defaultlocation`) REFERENCES `weberp_locations` (`loccode`),
  CONSTRAINT `custbranch_ibfk_6` FOREIGN KEY (`defaultshipvia`) REFERENCES `weberp_shippers` (`shipper_id`),
  CONSTRAINT `custbranch_ibfk_7` FOREIGN KEY (`taxgroupid`) REFERENCES `weberp_taxgroups` (`taxgroupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `custcontacts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_custcontacts` (
  `contid` int(11) NOT NULL AUTO_INCREMENT,
  `debtorno` varchar(10) NOT NULL,
  `contactname` varchar(40) NOT NULL,
  `role` varchar(40) NOT NULL,
  `phoneno` varchar(20) NOT NULL,
  `notes` varchar(255) NOT NULL,
  `email` varchar(55) NOT NULL,
  PRIMARY KEY (`contid`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `custitem`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_custitem` (
  `debtorno` char(10) NOT NULL DEFAULT '',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `cust_part` varchar(20) NOT NULL DEFAULT '',
  `cust_description` varchar(30) NOT NULL DEFAULT '',
  `customersuom` char(50) NOT NULL DEFAULT '',
  `conversionfactor` double NOT NULL DEFAULT '1',
  PRIMARY KEY (`debtorno`,`stockid`),
  KEY `StockID` (`stockid`),
  KEY `Debtorno` (`debtorno`),
  CONSTRAINT ` custitem _ibfk_1` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT ` custitem _ibfk_2` FOREIGN KEY (`debtorno`) REFERENCES `weberp_debtorsmaster` (`debtorno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `custnotes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_custnotes` (
  `noteid` tinyint(4) NOT NULL AUTO_INCREMENT,
  `debtorno` varchar(10) NOT NULL DEFAULT '0',
  `href` varchar(100) NOT NULL,
  `note` text NOT NULL,
  `date` date NOT NULL DEFAULT '2016-01-01',
  `priority` varchar(20) NOT NULL,
  PRIMARY KEY (`noteid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `debtorsmaster`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_debtorsmaster` (
  `debtorno` varchar(10) NOT NULL DEFAULT '',
  `name` varchar(40) NOT NULL DEFAULT '',
  `address1` varchar(40) NOT NULL DEFAULT '',
  `address2` varchar(40) NOT NULL DEFAULT '',
  `address3` varchar(40) NOT NULL DEFAULT '',
  `address4` varchar(50) NOT NULL DEFAULT '',
  `address5` varchar(20) NOT NULL DEFAULT '',
  `address6` varchar(40) NOT NULL DEFAULT '',
  `currcode` char(3) NOT NULL DEFAULT '',
  `salestype` char(2) NOT NULL DEFAULT '',
  `clientsince` datetime NOT NULL DEFAULT '2016-01-01 00:00:00',
  `holdreason` smallint(6) NOT NULL DEFAULT '0',
  `paymentterms` char(2) NOT NULL DEFAULT 'f',
  `discount` double NOT NULL DEFAULT '0',
  `pymtdiscount` double NOT NULL DEFAULT '0',
  `lastpaid` double NOT NULL DEFAULT '0',
  `lastpaiddate` datetime DEFAULT NULL,
  `creditlimit` double NOT NULL DEFAULT '1000',
  `invaddrbranch` tinyint(4) NOT NULL DEFAULT '0',
  `discountcode` char(2) NOT NULL DEFAULT '',
  `ediinvoices` tinyint(4) NOT NULL DEFAULT '0',
  `ediorders` tinyint(4) NOT NULL DEFAULT '0',
  `edireference` varchar(20) NOT NULL DEFAULT '',
  `editransport` varchar(5) NOT NULL DEFAULT 'email',
  `ediaddress` varchar(50) NOT NULL DEFAULT '',
  `ediserveruser` varchar(20) NOT NULL DEFAULT '',
  `ediserverpwd` varchar(20) NOT NULL DEFAULT '',
  `taxref` varchar(20) NOT NULL DEFAULT '',
  `customerpoline` tinyint(1) NOT NULL DEFAULT '0',
  `typeid` tinyint(4) NOT NULL DEFAULT '1',
  `language_id` varchar(10) NOT NULL DEFAULT 'en_GB.utf8',
  PRIMARY KEY (`debtorno`),
  KEY `Currency` (`currcode`),
  KEY `HoldReason` (`holdreason`),
  KEY `Name` (`name`),
  KEY `PaymentTerms` (`paymentterms`),
  KEY `SalesType` (`salestype`),
  KEY `EDIInvoices` (`ediinvoices`),
  KEY `EDIOrders` (`ediorders`),
  KEY `debtorsmaster_ibfk_5` (`typeid`),
  CONSTRAINT `debtorsmaster_ibfk_1` FOREIGN KEY (`holdreason`) REFERENCES `weberp_holdreasons` (`reasoncode`),
  CONSTRAINT `debtorsmaster_ibfk_2` FOREIGN KEY (`currcode`) REFERENCES `weberp_currencies` (`currabrev`),
  CONSTRAINT `debtorsmaster_ibfk_3` FOREIGN KEY (`paymentterms`) REFERENCES `weberp_paymentterms` (`termsindicator`),
  CONSTRAINT `debtorsmaster_ibfk_4` FOREIGN KEY (`salestype`) REFERENCES `weberp_salestypes` (`typeabbrev`),
  CONSTRAINT `debtorsmaster_ibfk_5` FOREIGN KEY (`typeid`) REFERENCES `weberp_debtortype` (`typeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `debtortrans`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_debtortrans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transno` int(11) NOT NULL DEFAULT '0',
  `type` smallint(6) NOT NULL DEFAULT '0',
  `debtorno` varchar(10) NOT NULL DEFAULT '',
  `branchcode` varchar(10) NOT NULL DEFAULT '',
  `trandate` datetime NOT NULL DEFAULT '2016-01-01 00:00:00',
  `inputdate` datetime NOT NULL,
  `prd` smallint(6) NOT NULL DEFAULT '0',
  `settled` tinyint(4) NOT NULL DEFAULT '0',
  `reference` varchar(20) NOT NULL DEFAULT '',
  `tpe` char(2) NOT NULL DEFAULT '',
  `order_` int(11) NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '0',
  `ovamount` double NOT NULL DEFAULT '0',
  `ovgst` double NOT NULL DEFAULT '0',
  `ovfreight` double NOT NULL DEFAULT '0',
  `ovdiscount` double NOT NULL DEFAULT '0',
  `diffonexch` double NOT NULL DEFAULT '0',
  `alloc` double NOT NULL DEFAULT '0',
  `invtext` text,
  `shipvia` int(11) NOT NULL DEFAULT '0',
  `edisent` tinyint(4) NOT NULL DEFAULT '0',
  `consignment` varchar(20) NOT NULL DEFAULT '',
  `packages` int(11) NOT NULL DEFAULT '1' COMMENT 'number of cartons',
  `salesperson` varchar(4) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `DebtorNo` (`debtorno`,`branchcode`),
  KEY `Order_` (`order_`),
  KEY `Prd` (`prd`),
  KEY `Tpe` (`tpe`),
  KEY `Type` (`type`),
  KEY `Settled` (`settled`),
  KEY `TranDate` (`trandate`),
  KEY `TransNo` (`transno`),
  KEY `Type_2` (`type`,`transno`),
  KEY `EDISent` (`edisent`),
  KEY `salesperson` (`salesperson`),
  CONSTRAINT `debtortrans_ibfk_2` FOREIGN KEY (`type`) REFERENCES `weberp_systypes` (`typeid`),
  CONSTRAINT `debtortrans_ibfk_3` FOREIGN KEY (`prd`) REFERENCES `weberp_periods` (`periodno`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `debtortranstaxes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_debtortranstaxes` (
  `debtortransid` int(11) NOT NULL DEFAULT '0',
  `taxauthid` tinyint(4) NOT NULL DEFAULT '0',
  `taxamount` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`debtortransid`,`taxauthid`),
  KEY `taxauthid` (`taxauthid`),
  CONSTRAINT `debtortranstaxes_ibfk_1` FOREIGN KEY (`taxauthid`) REFERENCES `weberp_taxauthorities` (`taxid`),
  CONSTRAINT `debtortranstaxes_ibfk_2` FOREIGN KEY (`debtortransid`) REFERENCES `weberp_debtortrans` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `debtortype`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_debtortype` (
  `typeid` tinyint(4) NOT NULL AUTO_INCREMENT,
  `typename` varchar(100) NOT NULL,
  PRIMARY KEY (`typeid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `debtortypenotes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_debtortypenotes` (
  `noteid` tinyint(4) NOT NULL AUTO_INCREMENT,
  `typeid` tinyint(4) NOT NULL DEFAULT '0',
  `href` varchar(100) NOT NULL,
  `note` varchar(200) NOT NULL,
  `date` date NOT NULL DEFAULT '2016-01-01',
  `priority` varchar(20) NOT NULL,
  PRIMARY KEY (`noteid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `deliverynotes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_deliverynotes` (
  `deliverynotenumber` int(11) NOT NULL,
  `deliverynotelineno` tinyint(4) NOT NULL,
  `salesorderno` int(11) NOT NULL,
  `salesorderlineno` int(11) NOT NULL,
  `qtydelivered` double NOT NULL DEFAULT '0',
  `printed` tinyint(4) NOT NULL DEFAULT '0',
  `invoiced` tinyint(4) NOT NULL DEFAULT '0',
  `deliverydate` date NOT NULL DEFAULT '2016-01-01',
  PRIMARY KEY (`deliverynotenumber`,`deliverynotelineno`),
  KEY `deliverynotes_ibfk_2` (`salesorderno`,`salesorderlineno`),
  CONSTRAINT `deliverynotes_ibfk_1` FOREIGN KEY (`salesorderno`) REFERENCES `weberp_salesorders` (`orderno`),
  CONSTRAINT `deliverynotes_ibfk_2` FOREIGN KEY (`salesorderno`, `salesorderlineno`) REFERENCES `weberp_salesorderdetails` (`orderno`, `orderlineno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `departments`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_departments` (
  `departmentid` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL DEFAULT '',
  `authoriser` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`departmentid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `discountmatrix`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_discountmatrix` (
  `salestype` char(2) NOT NULL DEFAULT '',
  `discountcategory` char(2) NOT NULL DEFAULT '',
  `quantitybreak` int(11) NOT NULL DEFAULT '1',
  `discountrate` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`salestype`,`discountcategory`,`quantitybreak`),
  KEY `QuantityBreak` (`quantitybreak`),
  KEY `DiscountCategory` (`discountcategory`),
  KEY `SalesType` (`salestype`),
  CONSTRAINT `discountmatrix_ibfk_1` FOREIGN KEY (`salestype`) REFERENCES `weberp_salestypes` (`typeabbrev`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `edi_orders_seg_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_edi_orders_seg_groups` (
  `seggroupno` tinyint(4) NOT NULL DEFAULT '0',
  `maxoccur` int(4) NOT NULL DEFAULT '0',
  `parentseggroup` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`seggroupno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `edi_orders_segs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_edi_orders_segs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `segtag` char(3) NOT NULL DEFAULT '',
  `seggroup` tinyint(4) NOT NULL DEFAULT '0',
  `maxoccur` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `SegTag` (`segtag`),
  KEY `SegNo` (`seggroup`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ediitemmapping`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_ediitemmapping` (
  `supporcust` varchar(4) NOT NULL DEFAULT '',
  `partnercode` varchar(10) NOT NULL DEFAULT '',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `partnerstockid` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`supporcust`,`partnercode`,`stockid`),
  KEY `PartnerCode` (`partnercode`),
  KEY `StockID` (`stockid`),
  KEY `PartnerStockID` (`partnerstockid`),
  KEY `SuppOrCust` (`supporcust`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `edimessageformat`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_edimessageformat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `partnercode` varchar(10) NOT NULL DEFAULT '',
  `messagetype` varchar(6) NOT NULL DEFAULT '',
  `section` varchar(7) NOT NULL DEFAULT '',
  `sequenceno` int(11) NOT NULL DEFAULT '0',
  `linetext` varchar(70) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `PartnerCode` (`partnercode`,`messagetype`,`sequenceno`),
  KEY `Section` (`section`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `emailsettings`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_emailsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `host` varchar(30) NOT NULL,
  `port` char(5) NOT NULL,
  `heloaddress` varchar(20) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(30) DEFAULT NULL,
  `timeout` int(11) DEFAULT '5',
  `companyname` varchar(50) DEFAULT NULL,
  `auth` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `factorcompanies`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_factorcompanies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coyname` varchar(50) NOT NULL DEFAULT '',
  `address1` varchar(40) NOT NULL DEFAULT '',
  `address2` varchar(40) NOT NULL DEFAULT '',
  `address3` varchar(40) NOT NULL DEFAULT '',
  `address4` varchar(40) NOT NULL DEFAULT '',
  `address5` varchar(20) NOT NULL DEFAULT '',
  `address6` varchar(15) NOT NULL DEFAULT '',
  `contact` varchar(25) NOT NULL DEFAULT '',
  `telephone` varchar(25) NOT NULL DEFAULT '',
  `fax` varchar(25) NOT NULL DEFAULT '',
  `email` varchar(55) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `factor_name` (`coyname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fixedassetcategories`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_fixedassetcategories` (
  `categoryid` char(6) NOT NULL DEFAULT '',
  `categorydescription` char(20) NOT NULL DEFAULT '',
  `costact` varchar(20) NOT NULL DEFAULT '0',
  `depnact` varchar(20) NOT NULL DEFAULT '0',
  `disposalact` varchar(20) NOT NULL DEFAULT '80000',
  `accumdepnact` varchar(20) NOT NULL DEFAULT '0',
  `defaultdepnrate` double NOT NULL DEFAULT '0.2',
  `defaultdepntype` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`categoryid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fixedassetlocations`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_fixedassetlocations` (
  `locationid` char(6) NOT NULL DEFAULT '',
  `locationdescription` char(20) NOT NULL DEFAULT '',
  `parentlocationid` char(6) DEFAULT '',
  PRIMARY KEY (`locationid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fixedassets`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_fixedassets` (
  `assetid` int(11) NOT NULL AUTO_INCREMENT,
  `serialno` varchar(30) NOT NULL DEFAULT '',
  `barcode` varchar(20) NOT NULL,
  `assetlocation` varchar(6) NOT NULL DEFAULT '',
  `cost` double NOT NULL DEFAULT '0',
  `accumdepn` double NOT NULL DEFAULT '0',
  `datepurchased` date NOT NULL DEFAULT '2016-01-01',
  `disposalproceeds` double NOT NULL DEFAULT '0',
  `assetcategoryid` varchar(6) NOT NULL DEFAULT '',
  `description` varchar(50) NOT NULL DEFAULT '',
  `longdescription` text NOT NULL,
  `depntype` int(11) NOT NULL DEFAULT '1',
  `depnrate` double NOT NULL,
  `disposaldate` date NOT NULL DEFAULT '2016-01-01',
  PRIMARY KEY (`assetid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fixedassettasks`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_fixedassettasks` (
  `taskid` int(11) NOT NULL AUTO_INCREMENT,
  `assetid` int(11) NOT NULL,
  `taskdescription` text NOT NULL,
  `frequencydays` int(11) NOT NULL DEFAULT '365',
  `lastcompleted` date NOT NULL,
  `userresponsible` varchar(20) NOT NULL,
  `manager` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`taskid`),
  KEY `assetid` (`assetid`),
  KEY `userresponsible` (`userresponsible`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fixedassettrans`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_fixedassettrans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assetid` int(11) NOT NULL,
  `transtype` tinyint(4) NOT NULL,
  `transdate` date NOT NULL,
  `transno` int(11) NOT NULL,
  `periodno` smallint(6) NOT NULL,
  `inputdate` date NOT NULL,
  `fixedassettranstype` varchar(8) NOT NULL,
  `amount` double NOT NULL,
  PRIMARY KEY (`id`),
  KEY `assetid` (`assetid`,`transtype`,`transno`),
  KEY `inputdate` (`inputdate`),
  KEY `transdate` (`transdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `freightcosts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_freightcosts` (
  `shipcostfromid` int(11) NOT NULL AUTO_INCREMENT,
  `locationfrom` varchar(5) NOT NULL DEFAULT '',
  `destinationcountry` varchar(40) NOT NULL,
  `destination` varchar(40) NOT NULL DEFAULT '',
  `shipperid` int(11) NOT NULL DEFAULT '0',
  `cubrate` double NOT NULL DEFAULT '0',
  `kgrate` double NOT NULL DEFAULT '0',
  `maxkgs` double NOT NULL DEFAULT '999999',
  `maxcub` double NOT NULL DEFAULT '999999',
  `fixedprice` double NOT NULL DEFAULT '0',
  `minimumchg` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`shipcostfromid`),
  KEY `Destination` (`destination`),
  KEY `LocationFrom` (`locationfrom`),
  KEY `ShipperID` (`shipperid`),
  KEY `Destination_2` (`destination`,`locationfrom`,`shipperid`),
  CONSTRAINT `freightcosts_ibfk_1` FOREIGN KEY (`locationfrom`) REFERENCES `weberp_locations` (`loccode`),
  CONSTRAINT `freightcosts_ibfk_2` FOREIGN KEY (`shipperid`) REFERENCES `weberp_shippers` (`shipper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `geocode_param`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_geocode_param` (
  `geocodeid` tinyint(4) NOT NULL AUTO_INCREMENT,
  `geocode_key` varchar(200) NOT NULL DEFAULT '',
  `center_long` varchar(20) NOT NULL DEFAULT '',
  `center_lat` varchar(20) NOT NULL DEFAULT '',
  `map_height` varchar(10) NOT NULL DEFAULT '',
  `map_width` varchar(10) NOT NULL DEFAULT '',
  `map_host` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`geocodeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `glaccountusers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_glaccountusers` (
  `accountcode` varchar(20) NOT NULL COMMENT 'GL account code from chartmaster',
  `userid` varchar(20) NOT NULL,
  `canview` tinyint(4) NOT NULL DEFAULT '0',
  `canupd` tinyint(4) NOT NULL DEFAULT '0',
  UNIQUE KEY `useraccount` (`userid`,`accountcode`),
  UNIQUE KEY `accountuser` (`accountcode`,`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gltrans`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_gltrans` (
  `counterindex` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL DEFAULT '0',
  `typeno` bigint(16) NOT NULL DEFAULT '1',
  `chequeno` int(11) NOT NULL DEFAULT '0',
  `trandate` date NOT NULL DEFAULT '2016-01-01',
  `periodno` smallint(6) NOT NULL DEFAULT '0',
  `account` varchar(20) NOT NULL DEFAULT '0',
  `narrative` varchar(200) NOT NULL DEFAULT '',
  `amount` double NOT NULL DEFAULT '0',
  `posted` tinyint(4) NOT NULL DEFAULT '0',
  `jobref` varchar(20) NOT NULL DEFAULT '',
  `tag` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`counterindex`),
  KEY `Account` (`account`),
  KEY `ChequeNo` (`chequeno`),
  KEY `PeriodNo` (`periodno`),
  KEY `Posted` (`posted`),
  KEY `TranDate` (`trandate`),
  KEY `TypeNo` (`typeno`),
  KEY `Type_and_Number` (`type`,`typeno`),
  KEY `JobRef` (`jobref`),
  KEY `tag` (`tag`),
  CONSTRAINT `gltrans_ibfk_1` FOREIGN KEY (`account`) REFERENCES `weberp_chartmaster` (`accountcode`),
  CONSTRAINT `gltrans_ibfk_2` FOREIGN KEY (`type`) REFERENCES `weberp_systypes` (`typeid`),
  CONSTRAINT `gltrans_ibfk_3` FOREIGN KEY (`periodno`) REFERENCES `weberp_periods` (`periodno`)
) ENGINE=InnoDB AUTO_INCREMENT=190 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `grns`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_grns` (
  `grnbatch` smallint(6) NOT NULL DEFAULT '0',
  `grnno` int(11) NOT NULL AUTO_INCREMENT,
  `podetailitem` int(11) NOT NULL DEFAULT '0',
  `itemcode` varchar(20) NOT NULL DEFAULT '',
  `deliverydate` date NOT NULL DEFAULT '2016-01-01',
  `itemdescription` varchar(100) NOT NULL DEFAULT '',
  `qtyrecd` double NOT NULL DEFAULT '0',
  `quantityinv` double NOT NULL DEFAULT '0',
  `supplierid` varchar(10) NOT NULL DEFAULT '',
  `stdcostunit` double NOT NULL DEFAULT '0',
  `supplierref` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`grnno`),
  KEY `DeliveryDate` (`deliverydate`),
  KEY `ItemCode` (`itemcode`),
  KEY `PODetailItem` (`podetailitem`),
  KEY `SupplierID` (`supplierid`),
  CONSTRAINT `grns_ibfk_1` FOREIGN KEY (`supplierid`) REFERENCES `weberp_suppliers` (`supplierid`),
  CONSTRAINT `grns_ibfk_2` FOREIGN KEY (`podetailitem`) REFERENCES `weberp_purchorderdetails` (`podetailitem`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `holdreasons`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_holdreasons` (
  `reasoncode` smallint(6) NOT NULL DEFAULT '1',
  `reasondescription` char(30) NOT NULL DEFAULT '',
  `dissallowinvoices` tinyint(4) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`reasoncode`),
  KEY `ReasonDescription` (`reasondescription`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `internalstockcatrole`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_internalstockcatrole` (
  `categoryid` varchar(6) NOT NULL,
  `secroleid` int(11) NOT NULL,
  PRIMARY KEY (`categoryid`,`secroleid`),
  KEY `internalstockcatrole_ibfk_1` (`categoryid`),
  KEY `internalstockcatrole_ibfk_2` (`secroleid`),
  CONSTRAINT `internalstockcatrole_ibfk_1` FOREIGN KEY (`categoryid`) REFERENCES `weberp_stockcategory` (`categoryid`),
  CONSTRAINT `internalstockcatrole_ibfk_2` FOREIGN KEY (`secroleid`) REFERENCES `weberp_securityroles` (`secroleid`),
  CONSTRAINT `internalstockcatrole_ibfk_3` FOREIGN KEY (`categoryid`) REFERENCES `weberp_stockcategory` (`categoryid`),
  CONSTRAINT `internalstockcatrole_ibfk_4` FOREIGN KEY (`secroleid`) REFERENCES `weberp_securityroles` (`secroleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `labelfields`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_labelfields` (
  `labelfieldid` int(11) NOT NULL AUTO_INCREMENT,
  `labelid` tinyint(4) NOT NULL,
  `fieldvalue` varchar(20) NOT NULL,
  `vpos` double NOT NULL DEFAULT '0',
  `hpos` double NOT NULL DEFAULT '0',
  `fontsize` tinyint(4) NOT NULL,
  `barcode` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`labelfieldid`),
  KEY `labelid` (`labelid`),
  KEY `vpos` (`vpos`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `labels`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_labels` (
  `labelid` tinyint(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(50) NOT NULL,
  `pagewidth` double NOT NULL DEFAULT '0',
  `pageheight` double NOT NULL DEFAULT '0',
  `height` double NOT NULL DEFAULT '0',
  `width` double NOT NULL DEFAULT '0',
  `topmargin` double NOT NULL DEFAULT '0',
  `leftmargin` double NOT NULL DEFAULT '0',
  `rowheight` double NOT NULL DEFAULT '0',
  `columnwidth` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`labelid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lastcostrollup`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_lastcostrollup` (
  `stockid` char(20) NOT NULL DEFAULT '',
  `totalonhand` double NOT NULL DEFAULT '0',
  `matcost` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `labcost` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `oheadcost` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `categoryid` char(6) NOT NULL DEFAULT '',
  `stockact` varchar(20) NOT NULL DEFAULT '0',
  `adjglact` varchar(20) NOT NULL DEFAULT '0',
  `newmatcost` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `newlabcost` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `newoheadcost` decimal(20,4) NOT NULL DEFAULT '0.0000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `locations`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_locations` (
  `loccode` varchar(5) NOT NULL DEFAULT '',
  `locationname` varchar(50) NOT NULL DEFAULT '',
  `deladd1` varchar(40) NOT NULL DEFAULT '',
  `deladd2` varchar(40) NOT NULL DEFAULT '',
  `deladd3` varchar(40) NOT NULL DEFAULT '',
  `deladd4` varchar(40) NOT NULL DEFAULT '',
  `deladd5` varchar(20) NOT NULL DEFAULT '',
  `deladd6` varchar(15) NOT NULL DEFAULT '',
  `tel` varchar(30) NOT NULL DEFAULT '',
  `fax` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(55) NOT NULL DEFAULT '',
  `contact` varchar(30) NOT NULL DEFAULT '',
  `taxprovinceid` tinyint(4) NOT NULL DEFAULT '1',
  `cashsalecustomer` varchar(10) DEFAULT '',
  `managed` int(11) DEFAULT '0',
  `cashsalebranch` varchar(10) DEFAULT '',
  `internalrequest` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Allow (1) or not (0) internal request from this location',
  `usedforwo` tinyint(4) NOT NULL DEFAULT '1',
  `glaccountcode` varchar(20) NOT NULL DEFAULT '' COMMENT 'GL account of the location',
  `allowinvoicing` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Allow invoicing of items at this location',
  PRIMARY KEY (`loccode`),
  UNIQUE KEY `locationname` (`locationname`),
  KEY `taxprovinceid` (`taxprovinceid`),
  CONSTRAINT `locations_ibfk_1` FOREIGN KEY (`taxprovinceid`) REFERENCES `weberp_taxprovinces` (`taxprovinceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `locationusers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_locationusers` (
  `loccode` varchar(5) NOT NULL,
  `userid` varchar(20) NOT NULL,
  `canview` tinyint(4) NOT NULL DEFAULT '0',
  `canupd` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`loccode`,`userid`),
  KEY `UserId` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `locstock`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_locstock` (
  `loccode` varchar(5) NOT NULL DEFAULT '',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `quantity` double NOT NULL DEFAULT '0',
  `reorderlevel` bigint(20) NOT NULL DEFAULT '0',
  `bin` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`loccode`,`stockid`),
  KEY `StockID` (`stockid`),
  KEY `bin` (`bin`),
  CONSTRAINT `locstock_ibfk_1` FOREIGN KEY (`loccode`) REFERENCES `weberp_locations` (`loccode`),
  CONSTRAINT `locstock_ibfk_2` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `loctransfercancellations`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_loctransfercancellations` (
  `reference` int(11) NOT NULL,
  `stockid` varchar(20) NOT NULL,
  `cancelqty` double NOT NULL,
  `canceldate` datetime NOT NULL,
  `canceluserid` varchar(20) NOT NULL,
  KEY `Index1` (`reference`,`stockid`),
  KEY `Index2` (`canceldate`,`reference`,`stockid`),
  KEY `refstockid` (`reference`,`stockid`),
  KEY `cancelrefstockid` (`canceldate`,`reference`,`stockid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `loctransfers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_loctransfers` (
  `reference` int(11) NOT NULL DEFAULT '0',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `shipqty` double NOT NULL DEFAULT '0',
  `recqty` double NOT NULL DEFAULT '0',
  `shipdate` datetime NOT NULL DEFAULT '2016-01-01 00:00:00',
  `recdate` datetime NOT NULL DEFAULT '2016-01-01 00:00:00',
  `shiploc` varchar(7) NOT NULL DEFAULT '',
  `recloc` varchar(7) NOT NULL DEFAULT '',
  KEY `Reference` (`reference`,`stockid`),
  KEY `ShipLoc` (`shiploc`),
  KEY `RecLoc` (`recloc`),
  KEY `StockID` (`stockid`),
  CONSTRAINT `loctransfers_ibfk_1` FOREIGN KEY (`shiploc`) REFERENCES `weberp_locations` (`loccode`),
  CONSTRAINT `loctransfers_ibfk_2` FOREIGN KEY (`recloc`) REFERENCES `weberp_locations` (`loccode`),
  CONSTRAINT `loctransfers_ibfk_3` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores Shipments To And From Locations';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mailgroupdetails`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_mailgroupdetails` (
  `groupname` varchar(100) NOT NULL,
  `userid` varchar(20) NOT NULL,
  KEY `userid` (`userid`),
  KEY `groupname` (`groupname`),
  CONSTRAINT `mailgroupdetails_ibfk_1` FOREIGN KEY (`groupname`) REFERENCES `weberp_mailgroups` (`groupname`),
  CONSTRAINT `mailgroupdetails_ibfk_2` FOREIGN KEY (`userid`) REFERENCES `weberp_www_users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mailgroups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_mailgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupname` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `groupname` (`groupname`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `manufacturers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_manufacturers` (
  `manufacturers_id` int(11) NOT NULL AUTO_INCREMENT,
  `manufacturers_name` varchar(32) NOT NULL,
  `manufacturers_url` varchar(50) NOT NULL DEFAULT '',
  `manufacturers_image` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`manufacturers_id`),
  KEY `manufacturers_name` (`manufacturers_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mrpcalendar`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_mrpcalendar` (
  `calendardate` date NOT NULL,
  `daynumber` int(6) NOT NULL,
  `manufacturingflag` smallint(6) NOT NULL DEFAULT '1',
  PRIMARY KEY (`calendardate`),
  KEY `daynumber` (`daynumber`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mrpdemands`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_mrpdemands` (
  `demandid` int(11) NOT NULL AUTO_INCREMENT,
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `mrpdemandtype` varchar(6) NOT NULL DEFAULT '',
  `quantity` double NOT NULL DEFAULT '0',
  `duedate` date NOT NULL DEFAULT '2016-01-01',
  PRIMARY KEY (`demandid`),
  KEY `StockID` (`stockid`),
  KEY `mrpdemands_ibfk_1` (`mrpdemandtype`),
  CONSTRAINT `mrpdemands_ibfk_1` FOREIGN KEY (`mrpdemandtype`) REFERENCES `weberp_mrpdemandtypes` (`mrpdemandtype`),
  CONSTRAINT `mrpdemands_ibfk_2` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mrpdemandtypes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_mrpdemandtypes` (
  `mrpdemandtype` varchar(6) NOT NULL DEFAULT '',
  `description` char(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`mrpdemandtype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mrpplannedorders`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_mrpplannedorders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `part` char(20) DEFAULT NULL,
  `duedate` date DEFAULT NULL,
  `supplyquantity` double DEFAULT NULL,
  `ordertype` varchar(6) DEFAULT NULL,
  `orderno` int(11) DEFAULT NULL,
  `mrpdate` date DEFAULT NULL,
  `updateflag` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `offers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_offers` (
  `offerid` int(11) NOT NULL AUTO_INCREMENT,
  `tenderid` int(11) NOT NULL DEFAULT '0',
  `supplierid` varchar(10) NOT NULL DEFAULT '',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `quantity` double NOT NULL DEFAULT '0',
  `uom` varchar(15) NOT NULL DEFAULT '',
  `price` double NOT NULL DEFAULT '0',
  `expirydate` date NOT NULL DEFAULT '2016-01-01',
  `currcode` char(3) NOT NULL DEFAULT '',
  PRIMARY KEY (`offerid`),
  KEY `offers_ibfk_1` (`supplierid`),
  KEY `offers_ibfk_2` (`stockid`),
  CONSTRAINT `offers_ibfk_1` FOREIGN KEY (`supplierid`) REFERENCES `weberp_suppliers` (`supplierid`),
  CONSTRAINT `offers_ibfk_2` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orderdeliverydifferenceslog`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_orderdeliverydifferenceslog` (
  `orderno` int(11) NOT NULL DEFAULT '0',
  `invoiceno` int(11) NOT NULL DEFAULT '0',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `quantitydiff` double NOT NULL DEFAULT '0',
  `debtorno` varchar(10) NOT NULL DEFAULT '',
  `branch` varchar(10) NOT NULL DEFAULT '',
  `can_or_bo` char(3) NOT NULL DEFAULT 'CAN',
  KEY `StockID` (`stockid`),
  KEY `DebtorNo` (`debtorno`,`branch`),
  KEY `Can_or_BO` (`can_or_bo`),
  KEY `OrderNo` (`orderno`),
  CONSTRAINT `orderdeliverydifferenceslog_ibfk_1` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `orderdeliverydifferenceslog_ibfk_2` FOREIGN KEY (`debtorno`, `branch`) REFERENCES `weberp_custbranch` (`debtorno`, `branchcode`),
  CONSTRAINT `orderdeliverydifferenceslog_ibfk_3` FOREIGN KEY (`orderno`) REFERENCES `weberp_salesorders` (`orderno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `paymentmethods`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_paymentmethods` (
  `paymentid` tinyint(4) NOT NULL AUTO_INCREMENT,
  `paymentname` varchar(15) NOT NULL DEFAULT '',
  `paymenttype` int(11) NOT NULL DEFAULT '1',
  `receipttype` int(11) NOT NULL DEFAULT '1',
  `usepreprintedstationery` tinyint(4) NOT NULL DEFAULT '0',
  `opencashdrawer` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`paymentid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `paymentterms`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_paymentterms` (
  `termsindicator` char(2) NOT NULL DEFAULT '',
  `terms` char(40) NOT NULL DEFAULT '',
  `daysbeforedue` smallint(6) NOT NULL DEFAULT '0',
  `dayinfollowingmonth` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`termsindicator`),
  KEY `DaysBeforeDue` (`daysbeforedue`),
  KEY `DayInFollowingMonth` (`dayinfollowingmonth`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pcashdetails`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_pcashdetails` (
  `counterindex` int(20) NOT NULL AUTO_INCREMENT,
  `tabcode` varchar(20) NOT NULL,
  `date` date NOT NULL,
  `codeexpense` varchar(20) NOT NULL,
  `amount` double NOT NULL,
  `authorized` date NOT NULL COMMENT 'date cash assigment was revised and authorized by authorizer from tabs table',
  `posted` tinyint(4) NOT NULL COMMENT 'has (or has not) been posted into gltrans',
  `notes` text NOT NULL,
  `receipt` text COMMENT 'filename or path to scanned receipt or code of receipt to find physical receipt if tax guys or auditors show up',
  PRIMARY KEY (`counterindex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pcexpenses`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_pcexpenses` (
  `codeexpense` varchar(20) NOT NULL COMMENT 'code for the group',
  `description` varchar(50) NOT NULL COMMENT 'text description, e.g. meals, train tickets, fuel, etc',
  `glaccount` varchar(20) NOT NULL DEFAULT '0',
  `tag` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`codeexpense`),
  KEY `glaccount` (`glaccount`),
  CONSTRAINT `pcexpenses_ibfk_1` FOREIGN KEY (`glaccount`) REFERENCES `weberp_chartmaster` (`accountcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pctabexpenses`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_pctabexpenses` (
  `typetabcode` varchar(20) NOT NULL,
  `codeexpense` varchar(20) NOT NULL,
  KEY `typetabcode` (`typetabcode`),
  KEY `codeexpense` (`codeexpense`),
  CONSTRAINT `pctabexpenses_ibfk_1` FOREIGN KEY (`typetabcode`) REFERENCES `weberp_pctypetabs` (`typetabcode`),
  CONSTRAINT `pctabexpenses_ibfk_2` FOREIGN KEY (`codeexpense`) REFERENCES `weberp_pcexpenses` (`codeexpense`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pctabs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_pctabs` (
  `tabcode` varchar(20) NOT NULL,
  `usercode` varchar(20) NOT NULL COMMENT 'code of user employee from www_users',
  `typetabcode` varchar(20) NOT NULL,
  `currency` char(3) NOT NULL,
  `tablimit` double NOT NULL,
  `assigner` varchar(100) DEFAULT NULL,
  `authorizer` varchar(100) DEFAULT NULL,
  `glaccountassignment` varchar(20) NOT NULL DEFAULT '0',
  `glaccountpcash` varchar(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tabcode`),
  KEY `usercode` (`usercode`),
  KEY `typetabcode` (`typetabcode`),
  KEY `currency` (`currency`),
  KEY `authorizer` (`authorizer`),
  KEY `glaccountassignment` (`glaccountassignment`),
  CONSTRAINT `pctabs_ibfk_1` FOREIGN KEY (`usercode`) REFERENCES `weberp_www_users` (`userid`),
  CONSTRAINT `pctabs_ibfk_2` FOREIGN KEY (`typetabcode`) REFERENCES `weberp_pctypetabs` (`typetabcode`),
  CONSTRAINT `pctabs_ibfk_3` FOREIGN KEY (`currency`) REFERENCES `weberp_currencies` (`currabrev`),
  CONSTRAINT `pctabs_ibfk_5` FOREIGN KEY (`glaccountassignment`) REFERENCES `weberp_chartmaster` (`accountcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pctypetabs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_pctypetabs` (
  `typetabcode` varchar(20) NOT NULL COMMENT 'code for the type of petty cash tab',
  `typetabdescription` varchar(50) NOT NULL COMMENT 'text description, e.g. tab for CEO',
  PRIMARY KEY (`typetabcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `periods`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_periods` (
  `periodno` smallint(6) NOT NULL DEFAULT '0',
  `lastdate_in_period` date NOT NULL DEFAULT '2016-01-01',
  PRIMARY KEY (`periodno`),
  KEY `LastDate_in_Period` (`lastdate_in_period`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pickinglistdetails`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_pickinglistdetails` (
  `pickinglistno` int(11) NOT NULL DEFAULT '0',
  `pickinglistlineno` int(11) NOT NULL DEFAULT '0',
  `orderlineno` int(11) NOT NULL DEFAULT '0',
  `qtyexpected` double NOT NULL DEFAULT '0',
  `qtypicked` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`pickinglistno`,`pickinglistlineno`),
  CONSTRAINT `pickinglistdetails_ibfk_1` FOREIGN KEY (`pickinglistno`) REFERENCES `weberp_pickinglists` (`pickinglistno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pickinglists`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_pickinglists` (
  `pickinglistno` int(11) NOT NULL DEFAULT '0',
  `orderno` int(11) NOT NULL DEFAULT '0',
  `pickinglistdate` date NOT NULL DEFAULT '2016-01-01',
  `dateprinted` date NOT NULL DEFAULT '2016-01-01',
  `deliverynotedate` date NOT NULL DEFAULT '2016-01-01',
  PRIMARY KEY (`pickinglistno`),
  KEY `pickinglists_ibfk_1` (`orderno`),
  CONSTRAINT `pickinglists_ibfk_1` FOREIGN KEY (`orderno`) REFERENCES `weberp_salesorders` (`orderno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pricematrix`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_pricematrix` (
  `salestype` char(2) NOT NULL DEFAULT '',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `quantitybreak` int(11) NOT NULL DEFAULT '1',
  `price` double NOT NULL DEFAULT '0',
  `currabrev` char(3) NOT NULL DEFAULT '',
  `startdate` date NOT NULL DEFAULT '2016-01-01',
  `enddate` date NOT NULL DEFAULT '9999-12-31',
  PRIMARY KEY (`salestype`,`stockid`,`currabrev`,`quantitybreak`,`startdate`,`enddate`),
  KEY `SalesType` (`salestype`),
  KEY `currabrev` (`currabrev`),
  KEY `stockid` (`stockid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prices`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_prices` (
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `typeabbrev` char(2) NOT NULL DEFAULT '',
  `currabrev` char(3) NOT NULL DEFAULT '',
  `debtorno` varchar(10) NOT NULL DEFAULT '',
  `price` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `branchcode` varchar(10) NOT NULL DEFAULT '',
  `startdate` date NOT NULL DEFAULT '2016-01-01',
  `enddate` date NOT NULL DEFAULT '9999-12-31',
  PRIMARY KEY (`stockid`,`typeabbrev`,`currabrev`,`debtorno`,`branchcode`,`startdate`,`enddate`),
  KEY `CurrAbrev` (`currabrev`),
  KEY `DebtorNo` (`debtorno`),
  KEY `StockID` (`stockid`),
  KEY `TypeAbbrev` (`typeabbrev`),
  CONSTRAINT `prices_ibfk_1` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `prices_ibfk_2` FOREIGN KEY (`currabrev`) REFERENCES `weberp_currencies` (`currabrev`),
  CONSTRAINT `prices_ibfk_3` FOREIGN KEY (`typeabbrev`) REFERENCES `weberp_salestypes` (`typeabbrev`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prodspecs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_prodspecs` (
  `keyval` varchar(25) NOT NULL,
  `testid` int(11) NOT NULL,
  `defaultvalue` varchar(150) NOT NULL DEFAULT '',
  `targetvalue` varchar(30) NOT NULL DEFAULT '',
  `rangemin` float DEFAULT NULL,
  `rangemax` float DEFAULT NULL,
  `showoncert` tinyint(11) NOT NULL DEFAULT '1',
  `showonspec` tinyint(4) NOT NULL DEFAULT '1',
  `showontestplan` tinyint(4) NOT NULL DEFAULT '1',
  `active` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`keyval`,`testid`),
  KEY `testid` (`testid`),
  CONSTRAINT `prodspecs_ibfk_1` FOREIGN KEY (`testid`) REFERENCES `weberp_qatests` (`testid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `purchdata`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_purchdata` (
  `supplierno` char(10) NOT NULL DEFAULT '',
  `stockid` char(20) NOT NULL DEFAULT '',
  `price` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `suppliersuom` char(50) NOT NULL DEFAULT '',
  `conversionfactor` double NOT NULL DEFAULT '1',
  `supplierdescription` char(50) NOT NULL DEFAULT '',
  `leadtime` smallint(6) NOT NULL DEFAULT '1',
  `preferred` tinyint(4) NOT NULL DEFAULT '0',
  `effectivefrom` date NOT NULL,
  `suppliers_partno` varchar(50) NOT NULL DEFAULT '',
  `minorderqty` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`supplierno`,`stockid`,`effectivefrom`),
  KEY `StockID` (`stockid`),
  KEY `SupplierNo` (`supplierno`),
  KEY `Preferred` (`preferred`),
  CONSTRAINT `purchdata_ibfk_1` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `purchdata_ibfk_2` FOREIGN KEY (`supplierno`) REFERENCES `weberp_suppliers` (`supplierid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `purchorderauth`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_purchorderauth` (
  `userid` varchar(20) NOT NULL DEFAULT '',
  `currabrev` char(3) NOT NULL DEFAULT '',
  `cancreate` smallint(2) NOT NULL DEFAULT '0',
  `authlevel` double NOT NULL DEFAULT '0',
  `offhold` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`userid`,`currabrev`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `purchorderdetails`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_purchorderdetails` (
  `podetailitem` int(11) NOT NULL AUTO_INCREMENT,
  `orderno` int(11) NOT NULL DEFAULT '0',
  `itemcode` varchar(20) NOT NULL DEFAULT '',
  `deliverydate` date NOT NULL DEFAULT '2016-01-01',
  `itemdescription` varchar(100) NOT NULL,
  `glcode` varchar(20) NOT NULL DEFAULT '0',
  `qtyinvoiced` double NOT NULL DEFAULT '0',
  `unitprice` double NOT NULL DEFAULT '0',
  `actprice` double NOT NULL DEFAULT '0',
  `stdcostunit` double NOT NULL DEFAULT '0',
  `quantityord` double NOT NULL DEFAULT '0',
  `quantityrecd` double NOT NULL DEFAULT '0',
  `shiptref` int(11) NOT NULL DEFAULT '0',
  `jobref` varchar(20) NOT NULL DEFAULT '',
  `completed` tinyint(4) NOT NULL DEFAULT '0',
  `suppliersunit` varchar(50) DEFAULT NULL,
  `suppliers_partno` varchar(50) NOT NULL DEFAULT '',
  `assetid` int(11) NOT NULL DEFAULT '0',
  `conversionfactor` double NOT NULL DEFAULT '1',
  PRIMARY KEY (`podetailitem`),
  KEY `DeliveryDate` (`deliverydate`),
  KEY `GLCode` (`glcode`),
  KEY `ItemCode` (`itemcode`),
  KEY `JobRef` (`jobref`),
  KEY `OrderNo` (`orderno`),
  KEY `ShiptRef` (`shiptref`),
  KEY `Completed` (`completed`),
  CONSTRAINT `purchorderdetails_ibfk_1` FOREIGN KEY (`orderno`) REFERENCES `weberp_purchorders` (`orderno`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `purchorders`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_purchorders` (
  `orderno` int(11) NOT NULL AUTO_INCREMENT,
  `supplierno` varchar(10) NOT NULL DEFAULT '',
  `comments` longblob,
  `orddate` datetime NOT NULL DEFAULT '2016-01-01 00:00:00',
  `rate` double NOT NULL DEFAULT '1',
  `dateprinted` datetime DEFAULT NULL,
  `allowprint` tinyint(4) NOT NULL DEFAULT '1',
  `initiator` varchar(20) DEFAULT NULL,
  `requisitionno` varchar(15) DEFAULT NULL,
  `intostocklocation` varchar(5) NOT NULL DEFAULT '',
  `deladd1` varchar(40) NOT NULL DEFAULT '',
  `deladd2` varchar(40) NOT NULL DEFAULT '',
  `deladd3` varchar(40) NOT NULL DEFAULT '',
  `deladd4` varchar(40) NOT NULL DEFAULT '',
  `deladd5` varchar(20) NOT NULL DEFAULT '',
  `deladd6` varchar(15) NOT NULL DEFAULT '',
  `tel` varchar(30) NOT NULL DEFAULT '',
  `suppdeladdress1` varchar(40) NOT NULL DEFAULT '',
  `suppdeladdress2` varchar(40) NOT NULL DEFAULT '',
  `suppdeladdress3` varchar(40) NOT NULL DEFAULT '',
  `suppdeladdress4` varchar(40) NOT NULL DEFAULT '',
  `suppdeladdress5` varchar(20) NOT NULL DEFAULT '',
  `suppdeladdress6` varchar(15) NOT NULL DEFAULT '',
  `suppliercontact` varchar(30) NOT NULL DEFAULT '',
  `supptel` varchar(30) NOT NULL DEFAULT '',
  `contact` varchar(30) NOT NULL DEFAULT '',
  `version` decimal(3,2) NOT NULL DEFAULT '1.00',
  `revised` date NOT NULL DEFAULT '2016-01-01',
  `realorderno` varchar(16) NOT NULL DEFAULT '',
  `deliveryby` varchar(100) NOT NULL DEFAULT '',
  `deliverydate` date NOT NULL DEFAULT '2016-01-01',
  `status` varchar(12) NOT NULL DEFAULT '',
  `stat_comment` text NOT NULL,
  `paymentterms` char(2) NOT NULL DEFAULT '',
  `port` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`orderno`),
  KEY `OrdDate` (`orddate`),
  KEY `SupplierNo` (`supplierno`),
  KEY `IntoStockLocation` (`intostocklocation`),
  KEY `AllowPrintPO` (`allowprint`),
  CONSTRAINT `purchorders_ibfk_1` FOREIGN KEY (`supplierno`) REFERENCES `weberp_suppliers` (`supplierid`),
  CONSTRAINT `purchorders_ibfk_2` FOREIGN KEY (`intostocklocation`) REFERENCES `weberp_locations` (`loccode`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qasamples`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_qasamples` (
  `sampleid` int(11) NOT NULL AUTO_INCREMENT,
  `prodspeckey` varchar(25) NOT NULL DEFAULT '',
  `lotkey` varchar(25) NOT NULL DEFAULT '',
  `identifier` varchar(10) NOT NULL DEFAULT '',
  `createdby` varchar(15) NOT NULL DEFAULT '',
  `sampledate` date NOT NULL DEFAULT '2016-01-01',
  `comments` varchar(255) NOT NULL DEFAULT '',
  `cert` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`sampleid`),
  KEY `prodspeckey` (`prodspeckey`,`lotkey`),
  CONSTRAINT `qasamples_ibfk_1` FOREIGN KEY (`prodspeckey`) REFERENCES `weberp_prodspecs` (`keyval`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qatests`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_qatests` (
  `testid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `method` varchar(20) DEFAULT NULL,
  `groupby` varchar(20) DEFAULT NULL,
  `units` varchar(20) NOT NULL,
  `type` varchar(15) NOT NULL,
  `defaultvalue` varchar(150) NOT NULL DEFAULT '''''',
  `numericvalue` tinyint(4) NOT NULL DEFAULT '0',
  `showoncert` int(11) NOT NULL DEFAULT '1',
  `showonspec` int(11) NOT NULL DEFAULT '1',
  `showontestplan` tinyint(4) NOT NULL DEFAULT '1',
  `active` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`testid`),
  KEY `name` (`name`),
  KEY `groupname` (`groupby`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recurringsalesorders`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_recurringsalesorders` (
  `recurrorderno` int(11) NOT NULL AUTO_INCREMENT,
  `debtorno` varchar(10) NOT NULL DEFAULT '',
  `branchcode` varchar(10) NOT NULL DEFAULT '',
  `customerref` varchar(50) NOT NULL DEFAULT '',
  `buyername` varchar(50) DEFAULT NULL,
  `comments` longblob,
  `orddate` date NOT NULL DEFAULT '2016-01-01',
  `ordertype` char(2) NOT NULL DEFAULT '',
  `shipvia` int(11) NOT NULL DEFAULT '0',
  `deladd1` varchar(40) NOT NULL DEFAULT '',
  `deladd2` varchar(40) NOT NULL DEFAULT '',
  `deladd3` varchar(40) NOT NULL DEFAULT '',
  `deladd4` varchar(40) DEFAULT NULL,
  `deladd5` varchar(20) NOT NULL DEFAULT '',
  `deladd6` varchar(15) NOT NULL DEFAULT '',
  `contactphone` varchar(25) DEFAULT NULL,
  `contactemail` varchar(25) DEFAULT NULL,
  `deliverto` varchar(40) NOT NULL DEFAULT '',
  `freightcost` double NOT NULL DEFAULT '0',
  `fromstkloc` varchar(5) NOT NULL DEFAULT '',
  `lastrecurrence` date NOT NULL DEFAULT '2016-01-01',
  `stopdate` date NOT NULL DEFAULT '2016-01-01',
  `frequency` tinyint(4) NOT NULL DEFAULT '1',
  `autoinvoice` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`recurrorderno`),
  KEY `debtorno` (`debtorno`),
  KEY `orddate` (`orddate`),
  KEY `ordertype` (`ordertype`),
  KEY `locationindex` (`fromstkloc`),
  KEY `branchcode` (`branchcode`,`debtorno`),
  CONSTRAINT `recurringsalesorders_ibfk_1` FOREIGN KEY (`branchcode`, `debtorno`) REFERENCES `weberp_custbranch` (`branchcode`, `debtorno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recurrsalesorderdetails`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_recurrsalesorderdetails` (
  `recurrorderno` int(11) NOT NULL DEFAULT '0',
  `stkcode` varchar(20) NOT NULL DEFAULT '',
  `unitprice` double NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `discountpercent` double NOT NULL DEFAULT '0',
  `narrative` text NOT NULL,
  KEY `orderno` (`recurrorderno`),
  KEY `stkcode` (`stkcode`),
  CONSTRAINT `recurrsalesorderdetails_ibfk_1` FOREIGN KEY (`recurrorderno`) REFERENCES `weberp_recurringsalesorders` (`recurrorderno`),
  CONSTRAINT `recurrsalesorderdetails_ibfk_2` FOREIGN KEY (`stkcode`) REFERENCES `weberp_stockmaster` (`stockid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `relateditems`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_relateditems` (
  `stockid` varchar(20) CHARACTER SET utf8 NOT NULL,
  `related` varchar(20) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`stockid`,`related`),
  UNIQUE KEY `Related` (`related`,`stockid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reportcolumns`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_reportcolumns` (
  `reportid` smallint(6) NOT NULL DEFAULT '0',
  `colno` smallint(6) NOT NULL DEFAULT '0',
  `heading1` varchar(15) NOT NULL DEFAULT '',
  `heading2` varchar(15) DEFAULT NULL,
  `calculation` tinyint(1) NOT NULL DEFAULT '0',
  `periodfrom` smallint(6) DEFAULT NULL,
  `periodto` smallint(6) DEFAULT NULL,
  `datatype` varchar(15) DEFAULT NULL,
  `colnumerator` tinyint(4) DEFAULT NULL,
  `coldenominator` tinyint(4) DEFAULT NULL,
  `calcoperator` char(1) DEFAULT NULL,
  `budgetoractual` tinyint(1) NOT NULL DEFAULT '0',
  `valformat` char(1) NOT NULL DEFAULT 'N',
  `constant` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`reportid`,`colno`),
  CONSTRAINT `reportcolumns_ibfk_1` FOREIGN KEY (`reportid`) REFERENCES `weberp_reportheaders` (`reportid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reportfields`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_reportfields` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `reportid` int(5) NOT NULL DEFAULT '0',
  `entrytype` varchar(15) NOT NULL DEFAULT '',
  `seqnum` int(3) NOT NULL DEFAULT '0',
  `fieldname` varchar(80) NOT NULL DEFAULT '',
  `displaydesc` varchar(25) NOT NULL DEFAULT '',
  `visible` enum('1','0') NOT NULL DEFAULT '1',
  `columnbreak` enum('1','0') NOT NULL DEFAULT '1',
  `params` text,
  PRIMARY KEY (`id`),
  KEY `reportid` (`reportid`)
) ENGINE=MyISAM AUTO_INCREMENT=1883 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reportheaders`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_reportheaders` (
  `reportid` smallint(6) NOT NULL AUTO_INCREMENT,
  `reportheading` varchar(80) NOT NULL DEFAULT '',
  `groupbydata1` varchar(15) NOT NULL DEFAULT '',
  `newpageafter1` tinyint(1) NOT NULL DEFAULT '0',
  `lower1` varchar(10) NOT NULL DEFAULT '',
  `upper1` varchar(10) NOT NULL DEFAULT '',
  `groupbydata2` varchar(15) DEFAULT NULL,
  `newpageafter2` tinyint(1) NOT NULL DEFAULT '0',
  `lower2` varchar(10) DEFAULT NULL,
  `upper2` varchar(10) DEFAULT NULL,
  `groupbydata3` varchar(15) DEFAULT NULL,
  `newpageafter3` tinyint(1) NOT NULL DEFAULT '0',
  `lower3` varchar(10) DEFAULT NULL,
  `upper3` varchar(10) DEFAULT NULL,
  `groupbydata4` varchar(15) NOT NULL DEFAULT '',
  `newpageafter4` tinyint(1) NOT NULL DEFAULT '0',
  `upper4` varchar(10) NOT NULL DEFAULT '',
  `lower4` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`reportid`),
  KEY `ReportHeading` (`reportheading`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reportlinks`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_reportlinks` (
  `table1` varchar(25) NOT NULL DEFAULT '',
  `table2` varchar(25) NOT NULL DEFAULT '',
  `equation` varchar(75) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reports`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_reports` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `reportname` varchar(30) NOT NULL DEFAULT '',
  `reporttype` char(3) NOT NULL DEFAULT 'rpt',
  `groupname` varchar(9) NOT NULL DEFAULT 'misc',
  `defaultreport` enum('1','0') NOT NULL DEFAULT '0',
  `papersize` varchar(15) NOT NULL DEFAULT 'A4,210,297',
  `paperorientation` enum('P','L') NOT NULL DEFAULT 'P',
  `margintop` int(3) NOT NULL DEFAULT '10',
  `marginbottom` int(3) NOT NULL DEFAULT '10',
  `marginleft` int(3) NOT NULL DEFAULT '10',
  `marginright` int(3) NOT NULL DEFAULT '10',
  `coynamefont` varchar(20) NOT NULL DEFAULT 'Helvetica',
  `coynamefontsize` int(3) NOT NULL DEFAULT '12',
  `coynamefontcolor` varchar(11) NOT NULL DEFAULT '0,0,0',
  `coynamealign` enum('L','C','R') NOT NULL DEFAULT 'C',
  `coynameshow` enum('1','0') NOT NULL DEFAULT '1',
  `title1desc` varchar(50) NOT NULL DEFAULT '%reportname%',
  `title1font` varchar(20) NOT NULL DEFAULT 'Helvetica',
  `title1fontsize` int(3) NOT NULL DEFAULT '10',
  `title1fontcolor` varchar(11) NOT NULL DEFAULT '0,0,0',
  `title1fontalign` enum('L','C','R') NOT NULL DEFAULT 'C',
  `title1show` enum('1','0') NOT NULL DEFAULT '1',
  `title2desc` varchar(50) NOT NULL DEFAULT 'Report Generated %date%',
  `title2font` varchar(20) NOT NULL DEFAULT 'Helvetica',
  `title2fontsize` int(3) NOT NULL DEFAULT '10',
  `title2fontcolor` varchar(11) NOT NULL DEFAULT '0,0,0',
  `title2fontalign` enum('L','C','R') NOT NULL DEFAULT 'C',
  `title2show` enum('1','0') NOT NULL DEFAULT '1',
  `filterfont` varchar(10) NOT NULL DEFAULT 'Helvetica',
  `filterfontsize` int(3) NOT NULL DEFAULT '8',
  `filterfontcolor` varchar(11) NOT NULL DEFAULT '0,0,0',
  `filterfontalign` enum('L','C','R') NOT NULL DEFAULT 'L',
  `datafont` varchar(10) NOT NULL DEFAULT 'Helvetica',
  `datafontsize` int(3) NOT NULL DEFAULT '10',
  `datafontcolor` varchar(10) NOT NULL DEFAULT 'black',
  `datafontalign` enum('L','C','R') NOT NULL DEFAULT 'L',
  `totalsfont` varchar(10) NOT NULL DEFAULT 'Helvetica',
  `totalsfontsize` int(3) NOT NULL DEFAULT '10',
  `totalsfontcolor` varchar(11) NOT NULL DEFAULT '0,0,0',
  `totalsfontalign` enum('L','C','R') NOT NULL DEFAULT 'L',
  `col1width` int(3) NOT NULL DEFAULT '25',
  `col2width` int(3) NOT NULL DEFAULT '25',
  `col3width` int(3) NOT NULL DEFAULT '25',
  `col4width` int(3) NOT NULL DEFAULT '25',
  `col5width` int(3) NOT NULL DEFAULT '25',
  `col6width` int(3) NOT NULL DEFAULT '25',
  `col7width` int(3) NOT NULL DEFAULT '25',
  `col8width` int(3) NOT NULL DEFAULT '25',
  `col9width` int(3) NOT NULL DEFAULT '25',
  `col10width` int(3) NOT NULL DEFAULT '25',
  `col11width` int(3) NOT NULL DEFAULT '25',
  `col12width` int(3) NOT NULL DEFAULT '25',
  `col13width` int(3) NOT NULL DEFAULT '25',
  `col14width` int(3) NOT NULL DEFAULT '25',
  `col15width` int(3) NOT NULL DEFAULT '25',
  `col16width` int(3) NOT NULL DEFAULT '25',
  `col17width` int(3) NOT NULL DEFAULT '25',
  `col18width` int(3) NOT NULL DEFAULT '25',
  `col19width` int(3) NOT NULL DEFAULT '25',
  `col20width` int(3) NOT NULL DEFAULT '25',
  `table1` varchar(25) NOT NULL DEFAULT '',
  `table2` varchar(25) DEFAULT NULL,
  `table2criteria` varchar(75) DEFAULT NULL,
  `table3` varchar(25) DEFAULT NULL,
  `table3criteria` varchar(75) DEFAULT NULL,
  `table4` varchar(25) DEFAULT NULL,
  `table4criteria` varchar(75) DEFAULT NULL,
  `table5` varchar(25) DEFAULT NULL,
  `table5criteria` varchar(75) DEFAULT NULL,
  `table6` varchar(25) DEFAULT NULL,
  `table6criteria` varchar(75) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`reportname`,`groupname`)
) ENGINE=MyISAM AUTO_INCREMENT=142 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `salesanalysis`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_salesanalysis` (
  `typeabbrev` char(2) NOT NULL DEFAULT '',
  `periodno` smallint(6) NOT NULL DEFAULT '0',
  `amt` double NOT NULL DEFAULT '0',
  `cost` double NOT NULL DEFAULT '0',
  `cust` varchar(10) NOT NULL DEFAULT '',
  `custbranch` varchar(10) NOT NULL DEFAULT '',
  `qty` double NOT NULL DEFAULT '0',
  `disc` double NOT NULL DEFAULT '0',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `area` varchar(3) NOT NULL,
  `budgetoractual` tinyint(1) NOT NULL DEFAULT '0',
  `salesperson` char(3) NOT NULL DEFAULT '',
  `stkcategory` varchar(6) NOT NULL DEFAULT '',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `CustBranch` (`custbranch`),
  KEY `Cust` (`cust`),
  KEY `PeriodNo` (`periodno`),
  KEY `StkCategory` (`stkcategory`),
  KEY `StockID` (`stockid`),
  KEY `TypeAbbrev` (`typeabbrev`),
  KEY `Area` (`area`),
  KEY `BudgetOrActual` (`budgetoractual`),
  KEY `Salesperson` (`salesperson`),
  CONSTRAINT `salesanalysis_ibfk_1` FOREIGN KEY (`periodno`) REFERENCES `weberp_periods` (`periodno`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `salescat`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_salescat` (
  `salescatid` tinyint(4) NOT NULL AUTO_INCREMENT,
  `parentcatid` tinyint(4) DEFAULT NULL,
  `salescatname` varchar(50) DEFAULT NULL,
  `active` int(11) NOT NULL DEFAULT '1' COMMENT '1 if active 0 if inactive',
  PRIMARY KEY (`salescatid`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `salescatprod`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_salescatprod` (
  `salescatid` tinyint(4) NOT NULL DEFAULT '0',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `manufacturers_id` int(11) NOT NULL,
  `featured` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`salescatid`,`stockid`),
  KEY `salescatid` (`salescatid`),
  KEY `stockid` (`stockid`),
  KEY `manufacturer_id` (`manufacturers_id`),
  CONSTRAINT `salescatprod_ibfk_1` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `salescatprod_ibfk_2` FOREIGN KEY (`salescatid`) REFERENCES `weberp_salescat` (`salescatid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `salescattranslations`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_salescattranslations` (
  `salescatid` tinyint(4) NOT NULL DEFAULT '0',
  `language_id` varchar(10) NOT NULL DEFAULT 'en_GB.utf8',
  `salescattranslation` varchar(40) NOT NULL,
  PRIMARY KEY (`salescatid`,`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `salesglpostings`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_salesglpostings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `area` varchar(3) NOT NULL,
  `stkcat` varchar(6) NOT NULL DEFAULT '',
  `discountglcode` varchar(20) NOT NULL DEFAULT '0',
  `salesglcode` varchar(20) NOT NULL DEFAULT '0',
  `salestype` char(2) NOT NULL DEFAULT 'AN',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Area_StkCat` (`area`,`stkcat`,`salestype`),
  KEY `Area` (`area`),
  KEY `StkCat` (`stkcat`),
  KEY `SalesType` (`salestype`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `salesman`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_salesman` (
  `salesmancode` varchar(4) NOT NULL DEFAULT '',
  `salesmanname` char(30) NOT NULL DEFAULT '',
  `smantel` char(20) NOT NULL DEFAULT '',
  `smanfax` char(20) NOT NULL DEFAULT '',
  `commissionrate1` double NOT NULL DEFAULT '0',
  `breakpoint` decimal(10,0) NOT NULL DEFAULT '0',
  `commissionrate2` double NOT NULL DEFAULT '0',
  `current` tinyint(4) NOT NULL COMMENT 'Salesman current (1) or not (0)',
  PRIMARY KEY (`salesmancode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `salesorderdetails`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_salesorderdetails` (
  `orderlineno` int(11) NOT NULL DEFAULT '0',
  `orderno` int(11) NOT NULL DEFAULT '0',
  `stkcode` varchar(20) NOT NULL DEFAULT '',
  `qtyinvoiced` double NOT NULL DEFAULT '0',
  `unitprice` double NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `estimate` tinyint(4) NOT NULL DEFAULT '0',
  `discountpercent` double NOT NULL DEFAULT '0',
  `actualdispatchdate` datetime NOT NULL DEFAULT '2016-01-01 00:00:00',
  `completed` tinyint(1) NOT NULL DEFAULT '0',
  `narrative` text,
  `itemdue` date DEFAULT NULL COMMENT 'Due date for line item.  Some customers require \r\nacknowledgements with due dates by line item',
  `poline` varchar(10) DEFAULT NULL COMMENT 'Some Customers require acknowledgements with a PO line number for each sales line',
  PRIMARY KEY (`orderlineno`,`orderno`),
  KEY `OrderNo` (`orderno`),
  KEY `StkCode` (`stkcode`),
  KEY `Completed` (`completed`),
  CONSTRAINT `salesorderdetails_ibfk_1` FOREIGN KEY (`orderno`) REFERENCES `weberp_salesorders` (`orderno`),
  CONSTRAINT `salesorderdetails_ibfk_2` FOREIGN KEY (`stkcode`) REFERENCES `weberp_stockmaster` (`stockid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `salesorders`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_salesorders` (
  `orderno` int(11) NOT NULL,
  `debtorno` varchar(10) NOT NULL DEFAULT '',
  `branchcode` varchar(10) NOT NULL DEFAULT '',
  `customerref` varchar(50) NOT NULL DEFAULT '',
  `buyername` varchar(50) DEFAULT NULL,
  `comments` longblob,
  `orddate` date NOT NULL DEFAULT '2016-01-01',
  `ordertype` char(2) NOT NULL DEFAULT '',
  `shipvia` int(11) NOT NULL DEFAULT '0',
  `deladd1` varchar(40) NOT NULL DEFAULT '',
  `deladd2` varchar(40) NOT NULL DEFAULT '',
  `deladd3` varchar(40) NOT NULL DEFAULT '',
  `deladd4` varchar(40) DEFAULT NULL,
  `deladd5` varchar(20) NOT NULL DEFAULT '',
  `deladd6` varchar(15) NOT NULL DEFAULT '',
  `contactphone` varchar(25) DEFAULT NULL,
  `contactemail` varchar(40) DEFAULT NULL,
  `deliverto` varchar(40) NOT NULL DEFAULT '',
  `deliverblind` tinyint(1) DEFAULT '1',
  `freightcost` double NOT NULL DEFAULT '0',
  `fromstkloc` varchar(5) NOT NULL DEFAULT '',
  `deliverydate` date NOT NULL DEFAULT '2016-01-01',
  `confirmeddate` date NOT NULL DEFAULT '2016-01-01',
  `printedpackingslip` tinyint(4) NOT NULL DEFAULT '0',
  `datepackingslipprinted` date NOT NULL DEFAULT '2016-01-01',
  `quotation` tinyint(4) NOT NULL DEFAULT '0',
  `quotedate` date NOT NULL DEFAULT '2016-01-01',
  `poplaced` tinyint(4) NOT NULL DEFAULT '0',
  `salesperson` varchar(4) NOT NULL,
  PRIMARY KEY (`orderno`),
  KEY `DebtorNo` (`debtorno`),
  KEY `OrdDate` (`orddate`),
  KEY `OrderType` (`ordertype`),
  KEY `LocationIndex` (`fromstkloc`),
  KEY `BranchCode` (`branchcode`,`debtorno`),
  KEY `ShipVia` (`shipvia`),
  KEY `quotation` (`quotation`),
  KEY `poplaced` (`poplaced`),
  KEY `salesperson` (`salesperson`),
  CONSTRAINT `salesorders_ibfk_1` FOREIGN KEY (`branchcode`, `debtorno`) REFERENCES `weberp_custbranch` (`branchcode`, `debtorno`),
  CONSTRAINT `salesorders_ibfk_2` FOREIGN KEY (`shipvia`) REFERENCES `weberp_shippers` (`shipper_id`),
  CONSTRAINT `salesorders_ibfk_3` FOREIGN KEY (`fromstkloc`) REFERENCES `weberp_locations` (`loccode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `salestypes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_salestypes` (
  `typeabbrev` char(2) NOT NULL DEFAULT '',
  `sales_type` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`typeabbrev`),
  KEY `Sales_Type` (`sales_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sampleresults`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_sampleresults` (
  `resultid` bigint(20) NOT NULL AUTO_INCREMENT,
  `sampleid` int(11) NOT NULL,
  `testid` int(11) NOT NULL,
  `defaultvalue` varchar(150) NOT NULL,
  `targetvalue` varchar(30) NOT NULL,
  `rangemin` float DEFAULT NULL,
  `rangemax` float DEFAULT NULL,
  `testvalue` varchar(30) NOT NULL DEFAULT '',
  `testdate` date NOT NULL DEFAULT '2016-01-01',
  `testedby` varchar(15) NOT NULL DEFAULT '',
  `comments` varchar(255) NOT NULL DEFAULT '',
  `isinspec` tinyint(4) NOT NULL DEFAULT '0',
  `showoncert` tinyint(4) NOT NULL DEFAULT '1',
  `showontestplan` tinyint(4) NOT NULL DEFAULT '1',
  `manuallyadded` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`resultid`),
  KEY `sampleid` (`sampleid`),
  KEY `testid` (`testid`),
  CONSTRAINT `sampleresults_ibfk_1` FOREIGN KEY (`testid`) REFERENCES `weberp_qatests` (`testid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `scripts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_scripts` (
  `script` varchar(78) NOT NULL DEFAULT '',
  `pagesecurity` int(11) NOT NULL DEFAULT '1',
  `description` text NOT NULL,
  PRIMARY KEY (`script`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `securitygroups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_securitygroups` (
  `secroleid` int(11) NOT NULL DEFAULT '0',
  `tokenid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`secroleid`,`tokenid`),
  KEY `secroleid` (`secroleid`),
  KEY `tokenid` (`tokenid`),
  CONSTRAINT `securitygroups_secroleid_fk` FOREIGN KEY (`secroleid`) REFERENCES `weberp_securityroles` (`secroleid`),
  CONSTRAINT `securitygroups_tokenid_fk` FOREIGN KEY (`tokenid`) REFERENCES `weberp_securitytokens` (`tokenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `securityroles`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_securityroles` (
  `secroleid` int(11) NOT NULL AUTO_INCREMENT,
  `secrolename` text NOT NULL,
  PRIMARY KEY (`secroleid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `securitytokens`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_securitytokens` (
  `tokenid` int(11) NOT NULL DEFAULT '0',
  `tokenname` text NOT NULL,
  PRIMARY KEY (`tokenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sellthroughsupport`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_sellthroughsupport` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supplierno` varchar(10) NOT NULL,
  `debtorno` varchar(10) NOT NULL DEFAULT '',
  `categoryid` char(6) NOT NULL DEFAULT '',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `narrative` varchar(20) NOT NULL DEFAULT '',
  `rebatepercent` double NOT NULL DEFAULT '0',
  `rebateamount` double NOT NULL DEFAULT '0',
  `effectivefrom` date NOT NULL,
  `effectiveto` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `supplierno` (`supplierno`),
  KEY `debtorno` (`debtorno`),
  KEY `effectivefrom` (`effectivefrom`),
  KEY `effectiveto` (`effectiveto`),
  KEY `stockid` (`stockid`),
  KEY `categoryid` (`categoryid`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipmentcharges`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_shipmentcharges` (
  `shiptchgid` int(11) NOT NULL AUTO_INCREMENT,
  `shiptref` int(11) NOT NULL DEFAULT '0',
  `transtype` smallint(6) NOT NULL DEFAULT '0',
  `transno` int(11) NOT NULL DEFAULT '0',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `value` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`shiptchgid`),
  KEY `TransType` (`transtype`,`transno`),
  KEY `ShiptRef` (`shiptref`),
  KEY `StockID` (`stockid`),
  KEY `TransType_2` (`transtype`),
  CONSTRAINT `shipmentcharges_ibfk_1` FOREIGN KEY (`shiptref`) REFERENCES `weberp_shipments` (`shiptref`),
  CONSTRAINT `shipmentcharges_ibfk_2` FOREIGN KEY (`transtype`) REFERENCES `weberp_systypes` (`typeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipments`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_shipments` (
  `shiptref` int(11) NOT NULL DEFAULT '0',
  `voyageref` varchar(20) NOT NULL DEFAULT '0',
  `vessel` varchar(50) NOT NULL DEFAULT '',
  `eta` datetime NOT NULL DEFAULT '2016-01-01 00:00:00',
  `accumvalue` double NOT NULL DEFAULT '0',
  `supplierid` varchar(10) NOT NULL DEFAULT '',
  `closed` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`shiptref`),
  KEY `ETA` (`eta`),
  KEY `SupplierID` (`supplierid`),
  KEY `ShipperRef` (`voyageref`),
  KEY `Vessel` (`vessel`),
  CONSTRAINT `shipments_ibfk_1` FOREIGN KEY (`supplierid`) REFERENCES `weberp_suppliers` (`supplierid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shippers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_shippers` (
  `shipper_id` int(11) NOT NULL AUTO_INCREMENT,
  `shippername` char(40) NOT NULL DEFAULT '',
  `mincharge` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`shipper_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockcategory`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_stockcategory` (
  `categoryid` char(6) NOT NULL DEFAULT '',
  `categorydescription` char(20) NOT NULL DEFAULT '',
  `stocktype` char(1) NOT NULL DEFAULT 'F',
  `stockact` varchar(20) NOT NULL DEFAULT '0',
  `adjglact` varchar(20) NOT NULL DEFAULT '0',
  `issueglact` varchar(20) NOT NULL DEFAULT '0',
  `purchpricevaract` varchar(20) NOT NULL DEFAULT '80000',
  `materialuseagevarac` varchar(20) NOT NULL DEFAULT '80000',
  `wipact` varchar(20) NOT NULL DEFAULT '0',
  `defaulttaxcatid` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`categoryid`),
  KEY `CategoryDescription` (`categorydescription`),
  KEY `StockType` (`stocktype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockcatproperties`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_stockcatproperties` (
  `stkcatpropid` int(11) NOT NULL AUTO_INCREMENT,
  `categoryid` char(6) NOT NULL,
  `label` text NOT NULL,
  `controltype` tinyint(4) NOT NULL DEFAULT '0',
  `defaultvalue` varchar(100) NOT NULL DEFAULT '''''',
  `maximumvalue` double NOT NULL DEFAULT '999999999',
  `reqatsalesorder` tinyint(4) NOT NULL DEFAULT '0',
  `minimumvalue` double NOT NULL DEFAULT '-999999999',
  `numericvalue` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`stkcatpropid`),
  KEY `categoryid` (`categoryid`),
  CONSTRAINT `stockcatproperties_ibfk_1` FOREIGN KEY (`categoryid`) REFERENCES `weberp_stockcategory` (`categoryid`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockcheckfreeze`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_stockcheckfreeze` (
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `loccode` varchar(5) NOT NULL DEFAULT '',
  `qoh` double NOT NULL DEFAULT '0',
  `stockcheckdate` date NOT NULL DEFAULT '2016-01-01',
  PRIMARY KEY (`stockid`,`loccode`),
  KEY `LocCode` (`loccode`),
  CONSTRAINT `stockcheckfreeze_ibfk_1` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `stockcheckfreeze_ibfk_2` FOREIGN KEY (`loccode`) REFERENCES `weberp_locations` (`loccode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockcounts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_stockcounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `loccode` varchar(5) NOT NULL DEFAULT '',
  `qtycounted` double NOT NULL DEFAULT '0',
  `reference` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `StockID` (`stockid`),
  KEY `LocCode` (`loccode`),
  CONSTRAINT `stockcounts_ibfk_1` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `stockcounts_ibfk_2` FOREIGN KEY (`loccode`) REFERENCES `weberp_locations` (`loccode`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockdescriptiontranslations`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_stockdescriptiontranslations` (
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `language_id` varchar(10) NOT NULL DEFAULT 'en_GB.utf8',
  `descriptiontranslation` varchar(50) DEFAULT NULL COMMENT 'Item''s short description',
  `longdescriptiontranslation` text COMMENT 'Item''s long description',
  `needsrevision` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`stockid`,`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockitemproperties`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_stockitemproperties` (
  `stockid` varchar(20) NOT NULL,
  `stkcatpropid` int(11) NOT NULL,
  `value` varchar(50) NOT NULL,
  PRIMARY KEY (`stockid`,`stkcatpropid`),
  KEY `stockid` (`stockid`),
  KEY `value` (`value`),
  KEY `stkcatpropid` (`stkcatpropid`),
  CONSTRAINT `stockitemproperties_ibfk_1` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `stockitemproperties_ibfk_2` FOREIGN KEY (`stkcatpropid`) REFERENCES `weberp_stockcatproperties` (`stkcatpropid`),
  CONSTRAINT `stockitemproperties_ibfk_3` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `stockitemproperties_ibfk_4` FOREIGN KEY (`stkcatpropid`) REFERENCES `weberp_stockcatproperties` (`stkcatpropid`),
  CONSTRAINT `stockitemproperties_ibfk_5` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `stockitemproperties_ibfk_6` FOREIGN KEY (`stkcatpropid`) REFERENCES `weberp_stockcatproperties` (`stkcatpropid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockmaster`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_stockmaster` (
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `categoryid` varchar(6) NOT NULL DEFAULT '',
  `description` varchar(50) NOT NULL DEFAULT '',
  `longdescription` text NOT NULL,
  `units` varchar(20) NOT NULL DEFAULT 'each',
  `mbflag` char(1) NOT NULL DEFAULT 'B',
  `actualcost` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `lastcost` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `materialcost` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `labourcost` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `overheadcost` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `lowestlevel` smallint(6) NOT NULL DEFAULT '0',
  `discontinued` tinyint(4) NOT NULL DEFAULT '0',
  `controlled` tinyint(4) NOT NULL DEFAULT '0',
  `eoq` double NOT NULL DEFAULT '0',
  `volume` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `grossweight` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `barcode` varchar(50) NOT NULL DEFAULT '',
  `discountcategory` char(2) NOT NULL DEFAULT '',
  `taxcatid` tinyint(4) NOT NULL DEFAULT '1',
  `serialised` tinyint(4) NOT NULL DEFAULT '0',
  `appendfile` varchar(40) NOT NULL DEFAULT 'none',
  `perishable` tinyint(1) NOT NULL DEFAULT '0',
  `decimalplaces` tinyint(4) NOT NULL DEFAULT '0',
  `pansize` double NOT NULL DEFAULT '0',
  `shrinkfactor` double NOT NULL DEFAULT '0',
  `nextserialno` bigint(20) NOT NULL DEFAULT '0',
  `netweight` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `lastcostupdate` date NOT NULL DEFAULT '2016-01-01',
  PRIMARY KEY (`stockid`),
  KEY `CategoryID` (`categoryid`),
  KEY `Description` (`description`),
  KEY `MBflag` (`mbflag`),
  KEY `StockID` (`stockid`,`categoryid`),
  KEY `Controlled` (`controlled`),
  KEY `DiscountCategory` (`discountcategory`),
  KEY `taxcatid` (`taxcatid`),
  CONSTRAINT `stockmaster_ibfk_1` FOREIGN KEY (`categoryid`) REFERENCES `weberp_stockcategory` (`categoryid`),
  CONSTRAINT `stockmaster_ibfk_2` FOREIGN KEY (`taxcatid`) REFERENCES `weberp_taxcategories` (`taxcatid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockmoves`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_stockmoves` (
  `stkmoveno` int(11) NOT NULL AUTO_INCREMENT,
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `type` smallint(6) NOT NULL DEFAULT '0',
  `transno` int(11) NOT NULL DEFAULT '0',
  `loccode` varchar(5) NOT NULL DEFAULT '',
  `trandate` date NOT NULL DEFAULT '2016-01-01',
  `userid` varchar(20) NOT NULL,
  `debtorno` varchar(10) NOT NULL DEFAULT '',
  `branchcode` varchar(10) NOT NULL DEFAULT '',
  `price` decimal(21,5) NOT NULL DEFAULT '0.00000',
  `prd` smallint(6) NOT NULL DEFAULT '0',
  `reference` varchar(100) NOT NULL DEFAULT '',
  `qty` double NOT NULL DEFAULT '1',
  `discountpercent` double NOT NULL DEFAULT '0',
  `standardcost` double NOT NULL DEFAULT '0',
  `show_on_inv_crds` tinyint(4) NOT NULL DEFAULT '1',
  `newqoh` double NOT NULL DEFAULT '0',
  `hidemovt` tinyint(4) NOT NULL DEFAULT '0',
  `narrative` text,
  PRIMARY KEY (`stkmoveno`),
  KEY `DebtorNo` (`debtorno`),
  KEY `LocCode` (`loccode`),
  KEY `Prd` (`prd`),
  KEY `StockID_2` (`stockid`),
  KEY `TranDate` (`trandate`),
  KEY `TransNo` (`transno`),
  KEY `Type` (`type`),
  KEY `Show_On_Inv_Crds` (`show_on_inv_crds`),
  KEY `Hide` (`hidemovt`),
  KEY `reference` (`reference`),
  CONSTRAINT `stockmoves_ibfk_1` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `stockmoves_ibfk_2` FOREIGN KEY (`type`) REFERENCES `weberp_systypes` (`typeid`),
  CONSTRAINT `stockmoves_ibfk_3` FOREIGN KEY (`loccode`) REFERENCES `weberp_locations` (`loccode`),
  CONSTRAINT `stockmoves_ibfk_4` FOREIGN KEY (`prd`) REFERENCES `weberp_periods` (`periodno`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockmovestaxes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_stockmovestaxes` (
  `stkmoveno` int(11) NOT NULL DEFAULT '0',
  `taxauthid` tinyint(4) NOT NULL DEFAULT '0',
  `taxrate` double NOT NULL DEFAULT '0',
  `taxontax` tinyint(4) NOT NULL DEFAULT '0',
  `taxcalculationorder` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`stkmoveno`,`taxauthid`),
  KEY `taxauthid` (`taxauthid`),
  KEY `calculationorder` (`taxcalculationorder`),
  CONSTRAINT `stockmovestaxes_ibfk_1` FOREIGN KEY (`taxauthid`) REFERENCES `weberp_taxauthorities` (`taxid`),
  CONSTRAINT `stockmovestaxes_ibfk_2` FOREIGN KEY (`stkmoveno`) REFERENCES `weberp_stockmoves` (`stkmoveno`),
  CONSTRAINT `stockmovestaxes_ibfk_3` FOREIGN KEY (`stkmoveno`) REFERENCES `weberp_stockmoves` (`stkmoveno`),
  CONSTRAINT `stockmovestaxes_ibfk_4` FOREIGN KEY (`stkmoveno`) REFERENCES `weberp_stockmoves` (`stkmoveno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockrequest`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_stockrequest` (
  `dispatchid` int(11) NOT NULL AUTO_INCREMENT,
  `loccode` varchar(5) NOT NULL DEFAULT '',
  `departmentid` int(11) NOT NULL DEFAULT '0',
  `despatchdate` date NOT NULL DEFAULT '2016-01-01',
  `authorised` tinyint(4) NOT NULL DEFAULT '0',
  `closed` tinyint(4) NOT NULL DEFAULT '0',
  `narrative` text NOT NULL,
  PRIMARY KEY (`dispatchid`),
  KEY `loccode` (`loccode`),
  KEY `departmentid` (`departmentid`),
  CONSTRAINT `stockrequest_ibfk_1` FOREIGN KEY (`loccode`) REFERENCES `weberp_locations` (`loccode`),
  CONSTRAINT `stockrequest_ibfk_2` FOREIGN KEY (`departmentid`) REFERENCES `weberp_departments` (`departmentid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockrequestitems`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_stockrequestitems` (
  `dispatchitemsid` int(11) NOT NULL DEFAULT '0',
  `dispatchid` int(11) NOT NULL DEFAULT '0',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `quantity` double NOT NULL DEFAULT '0',
  `qtydelivered` double NOT NULL DEFAULT '0',
  `decimalplaces` int(11) NOT NULL DEFAULT '0',
  `uom` varchar(20) NOT NULL DEFAULT '',
  `completed` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`dispatchitemsid`,`dispatchid`),
  KEY `dispatchid` (`dispatchid`),
  KEY `stockid` (`stockid`),
  CONSTRAINT `stockrequestitems_ibfk_1` FOREIGN KEY (`dispatchid`) REFERENCES `weberp_stockrequest` (`dispatchid`),
  CONSTRAINT `stockrequestitems_ibfk_2` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `stockrequestitems_ibfk_3` FOREIGN KEY (`dispatchid`) REFERENCES `weberp_stockrequest` (`dispatchid`),
  CONSTRAINT `stockrequestitems_ibfk_4` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockserialitems`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_stockserialitems` (
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `loccode` varchar(5) NOT NULL DEFAULT '',
  `serialno` varchar(30) NOT NULL DEFAULT '',
  `expirationdate` datetime NOT NULL DEFAULT '2016-01-01 00:00:00',
  `quantity` double NOT NULL DEFAULT '0',
  `qualitytext` text NOT NULL,
  PRIMARY KEY (`stockid`,`serialno`,`loccode`),
  KEY `StockID` (`stockid`),
  KEY `LocCode` (`loccode`),
  KEY `serialno` (`serialno`),
  CONSTRAINT `stockserialitems_ibfk_1` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `stockserialitems_ibfk_2` FOREIGN KEY (`loccode`) REFERENCES `weberp_locations` (`loccode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stockserialmoves`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_stockserialmoves` (
  `stkitmmoveno` int(11) NOT NULL AUTO_INCREMENT,
  `stockmoveno` int(11) NOT NULL DEFAULT '0',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `serialno` varchar(30) NOT NULL DEFAULT '',
  `moveqty` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`stkitmmoveno`),
  KEY `StockMoveNo` (`stockmoveno`),
  KEY `StockID_SN` (`stockid`,`serialno`),
  KEY `serialno` (`serialno`),
  CONSTRAINT `stockserialmoves_ibfk_1` FOREIGN KEY (`stockmoveno`) REFERENCES `weberp_stockmoves` (`stkmoveno`),
  CONSTRAINT `stockserialmoves_ibfk_2` FOREIGN KEY (`stockid`, `serialno`) REFERENCES `weberp_stockserialitems` (`stockid`, `serialno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `suppallocs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_suppallocs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amt` double NOT NULL DEFAULT '0',
  `datealloc` date NOT NULL DEFAULT '2016-01-01',
  `transid_allocfrom` int(11) NOT NULL DEFAULT '0',
  `transid_allocto` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `TransID_AllocFrom` (`transid_allocfrom`),
  KEY `TransID_AllocTo` (`transid_allocto`),
  KEY `DateAlloc` (`datealloc`),
  CONSTRAINT `suppallocs_ibfk_1` FOREIGN KEY (`transid_allocfrom`) REFERENCES `weberp_supptrans` (`id`),
  CONSTRAINT `suppallocs_ibfk_2` FOREIGN KEY (`transid_allocto`) REFERENCES `weberp_supptrans` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `suppinvstogrn`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_suppinvstogrn` (
  `suppinv` int(11) NOT NULL,
  `grnno` int(11) NOT NULL,
  PRIMARY KEY (`suppinv`,`grnno`),
  KEY `suppinvstogrn_ibfk_1` (`grnno`),
  CONSTRAINT `suppinvstogrn_ibfk_1` FOREIGN KEY (`grnno`) REFERENCES `weberp_grns` (`grnno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `suppliercontacts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_suppliercontacts` (
  `supplierid` varchar(10) NOT NULL DEFAULT '',
  `contact` varchar(30) NOT NULL DEFAULT '',
  `position` varchar(30) NOT NULL DEFAULT '',
  `tel` varchar(30) NOT NULL DEFAULT '',
  `fax` varchar(30) NOT NULL DEFAULT '',
  `mobile` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(55) NOT NULL DEFAULT '',
  `ordercontact` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`supplierid`,`contact`),
  KEY `Contact` (`contact`),
  KEY `SupplierID` (`supplierid`),
  CONSTRAINT `suppliercontacts_ibfk_1` FOREIGN KEY (`supplierid`) REFERENCES `weberp_suppliers` (`supplierid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `supplierdiscounts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_supplierdiscounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supplierno` varchar(10) NOT NULL,
  `stockid` varchar(20) NOT NULL,
  `discountnarrative` varchar(20) NOT NULL,
  `discountpercent` double NOT NULL,
  `discountamount` double NOT NULL,
  `effectivefrom` date NOT NULL,
  `effectiveto` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `supplierno` (`supplierno`),
  KEY `effectivefrom` (`effectivefrom`),
  KEY `effectiveto` (`effectiveto`),
  KEY `stockid` (`stockid`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `suppliers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_suppliers` (
  `supplierid` varchar(10) NOT NULL DEFAULT '',
  `suppname` varchar(40) NOT NULL DEFAULT '',
  `address1` varchar(40) NOT NULL DEFAULT '',
  `address2` varchar(40) NOT NULL DEFAULT '',
  `address3` varchar(40) NOT NULL DEFAULT '',
  `address4` varchar(50) NOT NULL DEFAULT '',
  `address5` varchar(20) NOT NULL DEFAULT '',
  `address6` varchar(40) NOT NULL DEFAULT '',
  `supptype` tinyint(4) NOT NULL DEFAULT '1',
  `lat` float(10,6) NOT NULL DEFAULT '0.000000',
  `lng` float(10,6) NOT NULL DEFAULT '0.000000',
  `currcode` char(3) NOT NULL DEFAULT '',
  `suppliersince` date NOT NULL DEFAULT '2016-01-01',
  `paymentterms` char(2) NOT NULL DEFAULT '',
  `lastpaid` double NOT NULL DEFAULT '0',
  `lastpaiddate` datetime DEFAULT NULL,
  `bankact` varchar(30) NOT NULL DEFAULT '',
  `bankref` varchar(12) NOT NULL DEFAULT '',
  `bankpartics` varchar(12) NOT NULL DEFAULT '',
  `remittance` tinyint(4) NOT NULL DEFAULT '1',
  `taxgroupid` tinyint(4) NOT NULL DEFAULT '1',
  `factorcompanyid` int(11) NOT NULL DEFAULT '1',
  `taxref` varchar(20) NOT NULL DEFAULT '',
  `phn` varchar(50) NOT NULL DEFAULT '',
  `port` varchar(200) NOT NULL DEFAULT '',
  `email` varchar(55) DEFAULT NULL,
  `fax` varchar(25) DEFAULT NULL,
  `telephone` varchar(25) DEFAULT NULL,
  `url` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`supplierid`),
  KEY `CurrCode` (`currcode`),
  KEY `PaymentTerms` (`paymentterms`),
  KEY `SuppName` (`suppname`),
  KEY `taxgroupid` (`taxgroupid`),
  CONSTRAINT `suppliers_ibfk_1` FOREIGN KEY (`currcode`) REFERENCES `weberp_currencies` (`currabrev`),
  CONSTRAINT `suppliers_ibfk_2` FOREIGN KEY (`paymentterms`) REFERENCES `weberp_paymentterms` (`termsindicator`),
  CONSTRAINT `suppliers_ibfk_3` FOREIGN KEY (`taxgroupid`) REFERENCES `weberp_taxgroups` (`taxgroupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `suppliertype`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_suppliertype` (
  `typeid` tinyint(4) NOT NULL AUTO_INCREMENT,
  `typename` varchar(100) NOT NULL,
  PRIMARY KEY (`typeid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `supptrans`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_supptrans` (
  `transno` int(11) NOT NULL DEFAULT '0',
  `type` smallint(6) NOT NULL DEFAULT '0',
  `supplierno` varchar(10) NOT NULL DEFAULT '',
  `suppreference` varchar(20) NOT NULL DEFAULT '',
  `trandate` date NOT NULL DEFAULT '2016-01-01',
  `duedate` date NOT NULL DEFAULT '2016-01-01',
  `inputdate` datetime NOT NULL,
  `settled` tinyint(4) NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '1',
  `ovamount` double NOT NULL DEFAULT '0',
  `ovgst` double NOT NULL DEFAULT '0',
  `diffonexch` double NOT NULL DEFAULT '0',
  `alloc` double NOT NULL DEFAULT '0',
  `transtext` text,
  `hold` tinyint(4) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `TypeTransNo` (`transno`,`type`),
  KEY `DueDate` (`duedate`),
  KEY `Hold` (`hold`),
  KEY `SupplierNo` (`supplierno`),
  KEY `Settled` (`settled`),
  KEY `SupplierNo_2` (`supplierno`,`suppreference`),
  KEY `SuppReference` (`suppreference`),
  KEY `TranDate` (`trandate`),
  KEY `TransNo` (`transno`),
  KEY `Type` (`type`),
  CONSTRAINT `supptrans_ibfk_1` FOREIGN KEY (`type`) REFERENCES `weberp_systypes` (`typeid`),
  CONSTRAINT `supptrans_ibfk_2` FOREIGN KEY (`supplierno`) REFERENCES `weberp_suppliers` (`supplierid`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `supptranstaxes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_supptranstaxes` (
  `supptransid` int(11) NOT NULL DEFAULT '0',
  `taxauthid` tinyint(4) NOT NULL DEFAULT '0',
  `taxamount` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`supptransid`,`taxauthid`),
  KEY `taxauthid` (`taxauthid`),
  CONSTRAINT `supptranstaxes_ibfk_1` FOREIGN KEY (`taxauthid`) REFERENCES `weberp_taxauthorities` (`taxid`),
  CONSTRAINT `supptranstaxes_ibfk_2` FOREIGN KEY (`supptransid`) REFERENCES `weberp_supptrans` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `systypes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_systypes` (
  `typeid` smallint(6) NOT NULL DEFAULT '0',
  `typename` char(50) NOT NULL DEFAULT '',
  `typeno` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`typeid`),
  KEY `TypeNo` (`typeno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tags`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_tags` (
  `tagref` tinyint(4) NOT NULL AUTO_INCREMENT,
  `tagdescription` varchar(50) NOT NULL,
  PRIMARY KEY (`tagref`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taxauthorities`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_taxauthorities` (
  `taxid` tinyint(4) NOT NULL AUTO_INCREMENT,
  `description` varchar(20) NOT NULL DEFAULT '',
  `taxglcode` varchar(20) NOT NULL DEFAULT '0',
  `purchtaxglaccount` varchar(20) NOT NULL DEFAULT '0',
  `bank` varchar(50) NOT NULL DEFAULT '',
  `bankacctype` varchar(20) NOT NULL DEFAULT '',
  `bankacc` varchar(50) NOT NULL DEFAULT '',
  `bankswift` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`taxid`),
  KEY `TaxGLCode` (`taxglcode`),
  KEY `PurchTaxGLAccount` (`purchtaxglaccount`),
  CONSTRAINT `taxauthorities_ibfk_1` FOREIGN KEY (`taxglcode`) REFERENCES `weberp_chartmaster` (`accountcode`),
  CONSTRAINT `taxauthorities_ibfk_2` FOREIGN KEY (`purchtaxglaccount`) REFERENCES `weberp_chartmaster` (`accountcode`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taxauthrates`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_taxauthrates` (
  `taxauthority` tinyint(4) NOT NULL DEFAULT '1',
  `dispatchtaxprovince` tinyint(4) NOT NULL DEFAULT '1',
  `taxcatid` tinyint(4) NOT NULL DEFAULT '0',
  `taxrate` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`taxauthority`,`dispatchtaxprovince`,`taxcatid`),
  KEY `TaxAuthority` (`taxauthority`),
  KEY `dispatchtaxprovince` (`dispatchtaxprovince`),
  KEY `taxcatid` (`taxcatid`),
  CONSTRAINT `taxauthrates_ibfk_1` FOREIGN KEY (`taxauthority`) REFERENCES `weberp_taxauthorities` (`taxid`),
  CONSTRAINT `taxauthrates_ibfk_2` FOREIGN KEY (`taxcatid`) REFERENCES `weberp_taxcategories` (`taxcatid`),
  CONSTRAINT `taxauthrates_ibfk_3` FOREIGN KEY (`dispatchtaxprovince`) REFERENCES `weberp_taxprovinces` (`taxprovinceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taxcategories`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_taxcategories` (
  `taxcatid` tinyint(4) NOT NULL AUTO_INCREMENT,
  `taxcatname` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`taxcatid`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taxgroups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_taxgroups` (
  `taxgroupid` tinyint(4) NOT NULL AUTO_INCREMENT,
  `taxgroupdescription` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`taxgroupid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taxgrouptaxes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_taxgrouptaxes` (
  `taxgroupid` tinyint(4) NOT NULL DEFAULT '0',
  `taxauthid` tinyint(4) NOT NULL DEFAULT '0',
  `calculationorder` tinyint(4) NOT NULL DEFAULT '0',
  `taxontax` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`taxgroupid`,`taxauthid`),
  KEY `taxgroupid` (`taxgroupid`),
  KEY `taxauthid` (`taxauthid`),
  CONSTRAINT `taxgrouptaxes_ibfk_1` FOREIGN KEY (`taxgroupid`) REFERENCES `weberp_taxgroups` (`taxgroupid`),
  CONSTRAINT `taxgrouptaxes_ibfk_2` FOREIGN KEY (`taxauthid`) REFERENCES `weberp_taxauthorities` (`taxid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taxprovinces`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_taxprovinces` (
  `taxprovinceid` tinyint(4) NOT NULL AUTO_INCREMENT,
  `taxprovincename` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`taxprovinceid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tenderitems`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_tenderitems` (
  `tenderid` int(11) NOT NULL DEFAULT '0',
  `stockid` varchar(20) NOT NULL DEFAULT '',
  `quantity` varchar(40) NOT NULL DEFAULT '',
  `units` varchar(20) NOT NULL DEFAULT 'each',
  PRIMARY KEY (`tenderid`,`stockid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tenders`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_tenders` (
  `tenderid` int(11) NOT NULL DEFAULT '0',
  `location` varchar(5) NOT NULL DEFAULT '',
  `address1` varchar(40) NOT NULL DEFAULT '',
  `address2` varchar(40) NOT NULL DEFAULT '',
  `address3` varchar(40) NOT NULL DEFAULT '',
  `address4` varchar(40) NOT NULL DEFAULT '',
  `address5` varchar(20) NOT NULL DEFAULT '',
  `address6` varchar(15) NOT NULL DEFAULT '',
  `telephone` varchar(25) NOT NULL DEFAULT '',
  `closed` int(2) NOT NULL DEFAULT '0',
  `requiredbydate` datetime NOT NULL DEFAULT '2016-01-01 00:00:00',
  PRIMARY KEY (`tenderid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tendersuppliers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_tendersuppliers` (
  `tenderid` int(11) NOT NULL DEFAULT '0',
  `supplierid` varchar(10) NOT NULL DEFAULT '',
  `email` varchar(40) NOT NULL DEFAULT '',
  `responded` int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tenderid`,`supplierid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `unitsofmeasure`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_unitsofmeasure` (
  `unitid` tinyint(4) NOT NULL AUTO_INCREMENT,
  `unitname` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`unitid`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `woitems`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_woitems` (
  `wo` int(11) NOT NULL,
  `stockid` char(20) NOT NULL DEFAULT '',
  `qtyreqd` double NOT NULL DEFAULT '1',
  `qtyrecd` double NOT NULL DEFAULT '0',
  `stdcost` double NOT NULL,
  `nextlotsnref` varchar(20) DEFAULT '',
  `comments` longblob,
  PRIMARY KEY (`wo`,`stockid`),
  KEY `stockid` (`stockid`),
  CONSTRAINT `woitems_ibfk_1` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `woitems_ibfk_2` FOREIGN KEY (`wo`) REFERENCES `weberp_workorders` (`wo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worequirements`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_worequirements` (
  `wo` int(11) NOT NULL,
  `parentstockid` varchar(20) NOT NULL,
  `stockid` varchar(20) NOT NULL,
  `qtypu` double NOT NULL DEFAULT '1',
  `stdcost` double NOT NULL DEFAULT '0',
  `autoissue` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`wo`,`parentstockid`,`stockid`),
  KEY `stockid` (`stockid`),
  KEY `worequirements_ibfk_3` (`parentstockid`),
  CONSTRAINT `worequirements_ibfk_1` FOREIGN KEY (`wo`) REFERENCES `weberp_workorders` (`wo`),
  CONSTRAINT `worequirements_ibfk_2` FOREIGN KEY (`stockid`) REFERENCES `weberp_stockmaster` (`stockid`),
  CONSTRAINT `worequirements_ibfk_3` FOREIGN KEY (`wo`, `parentstockid`) REFERENCES `weberp_woitems` (`wo`, `stockid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `workcentres`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_workcentres` (
  `code` char(5) NOT NULL DEFAULT '',
  `location` char(5) NOT NULL DEFAULT '',
  `description` char(20) NOT NULL DEFAULT '',
  `capacity` double NOT NULL DEFAULT '1',
  `overheadperhour` decimal(10,0) NOT NULL DEFAULT '0',
  `overheadrecoveryact` varchar(20) NOT NULL DEFAULT '0',
  `setuphrs` decimal(10,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`code`),
  KEY `Description` (`description`),
  KEY `Location` (`location`),
  CONSTRAINT `workcentres_ibfk_1` FOREIGN KEY (`location`) REFERENCES `weberp_locations` (`loccode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `workorders`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_workorders` (
  `wo` int(11) NOT NULL,
  `loccode` char(5) NOT NULL DEFAULT '',
  `requiredby` date NOT NULL DEFAULT '2016-01-01',
  `startdate` date NOT NULL DEFAULT '2016-01-01',
  `costissued` double NOT NULL DEFAULT '0',
  `closed` tinyint(4) NOT NULL DEFAULT '0',
  `closecomments` longblob,
  PRIMARY KEY (`wo`),
  KEY `LocCode` (`loccode`),
  KEY `StartDate` (`startdate`),
  KEY `RequiredBy` (`requiredby`),
  CONSTRAINT `worksorders_ibfk_1` FOREIGN KEY (`loccode`) REFERENCES `weberp_locations` (`loccode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `woserialnos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_woserialnos` (
  `wo` int(11) NOT NULL,
  `stockid` varchar(20) NOT NULL,
  `serialno` varchar(30) NOT NULL,
  `quantity` double NOT NULL DEFAULT '1',
  `qualitytext` text NOT NULL,
  PRIMARY KEY (`wo`,`stockid`,`serialno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `www_users`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weberp_www_users` (
  `userid` varchar(20) NOT NULL DEFAULT '',
  `password` text NOT NULL,
  `realname` varchar(35) NOT NULL DEFAULT '',
  `customerid` varchar(10) NOT NULL DEFAULT '',
  `supplierid` varchar(10) NOT NULL DEFAULT '',
  `salesman` char(3) NOT NULL,
  `phone` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(55) DEFAULT NULL,
  `defaultlocation` varchar(5) NOT NULL DEFAULT '',
  `fullaccess` int(11) NOT NULL DEFAULT '1',
  `cancreatetender` tinyint(1) NOT NULL DEFAULT '0',
  `lastvisitdate` datetime DEFAULT NULL,
  `branchcode` varchar(10) NOT NULL DEFAULT '',
  `pagesize` varchar(20) NOT NULL DEFAULT 'A4',
  `modulesallowed` varchar(25) NOT NULL,
  `showdashboard` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Display dashboard after login',
  `blocked` tinyint(4) NOT NULL DEFAULT '0',
  `displayrecordsmax` int(11) NOT NULL DEFAULT '0',
  `theme` varchar(30) NOT NULL DEFAULT 'fresh',
  `language` varchar(10) NOT NULL DEFAULT 'en_GB.utf8',
  `pdflanguage` tinyint(1) NOT NULL DEFAULT '0',
  `department` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`userid`),
  KEY `CustomerID` (`customerid`),
  KEY `DefaultLocation` (`defaultlocation`),
  CONSTRAINT `www_users_ibfk_1` FOREIGN KEY (`defaultlocation`) REFERENCES `weberp_locations` (`loccode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-05-16 21:37:01
-- MySQL dump 10.13  Distrib 5.5.46, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: weberpdemo
-- ------------------------------------------------------
-- Server version	5.5.46-0ubuntu0.14.04.2
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `accountgroups`
--

INSERT INTO `weberp_accountgroups` VALUES ('Cost of Goods Sold',2,1,5000,'');
INSERT INTO `weberp_accountgroups` VALUES ('Current Assets',20,0,1000,'');
INSERT INTO `weberp_accountgroups` VALUES ('Financed',50,0,3000,'');
INSERT INTO `weberp_accountgroups` VALUES ('Fixed Assets',10,0,500,'');
INSERT INTO `weberp_accountgroups` VALUES ('Giveaways',5,1,6000,'Promotions');
INSERT INTO `weberp_accountgroups` VALUES ('Income Tax',5,1,9000,'');
INSERT INTO `weberp_accountgroups` VALUES ('Liabilities',30,0,2000,'');
INSERT INTO `weberp_accountgroups` VALUES ('Marketing Expenses',5,1,6000,'');
INSERT INTO `weberp_accountgroups` VALUES ('Operating Expenses',5,1,7000,'');
INSERT INTO `weberp_accountgroups` VALUES ('Other Revenue and Expenses',5,1,8000,'');
INSERT INTO `weberp_accountgroups` VALUES ('Outward Freight',2,1,5000,'Cost of Goods Sold');
INSERT INTO `weberp_accountgroups` VALUES ('Promotions',5,1,6000,'Marketing Expenses');
INSERT INTO `weberp_accountgroups` VALUES ('Revenue',1,1,4000,'');
INSERT INTO `weberp_accountgroups` VALUES ('Sales',1,1,10,'');

--
-- Dumping data for table `bankaccounts`
--

INSERT INTO `weberp_bankaccounts` VALUES ('1010','GBP',2,'123','GBP account','123','','');
INSERT INTO `weberp_bankaccounts` VALUES ('1030','AUD',2,'12445','Cheque Account','124455667789','123 Straight Street','');
INSERT INTO `weberp_bankaccounts` VALUES ('1040','AUD',0,'','Savings Account','','','');
INSERT INTO `weberp_bankaccounts` VALUES ('1060','USD',1,'','USD Bank Account','123','','GIFTS');

--
-- Dumping data for table `chartmaster`
--

INSERT INTO `weberp_chartmaster` VALUES ('1','Default Sales/Discounts','Sales');
INSERT INTO `weberp_chartmaster` VALUES ('1010','Petty Cash','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1020','Cash on Hand','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1030','Cheque Accounts','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1040','Savings Accounts','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1050','Payroll Accounts','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1060','Special Accounts','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1070','Money Market Investments','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1080','Short-Term Investments (< 90 days)','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1090','Interest Receivable','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1100','Accounts Receivable','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1150','Allowance for Doubtful Accounts','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1200','Notes Receivable','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1250','Income Tax Receivable','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1300','Prepaid Expenses','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1350','Advances','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1400','Supplies Inventory','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1420','Raw Material Inventory','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1440','Work in Progress Inventory','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1460','Finished Goods Inventory','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1500','Land','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1550','Bonds','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1600','Buildings','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1620','Accumulated Depreciation of Buildings','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1650','Equipment','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1670','Accumulated Depreciation of Equipment','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1700','Furniture & Fixtures','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1710','Accumulated Depreciation of Furniture & Fixtures','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1720','Office Equipment','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1730','Accumulated Depreciation of Office Equipment','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1740','Software','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1750','Accumulated Depreciation of Software','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1760','Vehicles','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1770','Accumulated Depreciation Vehicles','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1780','Other Depreciable Property','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1790','Accumulated Depreciation of Other Depreciable Prop','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1800','Patents','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1850','Goodwill','Fixed Assets');
INSERT INTO `weberp_chartmaster` VALUES ('1900','Future Income Tax Receivable','Current Assets');
INSERT INTO `weberp_chartmaster` VALUES ('2010','Bank Indedebtedness (overdraft)','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2020','Retainers or Advances on Work','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2050','Interest Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2100','Accounts Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2150','Goods Received Suspense','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2200','Short-Term Loan Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2230','Current Portion of Long-Term Debt Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2250','Income Tax Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2300','GST Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2310','GST Recoverable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2320','PST Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2330','PST Recoverable (commission)','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2340','Payroll Tax Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2350','Withholding Income Tax Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2360','Other Taxes Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2400','Employee Salaries Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2410','Management Salaries Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2420','Director / Partner Fees Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2450','Health Benefits Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2460','Pension Benefits Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2480','Employment Insurance Premiums Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2500','Land Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2550','Long-Term Bank Loan','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2560','Notes Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2600','Building & Equipment Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2700','Furnishing & Fixture Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2720','Office Equipment Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2740','Vehicle Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2760','Other Property Payable','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2800','Shareholder Loans','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('2900','Suspense','Liabilities');
INSERT INTO `weberp_chartmaster` VALUES ('3100','Capital Stock','Financed');
INSERT INTO `weberp_chartmaster` VALUES ('3200','Capital Surplus / Dividends','Financed');
INSERT INTO `weberp_chartmaster` VALUES ('3300','Dividend Taxes Payable','Financed');
INSERT INTO `weberp_chartmaster` VALUES ('3400','Dividend Taxes Refundable','Financed');
INSERT INTO `weberp_chartmaster` VALUES ('3500','Retained Earnings','Financed');
INSERT INTO `weberp_chartmaster` VALUES ('4100','Product / Service Sales','Revenue');
INSERT INTO `weberp_chartmaster` VALUES ('4200','Sales Exchange Gains/Losses','Revenue');
INSERT INTO `weberp_chartmaster` VALUES ('4500','Consulting Services','Revenue');
INSERT INTO `weberp_chartmaster` VALUES ('4600','Rentals','Revenue');
INSERT INTO `weberp_chartmaster` VALUES ('4700','Finance Charge Income','Revenue');
INSERT INTO `weberp_chartmaster` VALUES ('4800','Sales Returns & Allowances','Revenue');
INSERT INTO `weberp_chartmaster` VALUES ('4900','Sales Discounts','Revenue');
INSERT INTO `weberp_chartmaster` VALUES ('5000','Cost of Sales','Cost of Goods Sold');
INSERT INTO `weberp_chartmaster` VALUES ('5100','Production Expenses','Cost of Goods Sold');
INSERT INTO `weberp_chartmaster` VALUES ('5200','Purchases Exchange Gains/Losses','Cost of Goods Sold');
INSERT INTO `weberp_chartmaster` VALUES ('5500','Direct Labour Costs','Cost of Goods Sold');
INSERT INTO `weberp_chartmaster` VALUES ('5600','Freight Charges','Outward Freight');
INSERT INTO `weberp_chartmaster` VALUES ('5700','Inventory Adjustment','Cost of Goods Sold');
INSERT INTO `weberp_chartmaster` VALUES ('5800','Purchase Returns & Allowances','Cost of Goods Sold');
INSERT INTO `weberp_chartmaster` VALUES ('5900','Purchase Discounts','Cost of Goods Sold');
INSERT INTO `weberp_chartmaster` VALUES ('6100','Advertising','Marketing Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('6150','Promotion','Promotions');
INSERT INTO `weberp_chartmaster` VALUES ('6200','Communications','Marketing Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('6250','Meeting Expenses','Marketing Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('6300','Travelling Expenses','Marketing Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('6400','Delivery Expenses','Marketing Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('6500','Sales Salaries & Commission','Marketing Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('6550','Sales Salaries & Commission Deductions','Marketing Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('6590','Benefits','Marketing Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('6600','Other Selling Expenses','Marketing Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('6700','Permits, Licenses & License Fees','Marketing Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('6800','Research & Development','Marketing Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('6900','Professional Services','Marketing Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7020','Support Salaries & Wages','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7030','Support Salary & Wage Deductions','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7040','Management Salaries','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7050','Management Salary deductions','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7060','Director / Partner Fees','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7070','Director / Partner Deductions','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7080','Payroll Tax','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7090','Benefits','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7100','Training & Education Expenses','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7150','Dues & Subscriptions','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7200','Accounting Fees','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7210','Audit Fees','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7220','Banking Fees','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7230','Credit Card Fees','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7240','Consulting Fees','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7260','Legal Fees','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7280','Other Professional Fees','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7300','Business Tax','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7350','Property Tax','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7390','Corporation Capital Tax','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7400','Office Rent','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7450','Equipment Rental','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7500','Office Supplies','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7550','Office Repair & Maintenance','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7600','Automotive Expenses','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7610','Communication Expenses','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7620','Insurance Expenses','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7630','Postage & Courier Expenses','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7640','Miscellaneous Expenses','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7650','Travel Expenses','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7660','Utilities','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7700','Ammortization Expenses','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7750','Depreciation Expenses','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7800','Interest Expense','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('7900','Bad Debt Expense','Operating Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('8100','Gain on Sale of Assets','Other Revenue and Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('8200','Interest Income','Other Revenue and Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('8300','Recovery on Bad Debt','Other Revenue and Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('8400','Other Revenue','Other Revenue and Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('8500','Loss on Sale of Assets','Other Revenue and Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('8600','Charitable Contributions','Other Revenue and Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('8900','Other Expenses','Other Revenue and Expenses');
INSERT INTO `weberp_chartmaster` VALUES ('9100','Income Tax Provision','Income Tax');

--
-- Dumping data for table `companies`
--

INSERT INTO `weberp_companies` VALUES (1,'weberpdemo','not entered yet','','123 Web Way','PO Box 123','Queen Street','Melbourne','Victoria 3043','Australia','+61 3 4567 8901','+61 3 4567 8902','weberp@weberpdemo.com','USD','1100','4900','2100','2400','2150','4200','5200','3500',1,1,1,'5600');

--
-- Dumping data for table `cogsglpostings`
--

INSERT INTO `weberp_cogsglpostings` VALUES (5,'AN','ANY','5000','AN');
INSERT INTO `weberp_cogsglpostings` VALUES (6,'123','ANY','6100','AN');

--
-- Dumping data for table `currencies`
--

INSERT INTO `weberp_currencies` VALUES ('Australian Dollars','AUD','Australia','cents',2,1.3709,0);
INSERT INTO `weberp_currencies` VALUES ('Swiss Francs','CHF','Swizerland','centimes',2,0.9763,0);
INSERT INTO `weberp_currencies` VALUES ('Euro','EUR','Euroland','cents',2,0.8837,1);
INSERT INTO `weberp_currencies` VALUES ('Pounds','GBP','England','Pence',2,0.6971,0);
INSERT INTO `weberp_currencies` VALUES ('Kenyian Shillings','KES','Kenya','none',0,100.6225,0);
INSERT INTO `weberp_currencies` VALUES ('US Dollars','USD','United States','Cents',2,1,1);

--
-- Dumping data for table `holdreasons`
--

INSERT INTO `weberp_holdreasons` VALUES (1,'Good History',0);
INSERT INTO `weberp_holdreasons` VALUES (20,'Watch',2);
INSERT INTO `weberp_holdreasons` VALUES (51,'In liquidation',1);

--
-- Dumping data for table `locations`
--

INSERT INTO `weberp_locations` VALUES ('AN','Anaheim',' ','','','','','United States','','','','Brett',1,'',0,'',0,1,'',1);
INSERT INTO `weberp_locations` VALUES ('MEL','Melbourne','1234 Collins Street','Melbourne','Victoria 2345','','2345','Australia','+(61) (3) 5678901','+61 3 56789013','jacko@webdemo.com','Jack Roberts',1,'',0,'',1,1,'',1);
INSERT INTO `weberp_locations` VALUES ('TOR','Toronto','Level 100 ','CN Tower','Toronto','','','','','','','Clive Contrary',1,'',1,'',1,1,'',1);

--
-- Dumping data for table `paymentterms`
--

INSERT INTO `weberp_paymentterms` VALUES ('20','Due 20th Of the Following Month',0,22);
INSERT INTO `weberp_paymentterms` VALUES ('30','Due By End Of The Following Month',0,30);
INSERT INTO `weberp_paymentterms` VALUES ('7','Payment due within 7 days',7,0);
INSERT INTO `weberp_paymentterms` VALUES ('CA','Cash Only',1,0);

--
-- Dumping data for table `reportlinks`
--

INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_accountsection','weberp_accountgroups.sectioninaccounts=weberp_accountsection.sectionid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountsection','weberp_accountgroups','weberp_accountsection.sectionid=weberp_accountgroups.sectioninaccounts');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_chartmaster','weberp_bankaccounts.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_bankaccounts','weberp_chartmaster.accountcode=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_systypes','weberp_banktrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_banktrans','weberp_systypes.typeid=weberp_banktrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_bankaccounts','weberp_banktrans.bankact=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_banktrans','weberp_bankaccounts.accountcode=weberp_banktrans.bankact');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.parent=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.parent');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_workcentres','weberp_bom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_bom','weberp_workcentres.code=weberp_bom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_locations','weberp_bom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_bom','weberp_locations.loccode=weberp_bom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_buckets','weberp_workcentres','weberp_buckets.workcentre=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_buckets','weberp_workcentres.code=weberp_buckets.workcentre');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_chartmaster','weberp_chartdetails.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_chartdetails','weberp_chartmaster.accountcode=weberp_chartdetails.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_periods','weberp_chartdetails.period=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_chartdetails','weberp_periods.periodno=weberp_chartdetails.period');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_accountgroups','weberp_chartmaster.group_=weberp_accountgroups.groupname');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_chartmaster','weberp_accountgroups.groupname=weberp_chartmaster.group_');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_workcentres','weberp_contractbom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_contractbom','weberp_workcentres.code=weberp_contractbom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_locations','weberp_contractbom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_contractbom','weberp_locations.loccode=weberp_contractbom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_stockmaster','weberp_contractbom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_contractbom','weberp_stockmaster.stockid=weberp_contractbom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractreqts','weberp_contracts','weberp_contractreqts.contract=weberp_contracts.contractref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_contractreqts','weberp_contracts.contractref=weberp_contractreqts.contract');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_custbranch','weberp_contracts.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_contracts','weberp_custbranch.debtorno=weberp_contracts.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_stockcategory','weberp_contracts.branchcode=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_contracts','weberp_stockcategory.categoryid=weberp_contracts.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_salestypes','weberp_contracts.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_contracts','weberp_salestypes.typeabbrev=weberp_contracts.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocfrom=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocto=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtorsmaster','weberp_custbranch.debtorno=weberp_debtorsmaster.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_custbranch','weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_areas','weberp_custbranch.area=weberp_areas.areacode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_areas','weberp_custbranch','weberp_areas.areacode=weberp_custbranch.area');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesman','weberp_custbranch.salesman=weberp_salesman.salesmancode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesman','weberp_custbranch','weberp_salesman.salesmancode=weberp_custbranch.salesman');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_locations','weberp_custbranch.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_custbranch','weberp_locations.loccode=weberp_custbranch.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_shippers','weberp_custbranch.defaultshipvia=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_custbranch','weberp_shippers.shipper_id=weberp_custbranch.defaultshipvia');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_holdreasons','weberp_debtorsmaster.holdreason=weberp_holdreasons.reasoncode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_holdreasons','weberp_debtorsmaster','weberp_holdreasons.reasoncode=weberp_debtorsmaster.holdreason');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_currencies','weberp_debtorsmaster.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_debtorsmaster','weberp_currencies.currabrev=weberp_debtorsmaster.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_paymentterms','weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_debtorsmaster','weberp_paymentterms.termsindicator=weberp_debtorsmaster.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_salestypes','weberp_debtorsmaster.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_debtorsmaster','weberp_salestypes.typeabbrev=weberp_debtorsmaster.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custbranch','weberp_debtortrans.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtortrans','weberp_custbranch.debtorno=weberp_debtortrans.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_systypes','weberp_debtortrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_debtortrans','weberp_systypes.typeid=weberp_debtortrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_periods','weberp_debtortrans.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_debtortrans','weberp_periods.periodno=weberp_debtortrans.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_taxauthorities','weberp_debtortranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_debtortranstaxes','weberp_taxauthorities.taxid=weberp_debtortranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_debtortrans','weberp_debtortranstaxes.debtortransid=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_debtortranstaxes','weberp_debtortrans.id=weberp_debtortranstaxes.debtortransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_discountmatrix','weberp_salestypes','weberp_discountmatrix.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_discountmatrix','weberp_salestypes.typeabbrev=weberp_discountmatrix.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_locations','weberp_freightcosts.locationfrom=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_freightcosts','weberp_locations.loccode=weberp_freightcosts.locationfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_shippers','weberp_freightcosts.shipperid=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_freightcosts','weberp_shippers.shipper_id=weberp_freightcosts.shipperid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_chartmaster','weberp_gltrans.account=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_gltrans','weberp_chartmaster.accountcode=weberp_gltrans.account');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_systypes','weberp_gltrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_gltrans','weberp_systypes.typeid=weberp_gltrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_periods','weberp_gltrans.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_gltrans','weberp_periods.periodno=weberp_gltrans.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_suppliers','weberp_grns.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_grns','weberp_suppliers.supplierid=weberp_grns.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_purchorderdetails','weberp_grns.podetailitem=weberp_purchorderdetails.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_grns','weberp_purchorderdetails.podetailitem=weberp_grns.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_taxprovinces','weberp_locations.taxprovinceid=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_locations','weberp_taxprovinces.taxprovinceid=weberp_locations.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_locations','weberp_locstock.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_locstock','weberp_locations.loccode=weberp_locstock.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_stockmaster','weberp_locstock.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_locstock','weberp_stockmaster.stockid=weberp_locstock.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.shiploc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.shiploc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.recloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.recloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_stockmaster','weberp_loctransfers.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_loctransfers','weberp_stockmaster.stockid=weberp_loctransfers.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_stockmaster','weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_orderdeliverydifferencesl','weberp_stockmaster.stockid=weberp_orderdeliverydifferenceslog.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_custbranch','weberp_orderdeliverydifferenceslog.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_orderdeliverydifferencesl','weberp_custbranch.debtorno=weberp_orderdeliverydifferenceslog.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_salesorders','weberp_orderdeliverydifferenceslog.branchcode=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_orderdeliverydifferencesl','weberp_salesorders.orderno=weberp_orderdeliverydifferenceslog.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_stockmaster','weberp_prices.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_prices','weberp_stockmaster.stockid=weberp_prices.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_currencies','weberp_prices.currabrev=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_prices','weberp_currencies.currabrev=weberp_prices.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_salestypes','weberp_prices.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_prices','weberp_salestypes.typeabbrev=weberp_prices.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_stockmaster','weberp_purchdata.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_purchdata','weberp_stockmaster.stockid=weberp_purchdata.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_suppliers','weberp_purchdata.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchdata','weberp_suppliers.supplierid=weberp_purchdata.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_purchorders','weberp_purchorderdetails.orderno=weberp_purchorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_purchorderdetails','weberp_purchorders.orderno=weberp_purchorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_suppliers','weberp_purchorders.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchorders','weberp_suppliers.supplierid=weberp_purchorders.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_locations','weberp_purchorders.intostocklocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_purchorders','weberp_locations.loccode=weberp_purchorders.intostocklocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_custbranch','weberp_recurringsalesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_recurringsalesorders','weberp_custbranch.branchcode=weberp_recurringsalesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_recurringsalesorders','weberp_recurrsalesorderdetails.recurrorderno=weberp_recurringsalesorders.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_recurrsalesorderdetails','weberp_recurringsalesorders.recurrorderno=weberp_recurrsalesorderdetails.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_stockmaster','weberp_recurrsalesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_recurrsalesorderdetails','weberp_stockmaster.stockid=weberp_recurrsalesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportcolumns','weberp_reportheaders','weberp_reportcolumns.reportid=weberp_reportheaders.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportheaders','weberp_reportcolumns','weberp_reportheaders.reportid=weberp_reportcolumns.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesanalysis','weberp_periods','weberp_salesanalysis.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_salesanalysis','weberp_periods.periodno=weberp_salesanalysis.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_stockmaster','weberp_salescatprod.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salescatprod','weberp_stockmaster.stockid=weberp_salescatprod.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_salescat','weberp_salescatprod.salescatid=weberp_salescat.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescat','weberp_salescatprod','weberp_salescat.salescatid=weberp_salescatprod.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_salesorders','weberp_salesorderdetails.orderno=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_salesorderdetails','weberp_salesorders.orderno=weberp_salesorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_stockmaster','weberp_salesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salesorderdetails','weberp_stockmaster.stockid=weberp_salesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_custbranch','weberp_salesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesorders','weberp_custbranch.branchcode=weberp_salesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_shippers','weberp_salesorders.debtorno=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_salesorders','weberp_shippers.shipper_id=weberp_salesorders.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_locations','weberp_salesorders.fromstkloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_salesorders','weberp_locations.loccode=weberp_salesorders.fromstkloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securityroles','weberp_securitygroups.secroleid=weberp_securityroles.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securityroles','weberp_securitygroups','weberp_securityroles.secroleid=weberp_securitygroups.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securitytokens','weberp_securitygroups.tokenid=weberp_securitytokens.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitytokens','weberp_securitygroups','weberp_securitytokens.tokenid=weberp_securitygroups.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_shipments','weberp_shipmentcharges.shiptref=weberp_shipments.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_shipmentcharges','weberp_shipments.shiptref=weberp_shipmentcharges.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_systypes','weberp_shipmentcharges.transtype=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_shipmentcharges','weberp_systypes.typeid=weberp_shipmentcharges.transtype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_suppliers','weberp_shipments.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_shipments','weberp_suppliers.supplierid=weberp_shipments.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_stockmaster','weberp_stockcheckfreeze.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcheckfreeze','weberp_stockmaster.stockid=weberp_stockcheckfreeze.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_locations','weberp_stockcheckfreeze.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcheckfreeze','weberp_locations.loccode=weberp_stockcheckfreeze.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_stockmaster','weberp_stockcounts.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcounts','weberp_stockmaster.stockid=weberp_stockcounts.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_locations','weberp_stockcounts.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcounts','weberp_locations.loccode=weberp_stockcounts.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcategory','weberp_stockmaster.categoryid=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_stockmaster','weberp_stockcategory.categoryid=weberp_stockmaster.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_taxcategories','weberp_stockmaster.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_stockmaster','weberp_taxcategories.taxcatid=weberp_stockmaster.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockmaster','weberp_stockmoves.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockmoves','weberp_stockmaster.stockid=weberp_stockmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_systypes','weberp_stockmoves.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_stockmoves','weberp_systypes.typeid=weberp_stockmoves.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_locations','weberp_stockmoves.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockmoves','weberp_locations.loccode=weberp_stockmoves.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_periods','weberp_stockmoves.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_stockmoves','weberp_periods.periodno=weberp_stockmoves.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmovestaxes','weberp_taxauthorities','weberp_stockmovestaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_stockmovestaxes','weberp_taxauthorities.taxid=weberp_stockmovestaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockmaster','weberp_stockserialitems.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockserialitems','weberp_stockmaster.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_locations','weberp_stockserialitems.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockserialitems','weberp_locations.loccode=weberp_stockserialitems.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockmoves','weberp_stockserialmoves.stockmoveno=weberp_stockmoves.stkmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockserialmoves','weberp_stockmoves.stkmoveno=weberp_stockserialmoves.stockmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockserialitems','weberp_stockserialmoves.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockserialmoves','weberp_stockserialitems.stockid=weberp_stockserialmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocfrom=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocto=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliercontacts','weberp_suppliers','weberp_suppliercontacts.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_suppliercontacts','weberp_suppliers.supplierid=weberp_suppliercontacts.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_currencies','weberp_suppliers.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_suppliers','weberp_currencies.currabrev=weberp_suppliers.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_paymentterms','weberp_suppliers.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_suppliers','weberp_paymentterms.termsindicator=weberp_suppliers.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_taxgroups','weberp_suppliers.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_suppliers','weberp_taxgroups.taxgroupid=weberp_suppliers.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_systypes','weberp_supptrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_supptrans','weberp_systypes.typeid=weberp_supptrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppliers','weberp_supptrans.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_supptrans','weberp_suppliers.supplierid=weberp_supptrans.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_taxauthorities','weberp_supptranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_supptranstaxes','weberp_taxauthorities.taxid=weberp_supptranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_supptrans','weberp_supptranstaxes.supptransid=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_supptranstaxes','weberp_supptrans.id=weberp_supptranstaxes.supptransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.taxglcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.taxglcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.purchtaxglaccount=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.purchtaxglaccount');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxauthorities','weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxauthrates','weberp_taxauthorities.taxid=weberp_taxauthrates.taxauthority');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxcategories','weberp_taxauthrates.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_taxauthrates','weberp_taxcategories.taxcatid=weberp_taxauthrates.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxprovinces','weberp_taxauthrates.dispatchtaxprovince=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_taxauthrates','weberp_taxprovinces.taxprovinceid=weberp_taxauthrates.dispatchtaxprovince');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxgroups','weberp_taxgrouptaxes.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_taxgrouptaxes','weberp_taxgroups.taxgroupid=weberp_taxgrouptaxes.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxauthorities','weberp_taxgrouptaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxgrouptaxes','weberp_taxauthorities.taxid=weberp_taxgrouptaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_locations','weberp_workcentres.location=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_workcentres','weberp_locations.loccode=weberp_workcentres.location');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_locations','weberp_worksorders.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_worksorders','weberp_locations.loccode=weberp_worksorders.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_stockmaster','weberp_worksorders.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_worksorders','weberp_stockmaster.stockid=weberp_worksorders.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_www_users','weberp_locations','weberp_www_users.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_www_users','weberp_locations.loccode=weberp_www_users.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_accountsection','weberp_accountgroups.sectioninaccounts=weberp_accountsection.sectionid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountsection','weberp_accountgroups','weberp_accountsection.sectionid=weberp_accountgroups.sectioninaccounts');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_chartmaster','weberp_bankaccounts.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_bankaccounts','weberp_chartmaster.accountcode=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_systypes','weberp_banktrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_banktrans','weberp_systypes.typeid=weberp_banktrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_bankaccounts','weberp_banktrans.bankact=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_banktrans','weberp_bankaccounts.accountcode=weberp_banktrans.bankact');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.parent=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.parent');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_workcentres','weberp_bom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_bom','weberp_workcentres.code=weberp_bom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_locations','weberp_bom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_bom','weberp_locations.loccode=weberp_bom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_buckets','weberp_workcentres','weberp_buckets.workcentre=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_buckets','weberp_workcentres.code=weberp_buckets.workcentre');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_chartmaster','weberp_chartdetails.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_chartdetails','weberp_chartmaster.accountcode=weberp_chartdetails.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_periods','weberp_chartdetails.period=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_chartdetails','weberp_periods.periodno=weberp_chartdetails.period');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_accountgroups','weberp_chartmaster.group_=weberp_accountgroups.groupname');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_chartmaster','weberp_accountgroups.groupname=weberp_chartmaster.group_');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_workcentres','weberp_contractbom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_contractbom','weberp_workcentres.code=weberp_contractbom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_locations','weberp_contractbom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_contractbom','weberp_locations.loccode=weberp_contractbom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_stockmaster','weberp_contractbom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_contractbom','weberp_stockmaster.stockid=weberp_contractbom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractreqts','weberp_contracts','weberp_contractreqts.contract=weberp_contracts.contractref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_contractreqts','weberp_contracts.contractref=weberp_contractreqts.contract');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_custbranch','weberp_contracts.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_contracts','weberp_custbranch.debtorno=weberp_contracts.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_stockcategory','weberp_contracts.branchcode=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_contracts','weberp_stockcategory.categoryid=weberp_contracts.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_salestypes','weberp_contracts.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_contracts','weberp_salestypes.typeabbrev=weberp_contracts.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocfrom=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocto=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtorsmaster','weberp_custbranch.debtorno=weberp_debtorsmaster.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_custbranch','weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_areas','weberp_custbranch.area=weberp_areas.areacode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_areas','weberp_custbranch','weberp_areas.areacode=weberp_custbranch.area');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesman','weberp_custbranch.salesman=weberp_salesman.salesmancode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesman','weberp_custbranch','weberp_salesman.salesmancode=weberp_custbranch.salesman');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_locations','weberp_custbranch.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_custbranch','weberp_locations.loccode=weberp_custbranch.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_shippers','weberp_custbranch.defaultshipvia=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_custbranch','weberp_shippers.shipper_id=weberp_custbranch.defaultshipvia');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_holdreasons','weberp_debtorsmaster.holdreason=weberp_holdreasons.reasoncode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_holdreasons','weberp_debtorsmaster','weberp_holdreasons.reasoncode=weberp_debtorsmaster.holdreason');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_currencies','weberp_debtorsmaster.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_debtorsmaster','weberp_currencies.currabrev=weberp_debtorsmaster.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_paymentterms','weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_debtorsmaster','weberp_paymentterms.termsindicator=weberp_debtorsmaster.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_salestypes','weberp_debtorsmaster.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_debtorsmaster','weberp_salestypes.typeabbrev=weberp_debtorsmaster.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custbranch','weberp_debtortrans.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtortrans','weberp_custbranch.debtorno=weberp_debtortrans.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_systypes','weberp_debtortrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_debtortrans','weberp_systypes.typeid=weberp_debtortrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_periods','weberp_debtortrans.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_debtortrans','weberp_periods.periodno=weberp_debtortrans.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_taxauthorities','weberp_debtortranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_debtortranstaxes','weberp_taxauthorities.taxid=weberp_debtortranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_debtortrans','weberp_debtortranstaxes.debtortransid=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_debtortranstaxes','weberp_debtortrans.id=weberp_debtortranstaxes.debtortransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_discountmatrix','weberp_salestypes','weberp_discountmatrix.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_discountmatrix','weberp_salestypes.typeabbrev=weberp_discountmatrix.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_locations','weberp_freightcosts.locationfrom=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_freightcosts','weberp_locations.loccode=weberp_freightcosts.locationfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_shippers','weberp_freightcosts.shipperid=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_freightcosts','weberp_shippers.shipper_id=weberp_freightcosts.shipperid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_chartmaster','weberp_gltrans.account=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_gltrans','weberp_chartmaster.accountcode=weberp_gltrans.account');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_systypes','weberp_gltrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_gltrans','weberp_systypes.typeid=weberp_gltrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_periods','weberp_gltrans.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_gltrans','weberp_periods.periodno=weberp_gltrans.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_suppliers','weberp_grns.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_grns','weberp_suppliers.supplierid=weberp_grns.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_purchorderdetails','weberp_grns.podetailitem=weberp_purchorderdetails.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_grns','weberp_purchorderdetails.podetailitem=weberp_grns.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_taxprovinces','weberp_locations.taxprovinceid=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_locations','weberp_taxprovinces.taxprovinceid=weberp_locations.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_locations','weberp_locstock.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_locstock','weberp_locations.loccode=weberp_locstock.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_stockmaster','weberp_locstock.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_locstock','weberp_stockmaster.stockid=weberp_locstock.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.shiploc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.shiploc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.recloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.recloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_stockmaster','weberp_loctransfers.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_loctransfers','weberp_stockmaster.stockid=weberp_loctransfers.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_stockmaster','weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_orderdeliverydifferencesl','weberp_stockmaster.stockid=weberp_orderdeliverydifferenceslog.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_custbranch','weberp_orderdeliverydifferenceslog.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_orderdeliverydifferencesl','weberp_custbranch.debtorno=weberp_orderdeliverydifferenceslog.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_salesorders','weberp_orderdeliverydifferenceslog.branchcode=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_orderdeliverydifferencesl','weberp_salesorders.orderno=weberp_orderdeliverydifferenceslog.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_stockmaster','weberp_prices.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_prices','weberp_stockmaster.stockid=weberp_prices.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_currencies','weberp_prices.currabrev=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_prices','weberp_currencies.currabrev=weberp_prices.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_salestypes','weberp_prices.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_prices','weberp_salestypes.typeabbrev=weberp_prices.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_stockmaster','weberp_purchdata.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_purchdata','weberp_stockmaster.stockid=weberp_purchdata.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_suppliers','weberp_purchdata.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchdata','weberp_suppliers.supplierid=weberp_purchdata.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_purchorders','weberp_purchorderdetails.orderno=weberp_purchorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_purchorderdetails','weberp_purchorders.orderno=weberp_purchorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_suppliers','weberp_purchorders.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchorders','weberp_suppliers.supplierid=weberp_purchorders.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_locations','weberp_purchorders.intostocklocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_purchorders','weberp_locations.loccode=weberp_purchorders.intostocklocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_custbranch','weberp_recurringsalesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_recurringsalesorders','weberp_custbranch.branchcode=weberp_recurringsalesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_recurringsalesorders','weberp_recurrsalesorderdetails.recurrorderno=weberp_recurringsalesorders.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_recurrsalesorderdetails','weberp_recurringsalesorders.recurrorderno=weberp_recurrsalesorderdetails.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_stockmaster','weberp_recurrsalesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_recurrsalesorderdetails','weberp_stockmaster.stockid=weberp_recurrsalesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportcolumns','weberp_reportheaders','weberp_reportcolumns.reportid=weberp_reportheaders.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportheaders','weberp_reportcolumns','weberp_reportheaders.reportid=weberp_reportcolumns.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesanalysis','weberp_periods','weberp_salesanalysis.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_salesanalysis','weberp_periods.periodno=weberp_salesanalysis.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_stockmaster','weberp_salescatprod.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salescatprod','weberp_stockmaster.stockid=weberp_salescatprod.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_salescat','weberp_salescatprod.salescatid=weberp_salescat.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescat','weberp_salescatprod','weberp_salescat.salescatid=weberp_salescatprod.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_salesorders','weberp_salesorderdetails.orderno=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_salesorderdetails','weberp_salesorders.orderno=weberp_salesorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_stockmaster','weberp_salesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salesorderdetails','weberp_stockmaster.stockid=weberp_salesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_custbranch','weberp_salesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesorders','weberp_custbranch.branchcode=weberp_salesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_shippers','weberp_salesorders.debtorno=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_salesorders','weberp_shippers.shipper_id=weberp_salesorders.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_locations','weberp_salesorders.fromstkloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_salesorders','weberp_locations.loccode=weberp_salesorders.fromstkloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securityroles','weberp_securitygroups.secroleid=weberp_securityroles.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securityroles','weberp_securitygroups','weberp_securityroles.secroleid=weberp_securitygroups.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securitytokens','weberp_securitygroups.tokenid=weberp_securitytokens.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitytokens','weberp_securitygroups','weberp_securitytokens.tokenid=weberp_securitygroups.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_shipments','weberp_shipmentcharges.shiptref=weberp_shipments.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_shipmentcharges','weberp_shipments.shiptref=weberp_shipmentcharges.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_systypes','weberp_shipmentcharges.transtype=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_shipmentcharges','weberp_systypes.typeid=weberp_shipmentcharges.transtype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_suppliers','weberp_shipments.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_shipments','weberp_suppliers.supplierid=weberp_shipments.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_stockmaster','weberp_stockcheckfreeze.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcheckfreeze','weberp_stockmaster.stockid=weberp_stockcheckfreeze.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_locations','weberp_stockcheckfreeze.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcheckfreeze','weberp_locations.loccode=weberp_stockcheckfreeze.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_stockmaster','weberp_stockcounts.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcounts','weberp_stockmaster.stockid=weberp_stockcounts.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_locations','weberp_stockcounts.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcounts','weberp_locations.loccode=weberp_stockcounts.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcategory','weberp_stockmaster.categoryid=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_stockmaster','weberp_stockcategory.categoryid=weberp_stockmaster.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_taxcategories','weberp_stockmaster.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_stockmaster','weberp_taxcategories.taxcatid=weberp_stockmaster.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockmaster','weberp_stockmoves.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockmoves','weberp_stockmaster.stockid=weberp_stockmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_systypes','weberp_stockmoves.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_stockmoves','weberp_systypes.typeid=weberp_stockmoves.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_locations','weberp_stockmoves.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockmoves','weberp_locations.loccode=weberp_stockmoves.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_periods','weberp_stockmoves.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_stockmoves','weberp_periods.periodno=weberp_stockmoves.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmovestaxes','weberp_taxauthorities','weberp_stockmovestaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_stockmovestaxes','weberp_taxauthorities.taxid=weberp_stockmovestaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockmaster','weberp_stockserialitems.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockserialitems','weberp_stockmaster.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_locations','weberp_stockserialitems.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockserialitems','weberp_locations.loccode=weberp_stockserialitems.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockmoves','weberp_stockserialmoves.stockmoveno=weberp_stockmoves.stkmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockserialmoves','weberp_stockmoves.stkmoveno=weberp_stockserialmoves.stockmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockserialitems','weberp_stockserialmoves.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockserialmoves','weberp_stockserialitems.stockid=weberp_stockserialmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocfrom=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocto=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliercontacts','weberp_suppliers','weberp_suppliercontacts.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_suppliercontacts','weberp_suppliers.supplierid=weberp_suppliercontacts.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_currencies','weberp_suppliers.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_suppliers','weberp_currencies.currabrev=weberp_suppliers.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_paymentterms','weberp_suppliers.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_suppliers','weberp_paymentterms.termsindicator=weberp_suppliers.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_taxgroups','weberp_suppliers.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_suppliers','weberp_taxgroups.taxgroupid=weberp_suppliers.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_systypes','weberp_supptrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_supptrans','weberp_systypes.typeid=weberp_supptrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppliers','weberp_supptrans.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_supptrans','weberp_suppliers.supplierid=weberp_supptrans.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_taxauthorities','weberp_supptranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_supptranstaxes','weberp_taxauthorities.taxid=weberp_supptranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_supptrans','weberp_supptranstaxes.supptransid=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_supptranstaxes','weberp_supptrans.id=weberp_supptranstaxes.supptransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.taxglcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.taxglcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.purchtaxglaccount=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.purchtaxglaccount');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxauthorities','weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxauthrates','weberp_taxauthorities.taxid=weberp_taxauthrates.taxauthority');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxcategories','weberp_taxauthrates.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_taxauthrates','weberp_taxcategories.taxcatid=weberp_taxauthrates.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxprovinces','weberp_taxauthrates.dispatchtaxprovince=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_taxauthrates','weberp_taxprovinces.taxprovinceid=weberp_taxauthrates.dispatchtaxprovince');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxgroups','weberp_taxgrouptaxes.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_taxgrouptaxes','weberp_taxgroups.taxgroupid=weberp_taxgrouptaxes.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxauthorities','weberp_taxgrouptaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxgrouptaxes','weberp_taxauthorities.taxid=weberp_taxgrouptaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_locations','weberp_workcentres.location=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_workcentres','weberp_locations.loccode=weberp_workcentres.location');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_locations','weberp_worksorders.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_worksorders','weberp_locations.loccode=weberp_worksorders.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_stockmaster','weberp_worksorders.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_worksorders','weberp_stockmaster.stockid=weberp_worksorders.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_www_users','weberp_locations','weberp_www_users.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_www_users','weberp_locations.loccode=weberp_www_users.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_accountsection','weberp_accountgroups.sectioninaccounts=weberp_accountsection.sectionid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountsection','weberp_accountgroups','weberp_accountsection.sectionid=weberp_accountgroups.sectioninaccounts');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_chartmaster','weberp_bankaccounts.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_bankaccounts','weberp_chartmaster.accountcode=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_systypes','weberp_banktrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_banktrans','weberp_systypes.typeid=weberp_banktrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_bankaccounts','weberp_banktrans.bankact=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_banktrans','weberp_bankaccounts.accountcode=weberp_banktrans.bankact');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.parent=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.parent');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_workcentres','weberp_bom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_bom','weberp_workcentres.code=weberp_bom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_locations','weberp_bom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_bom','weberp_locations.loccode=weberp_bom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_buckets','weberp_workcentres','weberp_buckets.workcentre=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_buckets','weberp_workcentres.code=weberp_buckets.workcentre');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_chartmaster','weberp_chartdetails.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_chartdetails','weberp_chartmaster.accountcode=weberp_chartdetails.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_periods','weberp_chartdetails.period=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_chartdetails','weberp_periods.periodno=weberp_chartdetails.period');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_accountgroups','weberp_chartmaster.group_=weberp_accountgroups.groupname');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_chartmaster','weberp_accountgroups.groupname=weberp_chartmaster.group_');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_workcentres','weberp_contractbom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_contractbom','weberp_workcentres.code=weberp_contractbom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_locations','weberp_contractbom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_contractbom','weberp_locations.loccode=weberp_contractbom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_stockmaster','weberp_contractbom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_contractbom','weberp_stockmaster.stockid=weberp_contractbom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractreqts','weberp_contracts','weberp_contractreqts.contract=weberp_contracts.contractref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_contractreqts','weberp_contracts.contractref=weberp_contractreqts.contract');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_custbranch','weberp_contracts.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_contracts','weberp_custbranch.debtorno=weberp_contracts.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_stockcategory','weberp_contracts.branchcode=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_contracts','weberp_stockcategory.categoryid=weberp_contracts.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_salestypes','weberp_contracts.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_contracts','weberp_salestypes.typeabbrev=weberp_contracts.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocfrom=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocto=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtorsmaster','weberp_custbranch.debtorno=weberp_debtorsmaster.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_custbranch','weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_areas','weberp_custbranch.area=weberp_areas.areacode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_areas','weberp_custbranch','weberp_areas.areacode=weberp_custbranch.area');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesman','weberp_custbranch.salesman=weberp_salesman.salesmancode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesman','weberp_custbranch','weberp_salesman.salesmancode=weberp_custbranch.salesman');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_locations','weberp_custbranch.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_custbranch','weberp_locations.loccode=weberp_custbranch.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_shippers','weberp_custbranch.defaultshipvia=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_custbranch','weberp_shippers.shipper_id=weberp_custbranch.defaultshipvia');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_holdreasons','weberp_debtorsmaster.holdreason=weberp_holdreasons.reasoncode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_holdreasons','weberp_debtorsmaster','weberp_holdreasons.reasoncode=weberp_debtorsmaster.holdreason');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_currencies','weberp_debtorsmaster.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_debtorsmaster','weberp_currencies.currabrev=weberp_debtorsmaster.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_paymentterms','weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_debtorsmaster','weberp_paymentterms.termsindicator=weberp_debtorsmaster.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_salestypes','weberp_debtorsmaster.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_debtorsmaster','weberp_salestypes.typeabbrev=weberp_debtorsmaster.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custbranch','weberp_debtortrans.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtortrans','weberp_custbranch.debtorno=weberp_debtortrans.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_systypes','weberp_debtortrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_debtortrans','weberp_systypes.typeid=weberp_debtortrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_periods','weberp_debtortrans.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_debtortrans','weberp_periods.periodno=weberp_debtortrans.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_taxauthorities','weberp_debtortranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_debtortranstaxes','weberp_taxauthorities.taxid=weberp_debtortranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_debtortrans','weberp_debtortranstaxes.debtortransid=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_debtortranstaxes','weberp_debtortrans.id=weberp_debtortranstaxes.debtortransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_discountmatrix','weberp_salestypes','weberp_discountmatrix.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_discountmatrix','weberp_salestypes.typeabbrev=weberp_discountmatrix.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_locations','weberp_freightcosts.locationfrom=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_freightcosts','weberp_locations.loccode=weberp_freightcosts.locationfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_shippers','weberp_freightcosts.shipperid=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_freightcosts','weberp_shippers.shipper_id=weberp_freightcosts.shipperid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_chartmaster','weberp_gltrans.account=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_gltrans','weberp_chartmaster.accountcode=weberp_gltrans.account');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_systypes','weberp_gltrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_gltrans','weberp_systypes.typeid=weberp_gltrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_periods','weberp_gltrans.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_gltrans','weberp_periods.periodno=weberp_gltrans.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_suppliers','weberp_grns.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_grns','weberp_suppliers.supplierid=weberp_grns.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_purchorderdetails','weberp_grns.podetailitem=weberp_purchorderdetails.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_grns','weberp_purchorderdetails.podetailitem=weberp_grns.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_taxprovinces','weberp_locations.taxprovinceid=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_locations','weberp_taxprovinces.taxprovinceid=weberp_locations.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_locations','weberp_locstock.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_locstock','weberp_locations.loccode=weberp_locstock.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_stockmaster','weberp_locstock.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_locstock','weberp_stockmaster.stockid=weberp_locstock.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.shiploc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.shiploc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.recloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.recloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_stockmaster','weberp_loctransfers.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_loctransfers','weberp_stockmaster.stockid=weberp_loctransfers.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_stockmaster','weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_orderdeliverydifferencesl','weberp_stockmaster.stockid=weberp_orderdeliverydifferenceslog.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_custbranch','weberp_orderdeliverydifferenceslog.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_orderdeliverydifferencesl','weberp_custbranch.debtorno=weberp_orderdeliverydifferenceslog.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_salesorders','weberp_orderdeliverydifferenceslog.branchcode=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_orderdeliverydifferencesl','weberp_salesorders.orderno=weberp_orderdeliverydifferenceslog.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_stockmaster','weberp_prices.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_prices','weberp_stockmaster.stockid=weberp_prices.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_currencies','weberp_prices.currabrev=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_prices','weberp_currencies.currabrev=weberp_prices.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_salestypes','weberp_prices.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_prices','weberp_salestypes.typeabbrev=weberp_prices.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_stockmaster','weberp_purchdata.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_purchdata','weberp_stockmaster.stockid=weberp_purchdata.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_suppliers','weberp_purchdata.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchdata','weberp_suppliers.supplierid=weberp_purchdata.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_purchorders','weberp_purchorderdetails.orderno=weberp_purchorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_purchorderdetails','weberp_purchorders.orderno=weberp_purchorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_suppliers','weberp_purchorders.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchorders','weberp_suppliers.supplierid=weberp_purchorders.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_locations','weberp_purchorders.intostocklocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_purchorders','weberp_locations.loccode=weberp_purchorders.intostocklocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_custbranch','weberp_recurringsalesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_recurringsalesorders','weberp_custbranch.branchcode=weberp_recurringsalesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_recurringsalesorders','weberp_recurrsalesorderdetails.recurrorderno=weberp_recurringsalesorders.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_recurrsalesorderdetails','weberp_recurringsalesorders.recurrorderno=weberp_recurrsalesorderdetails.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_stockmaster','weberp_recurrsalesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_recurrsalesorderdetails','weberp_stockmaster.stockid=weberp_recurrsalesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportcolumns','weberp_reportheaders','weberp_reportcolumns.reportid=weberp_reportheaders.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportheaders','weberp_reportcolumns','weberp_reportheaders.reportid=weberp_reportcolumns.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesanalysis','weberp_periods','weberp_salesanalysis.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_salesanalysis','weberp_periods.periodno=weberp_salesanalysis.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_stockmaster','weberp_salescatprod.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salescatprod','weberp_stockmaster.stockid=weberp_salescatprod.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_salescat','weberp_salescatprod.salescatid=weberp_salescat.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescat','weberp_salescatprod','weberp_salescat.salescatid=weberp_salescatprod.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_salesorders','weberp_salesorderdetails.orderno=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_salesorderdetails','weberp_salesorders.orderno=weberp_salesorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_stockmaster','weberp_salesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salesorderdetails','weberp_stockmaster.stockid=weberp_salesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_custbranch','weberp_salesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesorders','weberp_custbranch.branchcode=weberp_salesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_shippers','weberp_salesorders.debtorno=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_salesorders','weberp_shippers.shipper_id=weberp_salesorders.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_locations','weberp_salesorders.fromstkloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_salesorders','weberp_locations.loccode=weberp_salesorders.fromstkloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securityroles','weberp_securitygroups.secroleid=weberp_securityroles.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securityroles','weberp_securitygroups','weberp_securityroles.secroleid=weberp_securitygroups.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securitytokens','weberp_securitygroups.tokenid=weberp_securitytokens.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitytokens','weberp_securitygroups','weberp_securitytokens.tokenid=weberp_securitygroups.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_shipments','weberp_shipmentcharges.shiptref=weberp_shipments.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_shipmentcharges','weberp_shipments.shiptref=weberp_shipmentcharges.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_systypes','weberp_shipmentcharges.transtype=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_shipmentcharges','weberp_systypes.typeid=weberp_shipmentcharges.transtype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_suppliers','weberp_shipments.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_shipments','weberp_suppliers.supplierid=weberp_shipments.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_stockmaster','weberp_stockcheckfreeze.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcheckfreeze','weberp_stockmaster.stockid=weberp_stockcheckfreeze.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_locations','weberp_stockcheckfreeze.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcheckfreeze','weberp_locations.loccode=weberp_stockcheckfreeze.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_stockmaster','weberp_stockcounts.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcounts','weberp_stockmaster.stockid=weberp_stockcounts.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_locations','weberp_stockcounts.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcounts','weberp_locations.loccode=weberp_stockcounts.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcategory','weberp_stockmaster.categoryid=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_stockmaster','weberp_stockcategory.categoryid=weberp_stockmaster.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_taxcategories','weberp_stockmaster.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_stockmaster','weberp_taxcategories.taxcatid=weberp_stockmaster.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockmaster','weberp_stockmoves.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockmoves','weberp_stockmaster.stockid=weberp_stockmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_systypes','weberp_stockmoves.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_stockmoves','weberp_systypes.typeid=weberp_stockmoves.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_locations','weberp_stockmoves.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockmoves','weberp_locations.loccode=weberp_stockmoves.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_periods','weberp_stockmoves.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_stockmoves','weberp_periods.periodno=weberp_stockmoves.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmovestaxes','weberp_taxauthorities','weberp_stockmovestaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_stockmovestaxes','weberp_taxauthorities.taxid=weberp_stockmovestaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockmaster','weberp_stockserialitems.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockserialitems','weberp_stockmaster.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_locations','weberp_stockserialitems.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockserialitems','weberp_locations.loccode=weberp_stockserialitems.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockmoves','weberp_stockserialmoves.stockmoveno=weberp_stockmoves.stkmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockserialmoves','weberp_stockmoves.stkmoveno=weberp_stockserialmoves.stockmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockserialitems','weberp_stockserialmoves.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockserialmoves','weberp_stockserialitems.stockid=weberp_stockserialmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocfrom=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocto=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliercontacts','weberp_suppliers','weberp_suppliercontacts.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_suppliercontacts','weberp_suppliers.supplierid=weberp_suppliercontacts.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_currencies','weberp_suppliers.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_suppliers','weberp_currencies.currabrev=weberp_suppliers.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_paymentterms','weberp_suppliers.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_suppliers','weberp_paymentterms.termsindicator=weberp_suppliers.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_taxgroups','weberp_suppliers.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_suppliers','weberp_taxgroups.taxgroupid=weberp_suppliers.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_systypes','weberp_supptrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_supptrans','weberp_systypes.typeid=weberp_supptrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppliers','weberp_supptrans.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_supptrans','weberp_suppliers.supplierid=weberp_supptrans.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_taxauthorities','weberp_supptranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_supptranstaxes','weberp_taxauthorities.taxid=weberp_supptranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_supptrans','weberp_supptranstaxes.supptransid=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_supptranstaxes','weberp_supptrans.id=weberp_supptranstaxes.supptransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.taxglcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.taxglcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.purchtaxglaccount=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.purchtaxglaccount');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxauthorities','weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxauthrates','weberp_taxauthorities.taxid=weberp_taxauthrates.taxauthority');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxcategories','weberp_taxauthrates.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_taxauthrates','weberp_taxcategories.taxcatid=weberp_taxauthrates.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxprovinces','weberp_taxauthrates.dispatchtaxprovince=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_taxauthrates','weberp_taxprovinces.taxprovinceid=weberp_taxauthrates.dispatchtaxprovince');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxgroups','weberp_taxgrouptaxes.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_taxgrouptaxes','weberp_taxgroups.taxgroupid=weberp_taxgrouptaxes.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxauthorities','weberp_taxgrouptaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxgrouptaxes','weberp_taxauthorities.taxid=weberp_taxgrouptaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_locations','weberp_workcentres.location=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_workcentres','weberp_locations.loccode=weberp_workcentres.location');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_locations','weberp_worksorders.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_worksorders','weberp_locations.loccode=weberp_worksorders.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_stockmaster','weberp_worksorders.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_worksorders','weberp_stockmaster.stockid=weberp_worksorders.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_www_users','weberp_locations','weberp_www_users.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_www_users','weberp_locations.loccode=weberp_www_users.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_accountsection','weberp_accountgroups.sectioninaccounts=weberp_accountsection.sectionid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountsection','weberp_accountgroups','weberp_accountsection.sectionid=weberp_accountgroups.sectioninaccounts');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_chartmaster','weberp_bankaccounts.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_bankaccounts','weberp_chartmaster.accountcode=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_systypes','weberp_banktrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_banktrans','weberp_systypes.typeid=weberp_banktrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_bankaccounts','weberp_banktrans.bankact=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_banktrans','weberp_bankaccounts.accountcode=weberp_banktrans.bankact');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.parent=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.parent');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_workcentres','weberp_bom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_bom','weberp_workcentres.code=weberp_bom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_locations','weberp_bom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_bom','weberp_locations.loccode=weberp_bom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_buckets','weberp_workcentres','weberp_buckets.workcentre=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_buckets','weberp_workcentres.code=weberp_buckets.workcentre');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_chartmaster','weberp_chartdetails.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_chartdetails','weberp_chartmaster.accountcode=weberp_chartdetails.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_periods','weberp_chartdetails.period=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_chartdetails','weberp_periods.periodno=weberp_chartdetails.period');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_accountgroups','weberp_chartmaster.group_=weberp_accountgroups.groupname');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_chartmaster','weberp_accountgroups.groupname=weberp_chartmaster.group_');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_workcentres','weberp_contractbom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_contractbom','weberp_workcentres.code=weberp_contractbom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_locations','weberp_contractbom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_contractbom','weberp_locations.loccode=weberp_contractbom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_stockmaster','weberp_contractbom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_contractbom','weberp_stockmaster.stockid=weberp_contractbom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractreqts','weberp_contracts','weberp_contractreqts.contract=weberp_contracts.contractref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_contractreqts','weberp_contracts.contractref=weberp_contractreqts.contract');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_custbranch','weberp_contracts.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_contracts','weberp_custbranch.debtorno=weberp_contracts.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_stockcategory','weberp_contracts.branchcode=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_contracts','weberp_stockcategory.categoryid=weberp_contracts.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_salestypes','weberp_contracts.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_contracts','weberp_salestypes.typeabbrev=weberp_contracts.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocfrom=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocto=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtorsmaster','weberp_custbranch.debtorno=weberp_debtorsmaster.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_custbranch','weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_areas','weberp_custbranch.area=weberp_areas.areacode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_areas','weberp_custbranch','weberp_areas.areacode=weberp_custbranch.area');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesman','weberp_custbranch.salesman=weberp_salesman.salesmancode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesman','weberp_custbranch','weberp_salesman.salesmancode=weberp_custbranch.salesman');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_locations','weberp_custbranch.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_custbranch','weberp_locations.loccode=weberp_custbranch.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_shippers','weberp_custbranch.defaultshipvia=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_custbranch','weberp_shippers.shipper_id=weberp_custbranch.defaultshipvia');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_holdreasons','weberp_debtorsmaster.holdreason=weberp_holdreasons.reasoncode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_holdreasons','weberp_debtorsmaster','weberp_holdreasons.reasoncode=weberp_debtorsmaster.holdreason');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_currencies','weberp_debtorsmaster.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_debtorsmaster','weberp_currencies.currabrev=weberp_debtorsmaster.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_paymentterms','weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_debtorsmaster','weberp_paymentterms.termsindicator=weberp_debtorsmaster.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_salestypes','weberp_debtorsmaster.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_debtorsmaster','weberp_salestypes.typeabbrev=weberp_debtorsmaster.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custbranch','weberp_debtortrans.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtortrans','weberp_custbranch.debtorno=weberp_debtortrans.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_systypes','weberp_debtortrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_debtortrans','weberp_systypes.typeid=weberp_debtortrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_periods','weberp_debtortrans.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_debtortrans','weberp_periods.periodno=weberp_debtortrans.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_taxauthorities','weberp_debtortranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_debtortranstaxes','weberp_taxauthorities.taxid=weberp_debtortranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_debtortrans','weberp_debtortranstaxes.debtortransid=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_debtortranstaxes','weberp_debtortrans.id=weberp_debtortranstaxes.debtortransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_discountmatrix','weberp_salestypes','weberp_discountmatrix.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_discountmatrix','weberp_salestypes.typeabbrev=weberp_discountmatrix.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_locations','weberp_freightcosts.locationfrom=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_freightcosts','weberp_locations.loccode=weberp_freightcosts.locationfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_shippers','weberp_freightcosts.shipperid=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_freightcosts','weberp_shippers.shipper_id=weberp_freightcosts.shipperid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_chartmaster','weberp_gltrans.account=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_gltrans','weberp_chartmaster.accountcode=weberp_gltrans.account');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_systypes','weberp_gltrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_gltrans','weberp_systypes.typeid=weberp_gltrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_periods','weberp_gltrans.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_gltrans','weberp_periods.periodno=weberp_gltrans.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_suppliers','weberp_grns.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_grns','weberp_suppliers.supplierid=weberp_grns.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_purchorderdetails','weberp_grns.podetailitem=weberp_purchorderdetails.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_grns','weberp_purchorderdetails.podetailitem=weberp_grns.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_taxprovinces','weberp_locations.taxprovinceid=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_locations','weberp_taxprovinces.taxprovinceid=weberp_locations.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_locations','weberp_locstock.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_locstock','weberp_locations.loccode=weberp_locstock.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_stockmaster','weberp_locstock.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_locstock','weberp_stockmaster.stockid=weberp_locstock.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.shiploc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.shiploc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.recloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.recloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_stockmaster','weberp_loctransfers.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_loctransfers','weberp_stockmaster.stockid=weberp_loctransfers.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_stockmaster','weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_orderdeliverydifferencesl','weberp_stockmaster.stockid=weberp_orderdeliverydifferenceslog.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_custbranch','weberp_orderdeliverydifferenceslog.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_orderdeliverydifferencesl','weberp_custbranch.debtorno=weberp_orderdeliverydifferenceslog.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_salesorders','weberp_orderdeliverydifferenceslog.branchcode=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_orderdeliverydifferencesl','weberp_salesorders.orderno=weberp_orderdeliverydifferenceslog.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_stockmaster','weberp_prices.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_prices','weberp_stockmaster.stockid=weberp_prices.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_currencies','weberp_prices.currabrev=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_prices','weberp_currencies.currabrev=weberp_prices.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_salestypes','weberp_prices.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_prices','weberp_salestypes.typeabbrev=weberp_prices.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_stockmaster','weberp_purchdata.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_purchdata','weberp_stockmaster.stockid=weberp_purchdata.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_suppliers','weberp_purchdata.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchdata','weberp_suppliers.supplierid=weberp_purchdata.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_purchorders','weberp_purchorderdetails.orderno=weberp_purchorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_purchorderdetails','weberp_purchorders.orderno=weberp_purchorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_suppliers','weberp_purchorders.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchorders','weberp_suppliers.supplierid=weberp_purchorders.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_locations','weberp_purchorders.intostocklocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_purchorders','weberp_locations.loccode=weberp_purchorders.intostocklocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_custbranch','weberp_recurringsalesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_recurringsalesorders','weberp_custbranch.branchcode=weberp_recurringsalesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_recurringsalesorders','weberp_recurrsalesorderdetails.recurrorderno=weberp_recurringsalesorders.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_recurrsalesorderdetails','weberp_recurringsalesorders.recurrorderno=weberp_recurrsalesorderdetails.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_stockmaster','weberp_recurrsalesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_recurrsalesorderdetails','weberp_stockmaster.stockid=weberp_recurrsalesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportcolumns','weberp_reportheaders','weberp_reportcolumns.reportid=weberp_reportheaders.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportheaders','weberp_reportcolumns','weberp_reportheaders.reportid=weberp_reportcolumns.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesanalysis','weberp_periods','weberp_salesanalysis.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_salesanalysis','weberp_periods.periodno=weberp_salesanalysis.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_stockmaster','weberp_salescatprod.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salescatprod','weberp_stockmaster.stockid=weberp_salescatprod.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_salescat','weberp_salescatprod.salescatid=weberp_salescat.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescat','weberp_salescatprod','weberp_salescat.salescatid=weberp_salescatprod.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_salesorders','weberp_salesorderdetails.orderno=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_salesorderdetails','weberp_salesorders.orderno=weberp_salesorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_stockmaster','weberp_salesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salesorderdetails','weberp_stockmaster.stockid=weberp_salesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_custbranch','weberp_salesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesorders','weberp_custbranch.branchcode=weberp_salesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_shippers','weberp_salesorders.debtorno=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_salesorders','weberp_shippers.shipper_id=weberp_salesorders.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_locations','weberp_salesorders.fromstkloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_salesorders','weberp_locations.loccode=weberp_salesorders.fromstkloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securityroles','weberp_securitygroups.secroleid=weberp_securityroles.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securityroles','weberp_securitygroups','weberp_securityroles.secroleid=weberp_securitygroups.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securitytokens','weberp_securitygroups.tokenid=weberp_securitytokens.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitytokens','weberp_securitygroups','weberp_securitytokens.tokenid=weberp_securitygroups.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_shipments','weberp_shipmentcharges.shiptref=weberp_shipments.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_shipmentcharges','weberp_shipments.shiptref=weberp_shipmentcharges.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_systypes','weberp_shipmentcharges.transtype=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_shipmentcharges','weberp_systypes.typeid=weberp_shipmentcharges.transtype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_suppliers','weberp_shipments.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_shipments','weberp_suppliers.supplierid=weberp_shipments.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_stockmaster','weberp_stockcheckfreeze.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcheckfreeze','weberp_stockmaster.stockid=weberp_stockcheckfreeze.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_locations','weberp_stockcheckfreeze.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcheckfreeze','weberp_locations.loccode=weberp_stockcheckfreeze.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_stockmaster','weberp_stockcounts.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcounts','weberp_stockmaster.stockid=weberp_stockcounts.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_locations','weberp_stockcounts.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcounts','weberp_locations.loccode=weberp_stockcounts.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcategory','weberp_stockmaster.categoryid=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_stockmaster','weberp_stockcategory.categoryid=weberp_stockmaster.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_taxcategories','weberp_stockmaster.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_stockmaster','weberp_taxcategories.taxcatid=weberp_stockmaster.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockmaster','weberp_stockmoves.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockmoves','weberp_stockmaster.stockid=weberp_stockmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_systypes','weberp_stockmoves.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_stockmoves','weberp_systypes.typeid=weberp_stockmoves.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_locations','weberp_stockmoves.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockmoves','weberp_locations.loccode=weberp_stockmoves.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_periods','weberp_stockmoves.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_stockmoves','weberp_periods.periodno=weberp_stockmoves.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmovestaxes','weberp_taxauthorities','weberp_stockmovestaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_stockmovestaxes','weberp_taxauthorities.taxid=weberp_stockmovestaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockmaster','weberp_stockserialitems.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockserialitems','weberp_stockmaster.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_locations','weberp_stockserialitems.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockserialitems','weberp_locations.loccode=weberp_stockserialitems.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockmoves','weberp_stockserialmoves.stockmoveno=weberp_stockmoves.stkmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockserialmoves','weberp_stockmoves.stkmoveno=weberp_stockserialmoves.stockmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockserialitems','weberp_stockserialmoves.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockserialmoves','weberp_stockserialitems.stockid=weberp_stockserialmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocfrom=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocto=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliercontacts','weberp_suppliers','weberp_suppliercontacts.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_suppliercontacts','weberp_suppliers.supplierid=weberp_suppliercontacts.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_currencies','weberp_suppliers.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_suppliers','weberp_currencies.currabrev=weberp_suppliers.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_paymentterms','weberp_suppliers.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_suppliers','weberp_paymentterms.termsindicator=weberp_suppliers.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_taxgroups','weberp_suppliers.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_suppliers','weberp_taxgroups.taxgroupid=weberp_suppliers.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_systypes','weberp_supptrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_supptrans','weberp_systypes.typeid=weberp_supptrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppliers','weberp_supptrans.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_supptrans','weberp_suppliers.supplierid=weberp_supptrans.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_taxauthorities','weberp_supptranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_supptranstaxes','weberp_taxauthorities.taxid=weberp_supptranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_supptrans','weberp_supptranstaxes.supptransid=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_supptranstaxes','weberp_supptrans.id=weberp_supptranstaxes.supptransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.taxglcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.taxglcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.purchtaxglaccount=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.purchtaxglaccount');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxauthorities','weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxauthrates','weberp_taxauthorities.taxid=weberp_taxauthrates.taxauthority');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxcategories','weberp_taxauthrates.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_taxauthrates','weberp_taxcategories.taxcatid=weberp_taxauthrates.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxprovinces','weberp_taxauthrates.dispatchtaxprovince=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_taxauthrates','weberp_taxprovinces.taxprovinceid=weberp_taxauthrates.dispatchtaxprovince');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxgroups','weberp_taxgrouptaxes.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_taxgrouptaxes','weberp_taxgroups.taxgroupid=weberp_taxgrouptaxes.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxauthorities','weberp_taxgrouptaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxgrouptaxes','weberp_taxauthorities.taxid=weberp_taxgrouptaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_locations','weberp_workcentres.location=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_workcentres','weberp_locations.loccode=weberp_workcentres.location');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_locations','weberp_worksorders.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_worksorders','weberp_locations.loccode=weberp_worksorders.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_stockmaster','weberp_worksorders.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_worksorders','weberp_stockmaster.stockid=weberp_worksorders.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_www_users','weberp_locations','weberp_www_users.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_www_users','weberp_locations.loccode=weberp_www_users.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_accountsection','weberp_accountgroups.sectioninaccounts=weberp_accountsection.sectionid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountsection','weberp_accountgroups','weberp_accountsection.sectionid=weberp_accountgroups.sectioninaccounts');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_chartmaster','weberp_bankaccounts.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_bankaccounts','weberp_chartmaster.accountcode=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_systypes','weberp_banktrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_banktrans','weberp_systypes.typeid=weberp_banktrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_bankaccounts','weberp_banktrans.bankact=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_banktrans','weberp_bankaccounts.accountcode=weberp_banktrans.bankact');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.parent=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.parent');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_workcentres','weberp_bom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_bom','weberp_workcentres.code=weberp_bom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_locations','weberp_bom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_bom','weberp_locations.loccode=weberp_bom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_buckets','weberp_workcentres','weberp_buckets.workcentre=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_buckets','weberp_workcentres.code=weberp_buckets.workcentre');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_chartmaster','weberp_chartdetails.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_chartdetails','weberp_chartmaster.accountcode=weberp_chartdetails.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_periods','weberp_chartdetails.period=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_chartdetails','weberp_periods.periodno=weberp_chartdetails.period');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_accountgroups','weberp_chartmaster.group_=weberp_accountgroups.groupname');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_chartmaster','weberp_accountgroups.groupname=weberp_chartmaster.group_');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_workcentres','weberp_contractbom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_contractbom','weberp_workcentres.code=weberp_contractbom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_locations','weberp_contractbom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_contractbom','weberp_locations.loccode=weberp_contractbom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_stockmaster','weberp_contractbom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_contractbom','weberp_stockmaster.stockid=weberp_contractbom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractreqts','weberp_contracts','weberp_contractreqts.contract=weberp_contracts.contractref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_contractreqts','weberp_contracts.contractref=weberp_contractreqts.contract');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_custbranch','weberp_contracts.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_contracts','weberp_custbranch.debtorno=weberp_contracts.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_stockcategory','weberp_contracts.branchcode=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_contracts','weberp_stockcategory.categoryid=weberp_contracts.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_salestypes','weberp_contracts.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_contracts','weberp_salestypes.typeabbrev=weberp_contracts.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocfrom=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocto=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtorsmaster','weberp_custbranch.debtorno=weberp_debtorsmaster.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_custbranch','weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_areas','weberp_custbranch.area=weberp_areas.areacode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_areas','weberp_custbranch','weberp_areas.areacode=weberp_custbranch.area');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesman','weberp_custbranch.salesman=weberp_salesman.salesmancode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesman','weberp_custbranch','weberp_salesman.salesmancode=weberp_custbranch.salesman');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_locations','weberp_custbranch.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_custbranch','weberp_locations.loccode=weberp_custbranch.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_shippers','weberp_custbranch.defaultshipvia=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_custbranch','weberp_shippers.shipper_id=weberp_custbranch.defaultshipvia');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_holdreasons','weberp_debtorsmaster.holdreason=weberp_holdreasons.reasoncode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_holdreasons','weberp_debtorsmaster','weberp_holdreasons.reasoncode=weberp_debtorsmaster.holdreason');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_currencies','weberp_debtorsmaster.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_debtorsmaster','weberp_currencies.currabrev=weberp_debtorsmaster.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_paymentterms','weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_debtorsmaster','weberp_paymentterms.termsindicator=weberp_debtorsmaster.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_salestypes','weberp_debtorsmaster.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_debtorsmaster','weberp_salestypes.typeabbrev=weberp_debtorsmaster.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custbranch','weberp_debtortrans.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtortrans','weberp_custbranch.debtorno=weberp_debtortrans.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_systypes','weberp_debtortrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_debtortrans','weberp_systypes.typeid=weberp_debtortrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_periods','weberp_debtortrans.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_debtortrans','weberp_periods.periodno=weberp_debtortrans.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_taxauthorities','weberp_debtortranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_debtortranstaxes','weberp_taxauthorities.taxid=weberp_debtortranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_debtortrans','weberp_debtortranstaxes.debtortransid=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_debtortranstaxes','weberp_debtortrans.id=weberp_debtortranstaxes.debtortransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_discountmatrix','weberp_salestypes','weberp_discountmatrix.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_discountmatrix','weberp_salestypes.typeabbrev=weberp_discountmatrix.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_locations','weberp_freightcosts.locationfrom=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_freightcosts','weberp_locations.loccode=weberp_freightcosts.locationfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_shippers','weberp_freightcosts.shipperid=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_freightcosts','weberp_shippers.shipper_id=weberp_freightcosts.shipperid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_chartmaster','weberp_gltrans.account=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_gltrans','weberp_chartmaster.accountcode=weberp_gltrans.account');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_systypes','weberp_gltrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_gltrans','weberp_systypes.typeid=weberp_gltrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_periods','weberp_gltrans.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_gltrans','weberp_periods.periodno=weberp_gltrans.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_suppliers','weberp_grns.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_grns','weberp_suppliers.supplierid=weberp_grns.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_purchorderdetails','weberp_grns.podetailitem=weberp_purchorderdetails.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_grns','weberp_purchorderdetails.podetailitem=weberp_grns.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_taxprovinces','weberp_locations.taxprovinceid=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_locations','weberp_taxprovinces.taxprovinceid=weberp_locations.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_locations','weberp_locstock.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_locstock','weberp_locations.loccode=weberp_locstock.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_stockmaster','weberp_locstock.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_locstock','weberp_stockmaster.stockid=weberp_locstock.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.shiploc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.shiploc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.recloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.recloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_stockmaster','weberp_loctransfers.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_loctransfers','weberp_stockmaster.stockid=weberp_loctransfers.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_stockmaster','weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_orderdeliverydifferencesl','weberp_stockmaster.stockid=weberp_orderdeliverydifferenceslog.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_custbranch','weberp_orderdeliverydifferenceslog.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_orderdeliverydifferencesl','weberp_custbranch.debtorno=weberp_orderdeliverydifferenceslog.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_salesorders','weberp_orderdeliverydifferenceslog.branchcode=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_orderdeliverydifferencesl','weberp_salesorders.orderno=weberp_orderdeliverydifferenceslog.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_stockmaster','weberp_prices.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_prices','weberp_stockmaster.stockid=weberp_prices.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_currencies','weberp_prices.currabrev=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_prices','weberp_currencies.currabrev=weberp_prices.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_salestypes','weberp_prices.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_prices','weberp_salestypes.typeabbrev=weberp_prices.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_stockmaster','weberp_purchdata.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_purchdata','weberp_stockmaster.stockid=weberp_purchdata.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_suppliers','weberp_purchdata.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchdata','weberp_suppliers.supplierid=weberp_purchdata.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_purchorders','weberp_purchorderdetails.orderno=weberp_purchorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_purchorderdetails','weberp_purchorders.orderno=weberp_purchorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_suppliers','weberp_purchorders.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchorders','weberp_suppliers.supplierid=weberp_purchorders.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_locations','weberp_purchorders.intostocklocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_purchorders','weberp_locations.loccode=weberp_purchorders.intostocklocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_custbranch','weberp_recurringsalesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_recurringsalesorders','weberp_custbranch.branchcode=weberp_recurringsalesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_recurringsalesorders','weberp_recurrsalesorderdetails.recurrorderno=weberp_recurringsalesorders.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_recurrsalesorderdetails','weberp_recurringsalesorders.recurrorderno=weberp_recurrsalesorderdetails.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_stockmaster','weberp_recurrsalesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_recurrsalesorderdetails','weberp_stockmaster.stockid=weberp_recurrsalesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportcolumns','weberp_reportheaders','weberp_reportcolumns.reportid=weberp_reportheaders.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportheaders','weberp_reportcolumns','weberp_reportheaders.reportid=weberp_reportcolumns.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesanalysis','weberp_periods','weberp_salesanalysis.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_salesanalysis','weberp_periods.periodno=weberp_salesanalysis.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_stockmaster','weberp_salescatprod.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salescatprod','weberp_stockmaster.stockid=weberp_salescatprod.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_salescat','weberp_salescatprod.salescatid=weberp_salescat.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescat','weberp_salescatprod','weberp_salescat.salescatid=weberp_salescatprod.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_salesorders','weberp_salesorderdetails.orderno=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_salesorderdetails','weberp_salesorders.orderno=weberp_salesorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_stockmaster','weberp_salesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salesorderdetails','weberp_stockmaster.stockid=weberp_salesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_custbranch','weberp_salesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesorders','weberp_custbranch.branchcode=weberp_salesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_shippers','weberp_salesorders.debtorno=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_salesorders','weberp_shippers.shipper_id=weberp_salesorders.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_locations','weberp_salesorders.fromstkloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_salesorders','weberp_locations.loccode=weberp_salesorders.fromstkloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securityroles','weberp_securitygroups.secroleid=weberp_securityroles.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securityroles','weberp_securitygroups','weberp_securityroles.secroleid=weberp_securitygroups.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securitytokens','weberp_securitygroups.tokenid=weberp_securitytokens.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitytokens','weberp_securitygroups','weberp_securitytokens.tokenid=weberp_securitygroups.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_shipments','weberp_shipmentcharges.shiptref=weberp_shipments.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_shipmentcharges','weberp_shipments.shiptref=weberp_shipmentcharges.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_systypes','weberp_shipmentcharges.transtype=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_shipmentcharges','weberp_systypes.typeid=weberp_shipmentcharges.transtype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_suppliers','weberp_shipments.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_shipments','weberp_suppliers.supplierid=weberp_shipments.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_stockmaster','weberp_stockcheckfreeze.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcheckfreeze','weberp_stockmaster.stockid=weberp_stockcheckfreeze.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_locations','weberp_stockcheckfreeze.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcheckfreeze','weberp_locations.loccode=weberp_stockcheckfreeze.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_stockmaster','weberp_stockcounts.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcounts','weberp_stockmaster.stockid=weberp_stockcounts.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_locations','weberp_stockcounts.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcounts','weberp_locations.loccode=weberp_stockcounts.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcategory','weberp_stockmaster.categoryid=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_stockmaster','weberp_stockcategory.categoryid=weberp_stockmaster.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_taxcategories','weberp_stockmaster.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_stockmaster','weberp_taxcategories.taxcatid=weberp_stockmaster.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockmaster','weberp_stockmoves.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockmoves','weberp_stockmaster.stockid=weberp_stockmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_systypes','weberp_stockmoves.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_stockmoves','weberp_systypes.typeid=weberp_stockmoves.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_locations','weberp_stockmoves.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockmoves','weberp_locations.loccode=weberp_stockmoves.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_periods','weberp_stockmoves.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_stockmoves','weberp_periods.periodno=weberp_stockmoves.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmovestaxes','weberp_taxauthorities','weberp_stockmovestaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_stockmovestaxes','weberp_taxauthorities.taxid=weberp_stockmovestaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockmaster','weberp_stockserialitems.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockserialitems','weberp_stockmaster.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_locations','weberp_stockserialitems.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockserialitems','weberp_locations.loccode=weberp_stockserialitems.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockmoves','weberp_stockserialmoves.stockmoveno=weberp_stockmoves.stkmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockserialmoves','weberp_stockmoves.stkmoveno=weberp_stockserialmoves.stockmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockserialitems','weberp_stockserialmoves.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockserialmoves','weberp_stockserialitems.stockid=weberp_stockserialmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocfrom=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocto=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliercontacts','weberp_suppliers','weberp_suppliercontacts.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_suppliercontacts','weberp_suppliers.supplierid=weberp_suppliercontacts.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_currencies','weberp_suppliers.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_suppliers','weberp_currencies.currabrev=weberp_suppliers.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_paymentterms','weberp_suppliers.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_suppliers','weberp_paymentterms.termsindicator=weberp_suppliers.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_taxgroups','weberp_suppliers.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_suppliers','weberp_taxgroups.taxgroupid=weberp_suppliers.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_systypes','weberp_supptrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_supptrans','weberp_systypes.typeid=weberp_supptrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppliers','weberp_supptrans.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_supptrans','weberp_suppliers.supplierid=weberp_supptrans.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_taxauthorities','weberp_supptranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_supptranstaxes','weberp_taxauthorities.taxid=weberp_supptranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_supptrans','weberp_supptranstaxes.supptransid=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_supptranstaxes','weberp_supptrans.id=weberp_supptranstaxes.supptransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.taxglcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.taxglcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.purchtaxglaccount=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.purchtaxglaccount');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxauthorities','weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxauthrates','weberp_taxauthorities.taxid=weberp_taxauthrates.taxauthority');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxcategories','weberp_taxauthrates.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_taxauthrates','weberp_taxcategories.taxcatid=weberp_taxauthrates.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxprovinces','weberp_taxauthrates.dispatchtaxprovince=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_taxauthrates','weberp_taxprovinces.taxprovinceid=weberp_taxauthrates.dispatchtaxprovince');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxgroups','weberp_taxgrouptaxes.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_taxgrouptaxes','weberp_taxgroups.taxgroupid=weberp_taxgrouptaxes.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxauthorities','weberp_taxgrouptaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxgrouptaxes','weberp_taxauthorities.taxid=weberp_taxgrouptaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_locations','weberp_workcentres.location=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_workcentres','weberp_locations.loccode=weberp_workcentres.location');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_locations','weberp_worksorders.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_worksorders','weberp_locations.loccode=weberp_worksorders.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_stockmaster','weberp_worksorders.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_worksorders','weberp_stockmaster.stockid=weberp_worksorders.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_www_users','weberp_locations','weberp_www_users.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_www_users','weberp_locations.loccode=weberp_www_users.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_accountsection','weberp_accountgroups.sectioninaccounts=weberp_accountsection.sectionid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountsection','weberp_accountgroups','weberp_accountsection.sectionid=weberp_accountgroups.sectioninaccounts');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_chartmaster','weberp_bankaccounts.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_bankaccounts','weberp_chartmaster.accountcode=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_systypes','weberp_banktrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_banktrans','weberp_systypes.typeid=weberp_banktrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_bankaccounts','weberp_banktrans.bankact=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_banktrans','weberp_bankaccounts.accountcode=weberp_banktrans.bankact');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.parent=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.parent');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_workcentres','weberp_bom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_bom','weberp_workcentres.code=weberp_bom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_locations','weberp_bom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_bom','weberp_locations.loccode=weberp_bom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_buckets','weberp_workcentres','weberp_buckets.workcentre=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_buckets','weberp_workcentres.code=weberp_buckets.workcentre');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_chartmaster','weberp_chartdetails.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_chartdetails','weberp_chartmaster.accountcode=weberp_chartdetails.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_periods','weberp_chartdetails.period=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_chartdetails','weberp_periods.periodno=weberp_chartdetails.period');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_accountgroups','weberp_chartmaster.group_=weberp_accountgroups.groupname');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_chartmaster','weberp_accountgroups.groupname=weberp_chartmaster.group_');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_workcentres','weberp_contractbom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_contractbom','weberp_workcentres.code=weberp_contractbom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_locations','weberp_contractbom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_contractbom','weberp_locations.loccode=weberp_contractbom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_stockmaster','weberp_contractbom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_contractbom','weberp_stockmaster.stockid=weberp_contractbom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractreqts','weberp_contracts','weberp_contractreqts.contract=weberp_contracts.contractref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_contractreqts','weberp_contracts.contractref=weberp_contractreqts.contract');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_custbranch','weberp_contracts.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_contracts','weberp_custbranch.debtorno=weberp_contracts.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_stockcategory','weberp_contracts.branchcode=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_contracts','weberp_stockcategory.categoryid=weberp_contracts.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_salestypes','weberp_contracts.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_contracts','weberp_salestypes.typeabbrev=weberp_contracts.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocfrom=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocto=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtorsmaster','weberp_custbranch.debtorno=weberp_debtorsmaster.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_custbranch','weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_areas','weberp_custbranch.area=weberp_areas.areacode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_areas','weberp_custbranch','weberp_areas.areacode=weberp_custbranch.area');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesman','weberp_custbranch.salesman=weberp_salesman.salesmancode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesman','weberp_custbranch','weberp_salesman.salesmancode=weberp_custbranch.salesman');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_locations','weberp_custbranch.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_custbranch','weberp_locations.loccode=weberp_custbranch.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_shippers','weberp_custbranch.defaultshipvia=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_custbranch','weberp_shippers.shipper_id=weberp_custbranch.defaultshipvia');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_holdreasons','weberp_debtorsmaster.holdreason=weberp_holdreasons.reasoncode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_holdreasons','weberp_debtorsmaster','weberp_holdreasons.reasoncode=weberp_debtorsmaster.holdreason');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_currencies','weberp_debtorsmaster.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_debtorsmaster','weberp_currencies.currabrev=weberp_debtorsmaster.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_paymentterms','weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_debtorsmaster','weberp_paymentterms.termsindicator=weberp_debtorsmaster.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_salestypes','weberp_debtorsmaster.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_debtorsmaster','weberp_salestypes.typeabbrev=weberp_debtorsmaster.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custbranch','weberp_debtortrans.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtortrans','weberp_custbranch.debtorno=weberp_debtortrans.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_systypes','weberp_debtortrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_debtortrans','weberp_systypes.typeid=weberp_debtortrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_periods','weberp_debtortrans.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_debtortrans','weberp_periods.periodno=weberp_debtortrans.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_taxauthorities','weberp_debtortranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_debtortranstaxes','weberp_taxauthorities.taxid=weberp_debtortranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_debtortrans','weberp_debtortranstaxes.debtortransid=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_debtortranstaxes','weberp_debtortrans.id=weberp_debtortranstaxes.debtortransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_discountmatrix','weberp_salestypes','weberp_discountmatrix.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_discountmatrix','weberp_salestypes.typeabbrev=weberp_discountmatrix.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_locations','weberp_freightcosts.locationfrom=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_freightcosts','weberp_locations.loccode=weberp_freightcosts.locationfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_shippers','weberp_freightcosts.shipperid=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_freightcosts','weberp_shippers.shipper_id=weberp_freightcosts.shipperid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_chartmaster','weberp_gltrans.account=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_gltrans','weberp_chartmaster.accountcode=weberp_gltrans.account');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_systypes','weberp_gltrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_gltrans','weberp_systypes.typeid=weberp_gltrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_periods','weberp_gltrans.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_gltrans','weberp_periods.periodno=weberp_gltrans.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_suppliers','weberp_grns.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_grns','weberp_suppliers.supplierid=weberp_grns.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_purchorderdetails','weberp_grns.podetailitem=weberp_purchorderdetails.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_grns','weberp_purchorderdetails.podetailitem=weberp_grns.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_taxprovinces','weberp_locations.taxprovinceid=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_locations','weberp_taxprovinces.taxprovinceid=weberp_locations.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_locations','weberp_locstock.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_locstock','weberp_locations.loccode=weberp_locstock.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_stockmaster','weberp_locstock.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_locstock','weberp_stockmaster.stockid=weberp_locstock.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.shiploc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.shiploc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.recloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.recloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_stockmaster','weberp_loctransfers.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_loctransfers','weberp_stockmaster.stockid=weberp_loctransfers.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_stockmaster','weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_orderdeliverydifferencesl','weberp_stockmaster.stockid=weberp_orderdeliverydifferenceslog.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_custbranch','weberp_orderdeliverydifferenceslog.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_orderdeliverydifferencesl','weberp_custbranch.debtorno=weberp_orderdeliverydifferenceslog.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_salesorders','weberp_orderdeliverydifferenceslog.branchcode=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_orderdeliverydifferencesl','weberp_salesorders.orderno=weberp_orderdeliverydifferenceslog.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_stockmaster','weberp_prices.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_prices','weberp_stockmaster.stockid=weberp_prices.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_currencies','weberp_prices.currabrev=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_prices','weberp_currencies.currabrev=weberp_prices.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_salestypes','weberp_prices.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_prices','weberp_salestypes.typeabbrev=weberp_prices.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_stockmaster','weberp_purchdata.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_purchdata','weberp_stockmaster.stockid=weberp_purchdata.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_suppliers','weberp_purchdata.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchdata','weberp_suppliers.supplierid=weberp_purchdata.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_purchorders','weberp_purchorderdetails.orderno=weberp_purchorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_purchorderdetails','weberp_purchorders.orderno=weberp_purchorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_suppliers','weberp_purchorders.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchorders','weberp_suppliers.supplierid=weberp_purchorders.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_locations','weberp_purchorders.intostocklocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_purchorders','weberp_locations.loccode=weberp_purchorders.intostocklocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_custbranch','weberp_recurringsalesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_recurringsalesorders','weberp_custbranch.branchcode=weberp_recurringsalesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_recurringsalesorders','weberp_recurrsalesorderdetails.recurrorderno=weberp_recurringsalesorders.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_recurrsalesorderdetails','weberp_recurringsalesorders.recurrorderno=weberp_recurrsalesorderdetails.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_stockmaster','weberp_recurrsalesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_recurrsalesorderdetails','weberp_stockmaster.stockid=weberp_recurrsalesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportcolumns','weberp_reportheaders','weberp_reportcolumns.reportid=weberp_reportheaders.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportheaders','weberp_reportcolumns','weberp_reportheaders.reportid=weberp_reportcolumns.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesanalysis','weberp_periods','weberp_salesanalysis.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_salesanalysis','weberp_periods.periodno=weberp_salesanalysis.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_stockmaster','weberp_salescatprod.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salescatprod','weberp_stockmaster.stockid=weberp_salescatprod.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_salescat','weberp_salescatprod.salescatid=weberp_salescat.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescat','weberp_salescatprod','weberp_salescat.salescatid=weberp_salescatprod.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_salesorders','weberp_salesorderdetails.orderno=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_salesorderdetails','weberp_salesorders.orderno=weberp_salesorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_stockmaster','weberp_salesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salesorderdetails','weberp_stockmaster.stockid=weberp_salesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_custbranch','weberp_salesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesorders','weberp_custbranch.branchcode=weberp_salesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_shippers','weberp_salesorders.debtorno=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_salesorders','weberp_shippers.shipper_id=weberp_salesorders.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_locations','weberp_salesorders.fromstkloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_salesorders','weberp_locations.loccode=weberp_salesorders.fromstkloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securityroles','weberp_securitygroups.secroleid=weberp_securityroles.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securityroles','weberp_securitygroups','weberp_securityroles.secroleid=weberp_securitygroups.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securitytokens','weberp_securitygroups.tokenid=weberp_securitytokens.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitytokens','weberp_securitygroups','weberp_securitytokens.tokenid=weberp_securitygroups.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_shipments','weberp_shipmentcharges.shiptref=weberp_shipments.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_shipmentcharges','weberp_shipments.shiptref=weberp_shipmentcharges.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_systypes','weberp_shipmentcharges.transtype=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_shipmentcharges','weberp_systypes.typeid=weberp_shipmentcharges.transtype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_suppliers','weberp_shipments.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_shipments','weberp_suppliers.supplierid=weberp_shipments.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_stockmaster','weberp_stockcheckfreeze.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcheckfreeze','weberp_stockmaster.stockid=weberp_stockcheckfreeze.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_locations','weberp_stockcheckfreeze.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcheckfreeze','weberp_locations.loccode=weberp_stockcheckfreeze.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_stockmaster','weberp_stockcounts.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcounts','weberp_stockmaster.stockid=weberp_stockcounts.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_locations','weberp_stockcounts.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcounts','weberp_locations.loccode=weberp_stockcounts.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcategory','weberp_stockmaster.categoryid=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_stockmaster','weberp_stockcategory.categoryid=weberp_stockmaster.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_taxcategories','weberp_stockmaster.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_stockmaster','weberp_taxcategories.taxcatid=weberp_stockmaster.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockmaster','weberp_stockmoves.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockmoves','weberp_stockmaster.stockid=weberp_stockmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_systypes','weberp_stockmoves.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_stockmoves','weberp_systypes.typeid=weberp_stockmoves.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_locations','weberp_stockmoves.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockmoves','weberp_locations.loccode=weberp_stockmoves.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_periods','weberp_stockmoves.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_stockmoves','weberp_periods.periodno=weberp_stockmoves.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmovestaxes','weberp_taxauthorities','weberp_stockmovestaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_stockmovestaxes','weberp_taxauthorities.taxid=weberp_stockmovestaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockmaster','weberp_stockserialitems.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockserialitems','weberp_stockmaster.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_locations','weberp_stockserialitems.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockserialitems','weberp_locations.loccode=weberp_stockserialitems.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockmoves','weberp_stockserialmoves.stockmoveno=weberp_stockmoves.stkmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockserialmoves','weberp_stockmoves.stkmoveno=weberp_stockserialmoves.stockmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockserialitems','weberp_stockserialmoves.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockserialmoves','weberp_stockserialitems.stockid=weberp_stockserialmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocfrom=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocto=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliercontacts','weberp_suppliers','weberp_suppliercontacts.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_suppliercontacts','weberp_suppliers.supplierid=weberp_suppliercontacts.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_currencies','weberp_suppliers.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_suppliers','weberp_currencies.currabrev=weberp_suppliers.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_paymentterms','weberp_suppliers.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_suppliers','weberp_paymentterms.termsindicator=weberp_suppliers.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_taxgroups','weberp_suppliers.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_suppliers','weberp_taxgroups.taxgroupid=weberp_suppliers.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_systypes','weberp_supptrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_supptrans','weberp_systypes.typeid=weberp_supptrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppliers','weberp_supptrans.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_supptrans','weberp_suppliers.supplierid=weberp_supptrans.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_taxauthorities','weberp_supptranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_supptranstaxes','weberp_taxauthorities.taxid=weberp_supptranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_supptrans','weberp_supptranstaxes.supptransid=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_supptranstaxes','weberp_supptrans.id=weberp_supptranstaxes.supptransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.taxglcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.taxglcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.purchtaxglaccount=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.purchtaxglaccount');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxauthorities','weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxauthrates','weberp_taxauthorities.taxid=weberp_taxauthrates.taxauthority');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxcategories','weberp_taxauthrates.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_taxauthrates','weberp_taxcategories.taxcatid=weberp_taxauthrates.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxprovinces','weberp_taxauthrates.dispatchtaxprovince=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_taxauthrates','weberp_taxprovinces.taxprovinceid=weberp_taxauthrates.dispatchtaxprovince');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxgroups','weberp_taxgrouptaxes.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_taxgrouptaxes','weberp_taxgroups.taxgroupid=weberp_taxgrouptaxes.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxauthorities','weberp_taxgrouptaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxgrouptaxes','weberp_taxauthorities.taxid=weberp_taxgrouptaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_locations','weberp_workcentres.location=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_workcentres','weberp_locations.loccode=weberp_workcentres.location');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_locations','weberp_worksorders.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_worksorders','weberp_locations.loccode=weberp_worksorders.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_stockmaster','weberp_worksorders.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_worksorders','weberp_stockmaster.stockid=weberp_worksorders.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_www_users','weberp_locations','weberp_www_users.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_www_users','weberp_locations.loccode=weberp_www_users.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_accountsection','weberp_accountgroups.sectioninaccounts=weberp_accountsection.sectionid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountsection','weberp_accountgroups','weberp_accountsection.sectionid=weberp_accountgroups.sectioninaccounts');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_chartmaster','weberp_bankaccounts.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_bankaccounts','weberp_chartmaster.accountcode=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_systypes','weberp_banktrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_banktrans','weberp_systypes.typeid=weberp_banktrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_bankaccounts','weberp_banktrans.bankact=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_banktrans','weberp_bankaccounts.accountcode=weberp_banktrans.bankact');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.parent=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.parent');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_workcentres','weberp_bom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_bom','weberp_workcentres.code=weberp_bom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_locations','weberp_bom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_bom','weberp_locations.loccode=weberp_bom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_buckets','weberp_workcentres','weberp_buckets.workcentre=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_buckets','weberp_workcentres.code=weberp_buckets.workcentre');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_chartmaster','weberp_chartdetails.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_chartdetails','weberp_chartmaster.accountcode=weberp_chartdetails.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_periods','weberp_chartdetails.period=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_chartdetails','weberp_periods.periodno=weberp_chartdetails.period');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_accountgroups','weberp_chartmaster.group_=weberp_accountgroups.groupname');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_chartmaster','weberp_accountgroups.groupname=weberp_chartmaster.group_');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_workcentres','weberp_contractbom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_contractbom','weberp_workcentres.code=weberp_contractbom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_locations','weberp_contractbom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_contractbom','weberp_locations.loccode=weberp_contractbom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_stockmaster','weberp_contractbom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_contractbom','weberp_stockmaster.stockid=weberp_contractbom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractreqts','weberp_contracts','weberp_contractreqts.contract=weberp_contracts.contractref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_contractreqts','weberp_contracts.contractref=weberp_contractreqts.contract');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_custbranch','weberp_contracts.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_contracts','weberp_custbranch.debtorno=weberp_contracts.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_stockcategory','weberp_contracts.branchcode=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_contracts','weberp_stockcategory.categoryid=weberp_contracts.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_salestypes','weberp_contracts.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_contracts','weberp_salestypes.typeabbrev=weberp_contracts.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocfrom=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocto=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtorsmaster','weberp_custbranch.debtorno=weberp_debtorsmaster.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_custbranch','weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_areas','weberp_custbranch.area=weberp_areas.areacode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_areas','weberp_custbranch','weberp_areas.areacode=weberp_custbranch.area');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesman','weberp_custbranch.salesman=weberp_salesman.salesmancode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesman','weberp_custbranch','weberp_salesman.salesmancode=weberp_custbranch.salesman');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_locations','weberp_custbranch.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_custbranch','weberp_locations.loccode=weberp_custbranch.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_shippers','weberp_custbranch.defaultshipvia=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_custbranch','weberp_shippers.shipper_id=weberp_custbranch.defaultshipvia');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_holdreasons','weberp_debtorsmaster.holdreason=weberp_holdreasons.reasoncode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_holdreasons','weberp_debtorsmaster','weberp_holdreasons.reasoncode=weberp_debtorsmaster.holdreason');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_currencies','weberp_debtorsmaster.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_debtorsmaster','weberp_currencies.currabrev=weberp_debtorsmaster.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_paymentterms','weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_debtorsmaster','weberp_paymentterms.termsindicator=weberp_debtorsmaster.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_salestypes','weberp_debtorsmaster.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_debtorsmaster','weberp_salestypes.typeabbrev=weberp_debtorsmaster.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custbranch','weberp_debtortrans.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtortrans','weberp_custbranch.debtorno=weberp_debtortrans.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_systypes','weberp_debtortrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_debtortrans','weberp_systypes.typeid=weberp_debtortrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_periods','weberp_debtortrans.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_debtortrans','weberp_periods.periodno=weberp_debtortrans.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_taxauthorities','weberp_debtortranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_debtortranstaxes','weberp_taxauthorities.taxid=weberp_debtortranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_debtortrans','weberp_debtortranstaxes.debtortransid=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_debtortranstaxes','weberp_debtortrans.id=weberp_debtortranstaxes.debtortransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_discountmatrix','weberp_salestypes','weberp_discountmatrix.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_discountmatrix','weberp_salestypes.typeabbrev=weberp_discountmatrix.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_locations','weberp_freightcosts.locationfrom=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_freightcosts','weberp_locations.loccode=weberp_freightcosts.locationfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_shippers','weberp_freightcosts.shipperid=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_freightcosts','weberp_shippers.shipper_id=weberp_freightcosts.shipperid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_chartmaster','weberp_gltrans.account=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_gltrans','weberp_chartmaster.accountcode=weberp_gltrans.account');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_systypes','weberp_gltrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_gltrans','weberp_systypes.typeid=weberp_gltrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_periods','weberp_gltrans.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_gltrans','weberp_periods.periodno=weberp_gltrans.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_suppliers','weberp_grns.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_grns','weberp_suppliers.supplierid=weberp_grns.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_purchorderdetails','weberp_grns.podetailitem=weberp_purchorderdetails.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_grns','weberp_purchorderdetails.podetailitem=weberp_grns.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_taxprovinces','weberp_locations.taxprovinceid=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_locations','weberp_taxprovinces.taxprovinceid=weberp_locations.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_locations','weberp_locstock.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_locstock','weberp_locations.loccode=weberp_locstock.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_stockmaster','weberp_locstock.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_locstock','weberp_stockmaster.stockid=weberp_locstock.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.shiploc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.shiploc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.recloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.recloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_stockmaster','weberp_loctransfers.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_loctransfers','weberp_stockmaster.stockid=weberp_loctransfers.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_stockmaster','weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_orderdeliverydifferencesl','weberp_stockmaster.stockid=weberp_orderdeliverydifferenceslog.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_custbranch','weberp_orderdeliverydifferenceslog.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_orderdeliverydifferencesl','weberp_custbranch.debtorno=weberp_orderdeliverydifferenceslog.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_salesorders','weberp_orderdeliverydifferenceslog.branchcode=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_orderdeliverydifferencesl','weberp_salesorders.orderno=weberp_orderdeliverydifferenceslog.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_stockmaster','weberp_prices.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_prices','weberp_stockmaster.stockid=weberp_prices.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_currencies','weberp_prices.currabrev=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_prices','weberp_currencies.currabrev=weberp_prices.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_salestypes','weberp_prices.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_prices','weberp_salestypes.typeabbrev=weberp_prices.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_stockmaster','weberp_purchdata.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_purchdata','weberp_stockmaster.stockid=weberp_purchdata.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_suppliers','weberp_purchdata.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchdata','weberp_suppliers.supplierid=weberp_purchdata.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_purchorders','weberp_purchorderdetails.orderno=weberp_purchorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_purchorderdetails','weberp_purchorders.orderno=weberp_purchorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_suppliers','weberp_purchorders.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchorders','weberp_suppliers.supplierid=weberp_purchorders.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_locations','weberp_purchorders.intostocklocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_purchorders','weberp_locations.loccode=weberp_purchorders.intostocklocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_custbranch','weberp_recurringsalesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_recurringsalesorders','weberp_custbranch.branchcode=weberp_recurringsalesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_recurringsalesorders','weberp_recurrsalesorderdetails.recurrorderno=weberp_recurringsalesorders.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_recurrsalesorderdetails','weberp_recurringsalesorders.recurrorderno=weberp_recurrsalesorderdetails.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_stockmaster','weberp_recurrsalesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_recurrsalesorderdetails','weberp_stockmaster.stockid=weberp_recurrsalesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportcolumns','weberp_reportheaders','weberp_reportcolumns.reportid=weberp_reportheaders.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportheaders','weberp_reportcolumns','weberp_reportheaders.reportid=weberp_reportcolumns.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesanalysis','weberp_periods','weberp_salesanalysis.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_salesanalysis','weberp_periods.periodno=weberp_salesanalysis.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_stockmaster','weberp_salescatprod.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salescatprod','weberp_stockmaster.stockid=weberp_salescatprod.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_salescat','weberp_salescatprod.salescatid=weberp_salescat.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescat','weberp_salescatprod','weberp_salescat.salescatid=weberp_salescatprod.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_salesorders','weberp_salesorderdetails.orderno=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_salesorderdetails','weberp_salesorders.orderno=weberp_salesorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_stockmaster','weberp_salesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salesorderdetails','weberp_stockmaster.stockid=weberp_salesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_custbranch','weberp_salesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesorders','weberp_custbranch.branchcode=weberp_salesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_shippers','weberp_salesorders.debtorno=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_salesorders','weberp_shippers.shipper_id=weberp_salesorders.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_locations','weberp_salesorders.fromstkloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_salesorders','weberp_locations.loccode=weberp_salesorders.fromstkloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securityroles','weberp_securitygroups.secroleid=weberp_securityroles.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securityroles','weberp_securitygroups','weberp_securityroles.secroleid=weberp_securitygroups.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securitytokens','weberp_securitygroups.tokenid=weberp_securitytokens.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitytokens','weberp_securitygroups','weberp_securitytokens.tokenid=weberp_securitygroups.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_shipments','weberp_shipmentcharges.shiptref=weberp_shipments.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_shipmentcharges','weberp_shipments.shiptref=weberp_shipmentcharges.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_systypes','weberp_shipmentcharges.transtype=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_shipmentcharges','weberp_systypes.typeid=weberp_shipmentcharges.transtype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_suppliers','weberp_shipments.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_shipments','weberp_suppliers.supplierid=weberp_shipments.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_stockmaster','weberp_stockcheckfreeze.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcheckfreeze','weberp_stockmaster.stockid=weberp_stockcheckfreeze.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_locations','weberp_stockcheckfreeze.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcheckfreeze','weberp_locations.loccode=weberp_stockcheckfreeze.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_stockmaster','weberp_stockcounts.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcounts','weberp_stockmaster.stockid=weberp_stockcounts.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_locations','weberp_stockcounts.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcounts','weberp_locations.loccode=weberp_stockcounts.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcategory','weberp_stockmaster.categoryid=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_stockmaster','weberp_stockcategory.categoryid=weberp_stockmaster.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_taxcategories','weberp_stockmaster.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_stockmaster','weberp_taxcategories.taxcatid=weberp_stockmaster.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockmaster','weberp_stockmoves.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockmoves','weberp_stockmaster.stockid=weberp_stockmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_systypes','weberp_stockmoves.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_stockmoves','weberp_systypes.typeid=weberp_stockmoves.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_locations','weberp_stockmoves.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockmoves','weberp_locations.loccode=weberp_stockmoves.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_periods','weberp_stockmoves.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_stockmoves','weberp_periods.periodno=weberp_stockmoves.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmovestaxes','weberp_taxauthorities','weberp_stockmovestaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_stockmovestaxes','weberp_taxauthorities.taxid=weberp_stockmovestaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockmaster','weberp_stockserialitems.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockserialitems','weberp_stockmaster.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_locations','weberp_stockserialitems.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockserialitems','weberp_locations.loccode=weberp_stockserialitems.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockmoves','weberp_stockserialmoves.stockmoveno=weberp_stockmoves.stkmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockserialmoves','weberp_stockmoves.stkmoveno=weberp_stockserialmoves.stockmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockserialitems','weberp_stockserialmoves.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockserialmoves','weberp_stockserialitems.stockid=weberp_stockserialmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocfrom=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocto=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliercontacts','weberp_suppliers','weberp_suppliercontacts.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_suppliercontacts','weberp_suppliers.supplierid=weberp_suppliercontacts.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_currencies','weberp_suppliers.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_suppliers','weberp_currencies.currabrev=weberp_suppliers.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_paymentterms','weberp_suppliers.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_suppliers','weberp_paymentterms.termsindicator=weberp_suppliers.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_taxgroups','weberp_suppliers.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_suppliers','weberp_taxgroups.taxgroupid=weberp_suppliers.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_systypes','weberp_supptrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_supptrans','weberp_systypes.typeid=weberp_supptrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppliers','weberp_supptrans.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_supptrans','weberp_suppliers.supplierid=weberp_supptrans.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_taxauthorities','weberp_supptranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_supptranstaxes','weberp_taxauthorities.taxid=weberp_supptranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_supptrans','weberp_supptranstaxes.supptransid=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_supptranstaxes','weberp_supptrans.id=weberp_supptranstaxes.supptransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.taxglcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.taxglcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.purchtaxglaccount=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.purchtaxglaccount');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxauthorities','weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxauthrates','weberp_taxauthorities.taxid=weberp_taxauthrates.taxauthority');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxcategories','weberp_taxauthrates.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_taxauthrates','weberp_taxcategories.taxcatid=weberp_taxauthrates.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxprovinces','weberp_taxauthrates.dispatchtaxprovince=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_taxauthrates','weberp_taxprovinces.taxprovinceid=weberp_taxauthrates.dispatchtaxprovince');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxgroups','weberp_taxgrouptaxes.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_taxgrouptaxes','weberp_taxgroups.taxgroupid=weberp_taxgrouptaxes.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxauthorities','weberp_taxgrouptaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxgrouptaxes','weberp_taxauthorities.taxid=weberp_taxgrouptaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_locations','weberp_workcentres.location=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_workcentres','weberp_locations.loccode=weberp_workcentres.location');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_locations','weberp_worksorders.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_worksorders','weberp_locations.loccode=weberp_worksorders.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_stockmaster','weberp_worksorders.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_worksorders','weberp_stockmaster.stockid=weberp_worksorders.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_www_users','weberp_locations','weberp_www_users.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_www_users','weberp_locations.loccode=weberp_www_users.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_accountsection','weberp_accountgroups.sectioninaccounts=weberp_accountsection.sectionid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountsection','weberp_accountgroups','weberp_accountsection.sectionid=weberp_accountgroups.sectioninaccounts');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_chartmaster','weberp_bankaccounts.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_bankaccounts','weberp_chartmaster.accountcode=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_systypes','weberp_banktrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_banktrans','weberp_systypes.typeid=weberp_banktrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_bankaccounts','weberp_banktrans.bankact=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_banktrans','weberp_bankaccounts.accountcode=weberp_banktrans.bankact');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.parent=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.parent');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_workcentres','weberp_bom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_bom','weberp_workcentres.code=weberp_bom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_locations','weberp_bom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_bom','weberp_locations.loccode=weberp_bom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_buckets','weberp_workcentres','weberp_buckets.workcentre=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_buckets','weberp_workcentres.code=weberp_buckets.workcentre');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_chartmaster','weberp_chartdetails.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_chartdetails','weberp_chartmaster.accountcode=weberp_chartdetails.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_periods','weberp_chartdetails.period=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_chartdetails','weberp_periods.periodno=weberp_chartdetails.period');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_accountgroups','weberp_chartmaster.group_=weberp_accountgroups.groupname');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_chartmaster','weberp_accountgroups.groupname=weberp_chartmaster.group_');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_workcentres','weberp_contractbom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_contractbom','weberp_workcentres.code=weberp_contractbom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_locations','weberp_contractbom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_contractbom','weberp_locations.loccode=weberp_contractbom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_stockmaster','weberp_contractbom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_contractbom','weberp_stockmaster.stockid=weberp_contractbom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractreqts','weberp_contracts','weberp_contractreqts.contract=weberp_contracts.contractref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_contractreqts','weberp_contracts.contractref=weberp_contractreqts.contract');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_custbranch','weberp_contracts.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_contracts','weberp_custbranch.debtorno=weberp_contracts.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_stockcategory','weberp_contracts.branchcode=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_contracts','weberp_stockcategory.categoryid=weberp_contracts.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_salestypes','weberp_contracts.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_contracts','weberp_salestypes.typeabbrev=weberp_contracts.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocfrom=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocto=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtorsmaster','weberp_custbranch.debtorno=weberp_debtorsmaster.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_custbranch','weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_areas','weberp_custbranch.area=weberp_areas.areacode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_areas','weberp_custbranch','weberp_areas.areacode=weberp_custbranch.area');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesman','weberp_custbranch.salesman=weberp_salesman.salesmancode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesman','weberp_custbranch','weberp_salesman.salesmancode=weberp_custbranch.salesman');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_locations','weberp_custbranch.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_custbranch','weberp_locations.loccode=weberp_custbranch.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_shippers','weberp_custbranch.defaultshipvia=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_custbranch','weberp_shippers.shipper_id=weberp_custbranch.defaultshipvia');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_holdreasons','weberp_debtorsmaster.holdreason=weberp_holdreasons.reasoncode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_holdreasons','weberp_debtorsmaster','weberp_holdreasons.reasoncode=weberp_debtorsmaster.holdreason');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_currencies','weberp_debtorsmaster.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_debtorsmaster','weberp_currencies.currabrev=weberp_debtorsmaster.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_paymentterms','weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_debtorsmaster','weberp_paymentterms.termsindicator=weberp_debtorsmaster.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_salestypes','weberp_debtorsmaster.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_debtorsmaster','weberp_salestypes.typeabbrev=weberp_debtorsmaster.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custbranch','weberp_debtortrans.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtortrans','weberp_custbranch.debtorno=weberp_debtortrans.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_systypes','weberp_debtortrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_debtortrans','weberp_systypes.typeid=weberp_debtortrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_periods','weberp_debtortrans.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_debtortrans','weberp_periods.periodno=weberp_debtortrans.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_taxauthorities','weberp_debtortranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_debtortranstaxes','weberp_taxauthorities.taxid=weberp_debtortranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_debtortrans','weberp_debtortranstaxes.debtortransid=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_debtortranstaxes','weberp_debtortrans.id=weberp_debtortranstaxes.debtortransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_discountmatrix','weberp_salestypes','weberp_discountmatrix.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_discountmatrix','weberp_salestypes.typeabbrev=weberp_discountmatrix.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_locations','weberp_freightcosts.locationfrom=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_freightcosts','weberp_locations.loccode=weberp_freightcosts.locationfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_shippers','weberp_freightcosts.shipperid=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_freightcosts','weberp_shippers.shipper_id=weberp_freightcosts.shipperid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_chartmaster','weberp_gltrans.account=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_gltrans','weberp_chartmaster.accountcode=weberp_gltrans.account');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_systypes','weberp_gltrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_gltrans','weberp_systypes.typeid=weberp_gltrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_periods','weberp_gltrans.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_gltrans','weberp_periods.periodno=weberp_gltrans.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_suppliers','weberp_grns.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_grns','weberp_suppliers.supplierid=weberp_grns.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_purchorderdetails','weberp_grns.podetailitem=weberp_purchorderdetails.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_grns','weberp_purchorderdetails.podetailitem=weberp_grns.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_taxprovinces','weberp_locations.taxprovinceid=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_locations','weberp_taxprovinces.taxprovinceid=weberp_locations.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_locations','weberp_locstock.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_locstock','weberp_locations.loccode=weberp_locstock.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_stockmaster','weberp_locstock.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_locstock','weberp_stockmaster.stockid=weberp_locstock.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.shiploc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.shiploc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.recloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.recloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_stockmaster','weberp_loctransfers.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_loctransfers','weberp_stockmaster.stockid=weberp_loctransfers.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_stockmaster','weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_orderdeliverydifferencesl','weberp_stockmaster.stockid=weberp_orderdeliverydifferenceslog.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_custbranch','weberp_orderdeliverydifferenceslog.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_orderdeliverydifferencesl','weberp_custbranch.debtorno=weberp_orderdeliverydifferenceslog.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_salesorders','weberp_orderdeliverydifferenceslog.branchcode=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_orderdeliverydifferencesl','weberp_salesorders.orderno=weberp_orderdeliverydifferenceslog.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_stockmaster','weberp_prices.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_prices','weberp_stockmaster.stockid=weberp_prices.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_currencies','weberp_prices.currabrev=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_prices','weberp_currencies.currabrev=weberp_prices.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_salestypes','weberp_prices.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_prices','weberp_salestypes.typeabbrev=weberp_prices.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_stockmaster','weberp_purchdata.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_purchdata','weberp_stockmaster.stockid=weberp_purchdata.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_suppliers','weberp_purchdata.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchdata','weberp_suppliers.supplierid=weberp_purchdata.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_purchorders','weberp_purchorderdetails.orderno=weberp_purchorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_purchorderdetails','weberp_purchorders.orderno=weberp_purchorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_suppliers','weberp_purchorders.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchorders','weberp_suppliers.supplierid=weberp_purchorders.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_locations','weberp_purchorders.intostocklocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_purchorders','weberp_locations.loccode=weberp_purchorders.intostocklocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_custbranch','weberp_recurringsalesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_recurringsalesorders','weberp_custbranch.branchcode=weberp_recurringsalesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_recurringsalesorders','weberp_recurrsalesorderdetails.recurrorderno=weberp_recurringsalesorders.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_recurrsalesorderdetails','weberp_recurringsalesorders.recurrorderno=weberp_recurrsalesorderdetails.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_stockmaster','weberp_recurrsalesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_recurrsalesorderdetails','weberp_stockmaster.stockid=weberp_recurrsalesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportcolumns','weberp_reportheaders','weberp_reportcolumns.reportid=weberp_reportheaders.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportheaders','weberp_reportcolumns','weberp_reportheaders.reportid=weberp_reportcolumns.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesanalysis','weberp_periods','weberp_salesanalysis.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_salesanalysis','weberp_periods.periodno=weberp_salesanalysis.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_stockmaster','weberp_salescatprod.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salescatprod','weberp_stockmaster.stockid=weberp_salescatprod.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_salescat','weberp_salescatprod.salescatid=weberp_salescat.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescat','weberp_salescatprod','weberp_salescat.salescatid=weberp_salescatprod.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_salesorders','weberp_salesorderdetails.orderno=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_salesorderdetails','weberp_salesorders.orderno=weberp_salesorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_stockmaster','weberp_salesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salesorderdetails','weberp_stockmaster.stockid=weberp_salesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_custbranch','weberp_salesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesorders','weberp_custbranch.branchcode=weberp_salesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_shippers','weberp_salesorders.debtorno=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_salesorders','weberp_shippers.shipper_id=weberp_salesorders.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_locations','weberp_salesorders.fromstkloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_salesorders','weberp_locations.loccode=weberp_salesorders.fromstkloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securityroles','weberp_securitygroups.secroleid=weberp_securityroles.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securityroles','weberp_securitygroups','weberp_securityroles.secroleid=weberp_securitygroups.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securitytokens','weberp_securitygroups.tokenid=weberp_securitytokens.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitytokens','weberp_securitygroups','weberp_securitytokens.tokenid=weberp_securitygroups.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_shipments','weberp_shipmentcharges.shiptref=weberp_shipments.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_shipmentcharges','weberp_shipments.shiptref=weberp_shipmentcharges.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_systypes','weberp_shipmentcharges.transtype=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_shipmentcharges','weberp_systypes.typeid=weberp_shipmentcharges.transtype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_suppliers','weberp_shipments.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_shipments','weberp_suppliers.supplierid=weberp_shipments.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_stockmaster','weberp_stockcheckfreeze.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcheckfreeze','weberp_stockmaster.stockid=weberp_stockcheckfreeze.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_locations','weberp_stockcheckfreeze.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcheckfreeze','weberp_locations.loccode=weberp_stockcheckfreeze.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_stockmaster','weberp_stockcounts.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcounts','weberp_stockmaster.stockid=weberp_stockcounts.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_locations','weberp_stockcounts.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcounts','weberp_locations.loccode=weberp_stockcounts.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcategory','weberp_stockmaster.categoryid=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_stockmaster','weberp_stockcategory.categoryid=weberp_stockmaster.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_taxcategories','weberp_stockmaster.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_stockmaster','weberp_taxcategories.taxcatid=weberp_stockmaster.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockmaster','weberp_stockmoves.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockmoves','weberp_stockmaster.stockid=weberp_stockmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_systypes','weberp_stockmoves.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_stockmoves','weberp_systypes.typeid=weberp_stockmoves.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_locations','weberp_stockmoves.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockmoves','weberp_locations.loccode=weberp_stockmoves.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_periods','weberp_stockmoves.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_stockmoves','weberp_periods.periodno=weberp_stockmoves.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmovestaxes','weberp_taxauthorities','weberp_stockmovestaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_stockmovestaxes','weberp_taxauthorities.taxid=weberp_stockmovestaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockmaster','weberp_stockserialitems.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockserialitems','weberp_stockmaster.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_locations','weberp_stockserialitems.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockserialitems','weberp_locations.loccode=weberp_stockserialitems.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockmoves','weberp_stockserialmoves.stockmoveno=weberp_stockmoves.stkmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockserialmoves','weberp_stockmoves.stkmoveno=weberp_stockserialmoves.stockmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockserialitems','weberp_stockserialmoves.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockserialmoves','weberp_stockserialitems.stockid=weberp_stockserialmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocfrom=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocto=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliercontacts','weberp_suppliers','weberp_suppliercontacts.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_suppliercontacts','weberp_suppliers.supplierid=weberp_suppliercontacts.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_currencies','weberp_suppliers.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_suppliers','weberp_currencies.currabrev=weberp_suppliers.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_paymentterms','weberp_suppliers.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_suppliers','weberp_paymentterms.termsindicator=weberp_suppliers.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_taxgroups','weberp_suppliers.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_suppliers','weberp_taxgroups.taxgroupid=weberp_suppliers.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_systypes','weberp_supptrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_supptrans','weberp_systypes.typeid=weberp_supptrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppliers','weberp_supptrans.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_supptrans','weberp_suppliers.supplierid=weberp_supptrans.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_taxauthorities','weberp_supptranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_supptranstaxes','weberp_taxauthorities.taxid=weberp_supptranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_supptrans','weberp_supptranstaxes.supptransid=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_supptranstaxes','weberp_supptrans.id=weberp_supptranstaxes.supptransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.taxglcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.taxglcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.purchtaxglaccount=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.purchtaxglaccount');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxauthorities','weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxauthrates','weberp_taxauthorities.taxid=weberp_taxauthrates.taxauthority');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxcategories','weberp_taxauthrates.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_taxauthrates','weberp_taxcategories.taxcatid=weberp_taxauthrates.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxprovinces','weberp_taxauthrates.dispatchtaxprovince=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_taxauthrates','weberp_taxprovinces.taxprovinceid=weberp_taxauthrates.dispatchtaxprovince');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxgroups','weberp_taxgrouptaxes.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_taxgrouptaxes','weberp_taxgroups.taxgroupid=weberp_taxgrouptaxes.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxauthorities','weberp_taxgrouptaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxgrouptaxes','weberp_taxauthorities.taxid=weberp_taxgrouptaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_locations','weberp_workcentres.location=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_workcentres','weberp_locations.loccode=weberp_workcentres.location');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_locations','weberp_worksorders.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_worksorders','weberp_locations.loccode=weberp_worksorders.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_stockmaster','weberp_worksorders.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_worksorders','weberp_stockmaster.stockid=weberp_worksorders.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_www_users','weberp_locations','weberp_www_users.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_www_users','weberp_locations.loccode=weberp_www_users.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_accountsection','weberp_accountgroups.sectioninaccounts=weberp_accountsection.sectionid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountsection','weberp_accountgroups','weberp_accountsection.sectionid=weberp_accountgroups.sectioninaccounts');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_chartmaster','weberp_bankaccounts.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_bankaccounts','weberp_chartmaster.accountcode=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_systypes','weberp_banktrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_banktrans','weberp_systypes.typeid=weberp_banktrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_bankaccounts','weberp_banktrans.bankact=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_banktrans','weberp_bankaccounts.accountcode=weberp_banktrans.bankact');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.parent=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.parent');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_workcentres','weberp_bom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_bom','weberp_workcentres.code=weberp_bom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_locations','weberp_bom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_bom','weberp_locations.loccode=weberp_bom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_buckets','weberp_workcentres','weberp_buckets.workcentre=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_buckets','weberp_workcentres.code=weberp_buckets.workcentre');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_chartmaster','weberp_chartdetails.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_chartdetails','weberp_chartmaster.accountcode=weberp_chartdetails.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_periods','weberp_chartdetails.period=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_chartdetails','weberp_periods.periodno=weberp_chartdetails.period');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_accountgroups','weberp_chartmaster.group_=weberp_accountgroups.groupname');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_chartmaster','weberp_accountgroups.groupname=weberp_chartmaster.group_');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_workcentres','weberp_contractbom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_contractbom','weberp_workcentres.code=weberp_contractbom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_locations','weberp_contractbom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_contractbom','weberp_locations.loccode=weberp_contractbom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_stockmaster','weberp_contractbom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_contractbom','weberp_stockmaster.stockid=weberp_contractbom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractreqts','weberp_contracts','weberp_contractreqts.contract=weberp_contracts.contractref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_contractreqts','weberp_contracts.contractref=weberp_contractreqts.contract');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_custbranch','weberp_contracts.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_contracts','weberp_custbranch.debtorno=weberp_contracts.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_stockcategory','weberp_contracts.branchcode=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_contracts','weberp_stockcategory.categoryid=weberp_contracts.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_salestypes','weberp_contracts.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_contracts','weberp_salestypes.typeabbrev=weberp_contracts.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocfrom=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocto=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtorsmaster','weberp_custbranch.debtorno=weberp_debtorsmaster.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_custbranch','weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_areas','weberp_custbranch.area=weberp_areas.areacode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_areas','weberp_custbranch','weberp_areas.areacode=weberp_custbranch.area');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesman','weberp_custbranch.salesman=weberp_salesman.salesmancode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesman','weberp_custbranch','weberp_salesman.salesmancode=weberp_custbranch.salesman');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_locations','weberp_custbranch.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_custbranch','weberp_locations.loccode=weberp_custbranch.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_shippers','weberp_custbranch.defaultshipvia=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_custbranch','weberp_shippers.shipper_id=weberp_custbranch.defaultshipvia');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_holdreasons','weberp_debtorsmaster.holdreason=weberp_holdreasons.reasoncode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_holdreasons','weberp_debtorsmaster','weberp_holdreasons.reasoncode=weberp_debtorsmaster.holdreason');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_currencies','weberp_debtorsmaster.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_debtorsmaster','weberp_currencies.currabrev=weberp_debtorsmaster.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_paymentterms','weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_debtorsmaster','weberp_paymentterms.termsindicator=weberp_debtorsmaster.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_salestypes','weberp_debtorsmaster.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_debtorsmaster','weberp_salestypes.typeabbrev=weberp_debtorsmaster.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custbranch','weberp_debtortrans.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtortrans','weberp_custbranch.debtorno=weberp_debtortrans.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_systypes','weberp_debtortrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_debtortrans','weberp_systypes.typeid=weberp_debtortrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_periods','weberp_debtortrans.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_debtortrans','weberp_periods.periodno=weberp_debtortrans.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_taxauthorities','weberp_debtortranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_debtortranstaxes','weberp_taxauthorities.taxid=weberp_debtortranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_debtortrans','weberp_debtortranstaxes.debtortransid=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_debtortranstaxes','weberp_debtortrans.id=weberp_debtortranstaxes.debtortransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_discountmatrix','weberp_salestypes','weberp_discountmatrix.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_discountmatrix','weberp_salestypes.typeabbrev=weberp_discountmatrix.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_locations','weberp_freightcosts.locationfrom=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_freightcosts','weberp_locations.loccode=weberp_freightcosts.locationfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_shippers','weberp_freightcosts.shipperid=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_freightcosts','weberp_shippers.shipper_id=weberp_freightcosts.shipperid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_chartmaster','weberp_gltrans.account=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_gltrans','weberp_chartmaster.accountcode=weberp_gltrans.account');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_systypes','weberp_gltrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_gltrans','weberp_systypes.typeid=weberp_gltrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_periods','weberp_gltrans.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_gltrans','weberp_periods.periodno=weberp_gltrans.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_suppliers','weberp_grns.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_grns','weberp_suppliers.supplierid=weberp_grns.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_purchorderdetails','weberp_grns.podetailitem=weberp_purchorderdetails.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_grns','weberp_purchorderdetails.podetailitem=weberp_grns.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_taxprovinces','weberp_locations.taxprovinceid=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_locations','weberp_taxprovinces.taxprovinceid=weberp_locations.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_locations','weberp_locstock.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_locstock','weberp_locations.loccode=weberp_locstock.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_stockmaster','weberp_locstock.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_locstock','weberp_stockmaster.stockid=weberp_locstock.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.shiploc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.shiploc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.recloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.recloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_stockmaster','weberp_loctransfers.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_loctransfers','weberp_stockmaster.stockid=weberp_loctransfers.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_stockmaster','weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_orderdeliverydifferencesl','weberp_stockmaster.stockid=weberp_orderdeliverydifferenceslog.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_custbranch','weberp_orderdeliverydifferenceslog.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_orderdeliverydifferencesl','weberp_custbranch.debtorno=weberp_orderdeliverydifferenceslog.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_salesorders','weberp_orderdeliverydifferenceslog.branchcode=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_orderdeliverydifferencesl','weberp_salesorders.orderno=weberp_orderdeliverydifferenceslog.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_stockmaster','weberp_prices.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_prices','weberp_stockmaster.stockid=weberp_prices.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_currencies','weberp_prices.currabrev=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_prices','weberp_currencies.currabrev=weberp_prices.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_salestypes','weberp_prices.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_prices','weberp_salestypes.typeabbrev=weberp_prices.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_stockmaster','weberp_purchdata.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_purchdata','weberp_stockmaster.stockid=weberp_purchdata.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_suppliers','weberp_purchdata.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchdata','weberp_suppliers.supplierid=weberp_purchdata.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_purchorders','weberp_purchorderdetails.orderno=weberp_purchorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_purchorderdetails','weberp_purchorders.orderno=weberp_purchorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_suppliers','weberp_purchorders.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchorders','weberp_suppliers.supplierid=weberp_purchorders.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_locations','weberp_purchorders.intostocklocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_purchorders','weberp_locations.loccode=weberp_purchorders.intostocklocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_custbranch','weberp_recurringsalesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_recurringsalesorders','weberp_custbranch.branchcode=weberp_recurringsalesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_recurringsalesorders','weberp_recurrsalesorderdetails.recurrorderno=weberp_recurringsalesorders.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_recurrsalesorderdetails','weberp_recurringsalesorders.recurrorderno=weberp_recurrsalesorderdetails.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_stockmaster','weberp_recurrsalesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_recurrsalesorderdetails','weberp_stockmaster.stockid=weberp_recurrsalesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportcolumns','weberp_reportheaders','weberp_reportcolumns.reportid=weberp_reportheaders.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportheaders','weberp_reportcolumns','weberp_reportheaders.reportid=weberp_reportcolumns.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesanalysis','weberp_periods','weberp_salesanalysis.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_salesanalysis','weberp_periods.periodno=weberp_salesanalysis.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_stockmaster','weberp_salescatprod.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salescatprod','weberp_stockmaster.stockid=weberp_salescatprod.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_salescat','weberp_salescatprod.salescatid=weberp_salescat.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescat','weberp_salescatprod','weberp_salescat.salescatid=weberp_salescatprod.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_salesorders','weberp_salesorderdetails.orderno=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_salesorderdetails','weberp_salesorders.orderno=weberp_salesorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_stockmaster','weberp_salesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salesorderdetails','weberp_stockmaster.stockid=weberp_salesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_custbranch','weberp_salesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesorders','weberp_custbranch.branchcode=weberp_salesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_shippers','weberp_salesorders.debtorno=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_salesorders','weberp_shippers.shipper_id=weberp_salesorders.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_locations','weberp_salesorders.fromstkloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_salesorders','weberp_locations.loccode=weberp_salesorders.fromstkloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securityroles','weberp_securitygroups.secroleid=weberp_securityroles.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securityroles','weberp_securitygroups','weberp_securityroles.secroleid=weberp_securitygroups.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securitytokens','weberp_securitygroups.tokenid=weberp_securitytokens.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitytokens','weberp_securitygroups','weberp_securitytokens.tokenid=weberp_securitygroups.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_shipments','weberp_shipmentcharges.shiptref=weberp_shipments.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_shipmentcharges','weberp_shipments.shiptref=weberp_shipmentcharges.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_systypes','weberp_shipmentcharges.transtype=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_shipmentcharges','weberp_systypes.typeid=weberp_shipmentcharges.transtype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_suppliers','weberp_shipments.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_shipments','weberp_suppliers.supplierid=weberp_shipments.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_stockmaster','weberp_stockcheckfreeze.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcheckfreeze','weberp_stockmaster.stockid=weberp_stockcheckfreeze.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_locations','weberp_stockcheckfreeze.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcheckfreeze','weberp_locations.loccode=weberp_stockcheckfreeze.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_stockmaster','weberp_stockcounts.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcounts','weberp_stockmaster.stockid=weberp_stockcounts.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_locations','weberp_stockcounts.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcounts','weberp_locations.loccode=weberp_stockcounts.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcategory','weberp_stockmaster.categoryid=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_stockmaster','weberp_stockcategory.categoryid=weberp_stockmaster.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_taxcategories','weberp_stockmaster.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_stockmaster','weberp_taxcategories.taxcatid=weberp_stockmaster.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockmaster','weberp_stockmoves.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockmoves','weberp_stockmaster.stockid=weberp_stockmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_systypes','weberp_stockmoves.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_stockmoves','weberp_systypes.typeid=weberp_stockmoves.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_locations','weberp_stockmoves.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockmoves','weberp_locations.loccode=weberp_stockmoves.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_periods','weberp_stockmoves.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_stockmoves','weberp_periods.periodno=weberp_stockmoves.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmovestaxes','weberp_taxauthorities','weberp_stockmovestaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_stockmovestaxes','weberp_taxauthorities.taxid=weberp_stockmovestaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockmaster','weberp_stockserialitems.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockserialitems','weberp_stockmaster.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_locations','weberp_stockserialitems.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockserialitems','weberp_locations.loccode=weberp_stockserialitems.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockmoves','weberp_stockserialmoves.stockmoveno=weberp_stockmoves.stkmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockserialmoves','weberp_stockmoves.stkmoveno=weberp_stockserialmoves.stockmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockserialitems','weberp_stockserialmoves.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockserialmoves','weberp_stockserialitems.stockid=weberp_stockserialmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocfrom=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocto=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliercontacts','weberp_suppliers','weberp_suppliercontacts.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_suppliercontacts','weberp_suppliers.supplierid=weberp_suppliercontacts.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_currencies','weberp_suppliers.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_suppliers','weberp_currencies.currabrev=weberp_suppliers.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_paymentterms','weberp_suppliers.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_suppliers','weberp_paymentterms.termsindicator=weberp_suppliers.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_taxgroups','weberp_suppliers.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_suppliers','weberp_taxgroups.taxgroupid=weberp_suppliers.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_systypes','weberp_supptrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_supptrans','weberp_systypes.typeid=weberp_supptrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppliers','weberp_supptrans.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_supptrans','weberp_suppliers.supplierid=weberp_supptrans.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_taxauthorities','weberp_supptranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_supptranstaxes','weberp_taxauthorities.taxid=weberp_supptranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_supptrans','weberp_supptranstaxes.supptransid=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_supptranstaxes','weberp_supptrans.id=weberp_supptranstaxes.supptransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.taxglcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.taxglcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.purchtaxglaccount=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.purchtaxglaccount');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxauthorities','weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxauthrates','weberp_taxauthorities.taxid=weberp_taxauthrates.taxauthority');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxcategories','weberp_taxauthrates.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_taxauthrates','weberp_taxcategories.taxcatid=weberp_taxauthrates.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxprovinces','weberp_taxauthrates.dispatchtaxprovince=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_taxauthrates','weberp_taxprovinces.taxprovinceid=weberp_taxauthrates.dispatchtaxprovince');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxgroups','weberp_taxgrouptaxes.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_taxgrouptaxes','weberp_taxgroups.taxgroupid=weberp_taxgrouptaxes.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxauthorities','weberp_taxgrouptaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxgrouptaxes','weberp_taxauthorities.taxid=weberp_taxgrouptaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_locations','weberp_workcentres.location=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_workcentres','weberp_locations.loccode=weberp_workcentres.location');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_locations','weberp_worksorders.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_worksorders','weberp_locations.loccode=weberp_worksorders.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_stockmaster','weberp_worksorders.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_worksorders','weberp_stockmaster.stockid=weberp_worksorders.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_www_users','weberp_locations','weberp_www_users.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_www_users','weberp_locations.loccode=weberp_www_users.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_accountsection','weberp_accountgroups.sectioninaccounts=weberp_accountsection.sectionid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountsection','weberp_accountgroups','weberp_accountsection.sectionid=weberp_accountgroups.sectioninaccounts');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_chartmaster','weberp_bankaccounts.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_bankaccounts','weberp_chartmaster.accountcode=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_systypes','weberp_banktrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_banktrans','weberp_systypes.typeid=weberp_banktrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_bankaccounts','weberp_banktrans.bankact=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_banktrans','weberp_bankaccounts.accountcode=weberp_banktrans.bankact');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.parent=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.parent');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_workcentres','weberp_bom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_bom','weberp_workcentres.code=weberp_bom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_locations','weberp_bom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_bom','weberp_locations.loccode=weberp_bom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_buckets','weberp_workcentres','weberp_buckets.workcentre=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_buckets','weberp_workcentres.code=weberp_buckets.workcentre');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_chartmaster','weberp_chartdetails.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_chartdetails','weberp_chartmaster.accountcode=weberp_chartdetails.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_periods','weberp_chartdetails.period=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_chartdetails','weberp_periods.periodno=weberp_chartdetails.period');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_accountgroups','weberp_chartmaster.group_=weberp_accountgroups.groupname');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_chartmaster','weberp_accountgroups.groupname=weberp_chartmaster.group_');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_workcentres','weberp_contractbom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_contractbom','weberp_workcentres.code=weberp_contractbom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_locations','weberp_contractbom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_contractbom','weberp_locations.loccode=weberp_contractbom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_stockmaster','weberp_contractbom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_contractbom','weberp_stockmaster.stockid=weberp_contractbom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractreqts','weberp_contracts','weberp_contractreqts.contract=weberp_contracts.contractref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_contractreqts','weberp_contracts.contractref=weberp_contractreqts.contract');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_custbranch','weberp_contracts.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_contracts','weberp_custbranch.debtorno=weberp_contracts.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_stockcategory','weberp_contracts.branchcode=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_contracts','weberp_stockcategory.categoryid=weberp_contracts.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_salestypes','weberp_contracts.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_contracts','weberp_salestypes.typeabbrev=weberp_contracts.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocfrom=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocto=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtorsmaster','weberp_custbranch.debtorno=weberp_debtorsmaster.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_custbranch','weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_areas','weberp_custbranch.area=weberp_areas.areacode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_areas','weberp_custbranch','weberp_areas.areacode=weberp_custbranch.area');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesman','weberp_custbranch.salesman=weberp_salesman.salesmancode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesman','weberp_custbranch','weberp_salesman.salesmancode=weberp_custbranch.salesman');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_locations','weberp_custbranch.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_custbranch','weberp_locations.loccode=weberp_custbranch.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_shippers','weberp_custbranch.defaultshipvia=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_custbranch','weberp_shippers.shipper_id=weberp_custbranch.defaultshipvia');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_holdreasons','weberp_debtorsmaster.holdreason=weberp_holdreasons.reasoncode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_holdreasons','weberp_debtorsmaster','weberp_holdreasons.reasoncode=weberp_debtorsmaster.holdreason');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_currencies','weberp_debtorsmaster.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_debtorsmaster','weberp_currencies.currabrev=weberp_debtorsmaster.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_paymentterms','weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_debtorsmaster','weberp_paymentterms.termsindicator=weberp_debtorsmaster.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_salestypes','weberp_debtorsmaster.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_debtorsmaster','weberp_salestypes.typeabbrev=weberp_debtorsmaster.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custbranch','weberp_debtortrans.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtortrans','weberp_custbranch.debtorno=weberp_debtortrans.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_systypes','weberp_debtortrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_debtortrans','weberp_systypes.typeid=weberp_debtortrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_periods','weberp_debtortrans.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_debtortrans','weberp_periods.periodno=weberp_debtortrans.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_taxauthorities','weberp_debtortranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_debtortranstaxes','weberp_taxauthorities.taxid=weberp_debtortranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_debtortrans','weberp_debtortranstaxes.debtortransid=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_debtortranstaxes','weberp_debtortrans.id=weberp_debtortranstaxes.debtortransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_discountmatrix','weberp_salestypes','weberp_discountmatrix.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_discountmatrix','weberp_salestypes.typeabbrev=weberp_discountmatrix.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_locations','weberp_freightcosts.locationfrom=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_freightcosts','weberp_locations.loccode=weberp_freightcosts.locationfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_shippers','weberp_freightcosts.shipperid=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_freightcosts','weberp_shippers.shipper_id=weberp_freightcosts.shipperid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_chartmaster','weberp_gltrans.account=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_gltrans','weberp_chartmaster.accountcode=weberp_gltrans.account');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_systypes','weberp_gltrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_gltrans','weberp_systypes.typeid=weberp_gltrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_periods','weberp_gltrans.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_gltrans','weberp_periods.periodno=weberp_gltrans.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_suppliers','weberp_grns.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_grns','weberp_suppliers.supplierid=weberp_grns.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_purchorderdetails','weberp_grns.podetailitem=weberp_purchorderdetails.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_grns','weberp_purchorderdetails.podetailitem=weberp_grns.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_taxprovinces','weberp_locations.taxprovinceid=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_locations','weberp_taxprovinces.taxprovinceid=weberp_locations.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_locations','weberp_locstock.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_locstock','weberp_locations.loccode=weberp_locstock.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_stockmaster','weberp_locstock.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_locstock','weberp_stockmaster.stockid=weberp_locstock.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.shiploc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.shiploc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.recloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.recloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_stockmaster','weberp_loctransfers.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_loctransfers','weberp_stockmaster.stockid=weberp_loctransfers.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_stockmaster','weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_orderdeliverydifferencesl','weberp_stockmaster.stockid=weberp_orderdeliverydifferenceslog.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_custbranch','weberp_orderdeliverydifferenceslog.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_orderdeliverydifferencesl','weberp_custbranch.debtorno=weberp_orderdeliverydifferenceslog.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_salesorders','weberp_orderdeliverydifferenceslog.branchcode=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_orderdeliverydifferencesl','weberp_salesorders.orderno=weberp_orderdeliverydifferenceslog.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_stockmaster','weberp_prices.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_prices','weberp_stockmaster.stockid=weberp_prices.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_currencies','weberp_prices.currabrev=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_prices','weberp_currencies.currabrev=weberp_prices.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_salestypes','weberp_prices.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_prices','weberp_salestypes.typeabbrev=weberp_prices.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_stockmaster','weberp_purchdata.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_purchdata','weberp_stockmaster.stockid=weberp_purchdata.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_suppliers','weberp_purchdata.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchdata','weberp_suppliers.supplierid=weberp_purchdata.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_purchorders','weberp_purchorderdetails.orderno=weberp_purchorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_purchorderdetails','weberp_purchorders.orderno=weberp_purchorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_suppliers','weberp_purchorders.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchorders','weberp_suppliers.supplierid=weberp_purchorders.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_locations','weberp_purchorders.intostocklocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_purchorders','weberp_locations.loccode=weberp_purchorders.intostocklocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_custbranch','weberp_recurringsalesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_recurringsalesorders','weberp_custbranch.branchcode=weberp_recurringsalesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_recurringsalesorders','weberp_recurrsalesorderdetails.recurrorderno=weberp_recurringsalesorders.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_recurrsalesorderdetails','weberp_recurringsalesorders.recurrorderno=weberp_recurrsalesorderdetails.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_stockmaster','weberp_recurrsalesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_recurrsalesorderdetails','weberp_stockmaster.stockid=weberp_recurrsalesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportcolumns','weberp_reportheaders','weberp_reportcolumns.reportid=weberp_reportheaders.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportheaders','weberp_reportcolumns','weberp_reportheaders.reportid=weberp_reportcolumns.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesanalysis','weberp_periods','weberp_salesanalysis.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_salesanalysis','weberp_periods.periodno=weberp_salesanalysis.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_stockmaster','weberp_salescatprod.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salescatprod','weberp_stockmaster.stockid=weberp_salescatprod.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_salescat','weberp_salescatprod.salescatid=weberp_salescat.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescat','weberp_salescatprod','weberp_salescat.salescatid=weberp_salescatprod.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_salesorders','weberp_salesorderdetails.orderno=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_salesorderdetails','weberp_salesorders.orderno=weberp_salesorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_stockmaster','weberp_salesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salesorderdetails','weberp_stockmaster.stockid=weberp_salesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_custbranch','weberp_salesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesorders','weberp_custbranch.branchcode=weberp_salesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_shippers','weberp_salesorders.debtorno=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_salesorders','weberp_shippers.shipper_id=weberp_salesorders.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_locations','weberp_salesorders.fromstkloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_salesorders','weberp_locations.loccode=weberp_salesorders.fromstkloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securityroles','weberp_securitygroups.secroleid=weberp_securityroles.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securityroles','weberp_securitygroups','weberp_securityroles.secroleid=weberp_securitygroups.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securitytokens','weberp_securitygroups.tokenid=weberp_securitytokens.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitytokens','weberp_securitygroups','weberp_securitytokens.tokenid=weberp_securitygroups.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_shipments','weberp_shipmentcharges.shiptref=weberp_shipments.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_shipmentcharges','weberp_shipments.shiptref=weberp_shipmentcharges.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_systypes','weberp_shipmentcharges.transtype=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_shipmentcharges','weberp_systypes.typeid=weberp_shipmentcharges.transtype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_suppliers','weberp_shipments.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_shipments','weberp_suppliers.supplierid=weberp_shipments.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_stockmaster','weberp_stockcheckfreeze.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcheckfreeze','weberp_stockmaster.stockid=weberp_stockcheckfreeze.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_locations','weberp_stockcheckfreeze.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcheckfreeze','weberp_locations.loccode=weberp_stockcheckfreeze.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_stockmaster','weberp_stockcounts.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcounts','weberp_stockmaster.stockid=weberp_stockcounts.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_locations','weberp_stockcounts.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcounts','weberp_locations.loccode=weberp_stockcounts.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcategory','weberp_stockmaster.categoryid=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_stockmaster','weberp_stockcategory.categoryid=weberp_stockmaster.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_taxcategories','weberp_stockmaster.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_stockmaster','weberp_taxcategories.taxcatid=weberp_stockmaster.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockmaster','weberp_stockmoves.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockmoves','weberp_stockmaster.stockid=weberp_stockmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_systypes','weberp_stockmoves.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_stockmoves','weberp_systypes.typeid=weberp_stockmoves.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_locations','weberp_stockmoves.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockmoves','weberp_locations.loccode=weberp_stockmoves.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_periods','weberp_stockmoves.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_stockmoves','weberp_periods.periodno=weberp_stockmoves.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmovestaxes','weberp_taxauthorities','weberp_stockmovestaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_stockmovestaxes','weberp_taxauthorities.taxid=weberp_stockmovestaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockmaster','weberp_stockserialitems.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockserialitems','weberp_stockmaster.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_locations','weberp_stockserialitems.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockserialitems','weberp_locations.loccode=weberp_stockserialitems.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockmoves','weberp_stockserialmoves.stockmoveno=weberp_stockmoves.stkmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockserialmoves','weberp_stockmoves.stkmoveno=weberp_stockserialmoves.stockmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockserialitems','weberp_stockserialmoves.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockserialmoves','weberp_stockserialitems.stockid=weberp_stockserialmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocfrom=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocto=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliercontacts','weberp_suppliers','weberp_suppliercontacts.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_suppliercontacts','weberp_suppliers.supplierid=weberp_suppliercontacts.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_currencies','weberp_suppliers.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_suppliers','weberp_currencies.currabrev=weberp_suppliers.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_paymentterms','weberp_suppliers.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_suppliers','weberp_paymentterms.termsindicator=weberp_suppliers.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_taxgroups','weberp_suppliers.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_suppliers','weberp_taxgroups.taxgroupid=weberp_suppliers.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_systypes','weberp_supptrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_supptrans','weberp_systypes.typeid=weberp_supptrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppliers','weberp_supptrans.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_supptrans','weberp_suppliers.supplierid=weberp_supptrans.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_taxauthorities','weberp_supptranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_supptranstaxes','weberp_taxauthorities.taxid=weberp_supptranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_supptrans','weberp_supptranstaxes.supptransid=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_supptranstaxes','weberp_supptrans.id=weberp_supptranstaxes.supptransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.taxglcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.taxglcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.purchtaxglaccount=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.purchtaxglaccount');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxauthorities','weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxauthrates','weberp_taxauthorities.taxid=weberp_taxauthrates.taxauthority');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxcategories','weberp_taxauthrates.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_taxauthrates','weberp_taxcategories.taxcatid=weberp_taxauthrates.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxprovinces','weberp_taxauthrates.dispatchtaxprovince=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_taxauthrates','weberp_taxprovinces.taxprovinceid=weberp_taxauthrates.dispatchtaxprovince');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxgroups','weberp_taxgrouptaxes.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_taxgrouptaxes','weberp_taxgroups.taxgroupid=weberp_taxgrouptaxes.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxauthorities','weberp_taxgrouptaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxgrouptaxes','weberp_taxauthorities.taxid=weberp_taxgrouptaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_locations','weberp_workcentres.location=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_workcentres','weberp_locations.loccode=weberp_workcentres.location');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_locations','weberp_worksorders.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_worksorders','weberp_locations.loccode=weberp_worksorders.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_stockmaster','weberp_worksorders.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_worksorders','weberp_stockmaster.stockid=weberp_worksorders.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_www_users','weberp_locations','weberp_www_users.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_www_users','weberp_locations.loccode=weberp_www_users.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_accountsection','weberp_accountgroups.sectioninaccounts=weberp_accountsection.sectionid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountsection','weberp_accountgroups','weberp_accountsection.sectionid=weberp_accountgroups.sectioninaccounts');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_chartmaster','weberp_bankaccounts.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_bankaccounts','weberp_chartmaster.accountcode=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_systypes','weberp_banktrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_banktrans','weberp_systypes.typeid=weberp_banktrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_bankaccounts','weberp_banktrans.bankact=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_banktrans','weberp_bankaccounts.accountcode=weberp_banktrans.bankact');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.parent=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.parent');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_workcentres','weberp_bom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_bom','weberp_workcentres.code=weberp_bom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_locations','weberp_bom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_bom','weberp_locations.loccode=weberp_bom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_buckets','weberp_workcentres','weberp_buckets.workcentre=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_buckets','weberp_workcentres.code=weberp_buckets.workcentre');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_chartmaster','weberp_chartdetails.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_chartdetails','weberp_chartmaster.accountcode=weberp_chartdetails.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_periods','weberp_chartdetails.period=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_chartdetails','weberp_periods.periodno=weberp_chartdetails.period');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_accountgroups','weberp_chartmaster.group_=weberp_accountgroups.groupname');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_chartmaster','weberp_accountgroups.groupname=weberp_chartmaster.group_');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_workcentres','weberp_contractbom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_contractbom','weberp_workcentres.code=weberp_contractbom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_locations','weberp_contractbom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_contractbom','weberp_locations.loccode=weberp_contractbom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_stockmaster','weberp_contractbom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_contractbom','weberp_stockmaster.stockid=weberp_contractbom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractreqts','weberp_contracts','weberp_contractreqts.contract=weberp_contracts.contractref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_contractreqts','weberp_contracts.contractref=weberp_contractreqts.contract');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_custbranch','weberp_contracts.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_contracts','weberp_custbranch.debtorno=weberp_contracts.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_stockcategory','weberp_contracts.branchcode=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_contracts','weberp_stockcategory.categoryid=weberp_contracts.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_salestypes','weberp_contracts.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_contracts','weberp_salestypes.typeabbrev=weberp_contracts.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocfrom=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocto=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtorsmaster','weberp_custbranch.debtorno=weberp_debtorsmaster.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_custbranch','weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_areas','weberp_custbranch.area=weberp_areas.areacode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_areas','weberp_custbranch','weberp_areas.areacode=weberp_custbranch.area');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesman','weberp_custbranch.salesman=weberp_salesman.salesmancode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesman','weberp_custbranch','weberp_salesman.salesmancode=weberp_custbranch.salesman');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_locations','weberp_custbranch.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_custbranch','weberp_locations.loccode=weberp_custbranch.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_shippers','weberp_custbranch.defaultshipvia=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_custbranch','weberp_shippers.shipper_id=weberp_custbranch.defaultshipvia');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_holdreasons','weberp_debtorsmaster.holdreason=weberp_holdreasons.reasoncode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_holdreasons','weberp_debtorsmaster','weberp_holdreasons.reasoncode=weberp_debtorsmaster.holdreason');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_currencies','weberp_debtorsmaster.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_debtorsmaster','weberp_currencies.currabrev=weberp_debtorsmaster.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_paymentterms','weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_debtorsmaster','weberp_paymentterms.termsindicator=weberp_debtorsmaster.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_salestypes','weberp_debtorsmaster.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_debtorsmaster','weberp_salestypes.typeabbrev=weberp_debtorsmaster.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custbranch','weberp_debtortrans.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtortrans','weberp_custbranch.debtorno=weberp_debtortrans.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_systypes','weberp_debtortrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_debtortrans','weberp_systypes.typeid=weberp_debtortrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_periods','weberp_debtortrans.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_debtortrans','weberp_periods.periodno=weberp_debtortrans.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_taxauthorities','weberp_debtortranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_debtortranstaxes','weberp_taxauthorities.taxid=weberp_debtortranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_debtortrans','weberp_debtortranstaxes.debtortransid=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_debtortranstaxes','weberp_debtortrans.id=weberp_debtortranstaxes.debtortransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_discountmatrix','weberp_salestypes','weberp_discountmatrix.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_discountmatrix','weberp_salestypes.typeabbrev=weberp_discountmatrix.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_locations','weberp_freightcosts.locationfrom=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_freightcosts','weberp_locations.loccode=weberp_freightcosts.locationfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_shippers','weberp_freightcosts.shipperid=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_freightcosts','weberp_shippers.shipper_id=weberp_freightcosts.shipperid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_chartmaster','weberp_gltrans.account=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_gltrans','weberp_chartmaster.accountcode=weberp_gltrans.account');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_systypes','weberp_gltrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_gltrans','weberp_systypes.typeid=weberp_gltrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_periods','weberp_gltrans.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_gltrans','weberp_periods.periodno=weberp_gltrans.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_suppliers','weberp_grns.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_grns','weberp_suppliers.supplierid=weberp_grns.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_purchorderdetails','weberp_grns.podetailitem=weberp_purchorderdetails.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_grns','weberp_purchorderdetails.podetailitem=weberp_grns.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_taxprovinces','weberp_locations.taxprovinceid=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_locations','weberp_taxprovinces.taxprovinceid=weberp_locations.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_locations','weberp_locstock.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_locstock','weberp_locations.loccode=weberp_locstock.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_stockmaster','weberp_locstock.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_locstock','weberp_stockmaster.stockid=weberp_locstock.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.shiploc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.shiploc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.recloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.recloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_stockmaster','weberp_loctransfers.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_loctransfers','weberp_stockmaster.stockid=weberp_loctransfers.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_stockmaster','weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_orderdeliverydifferencesl','weberp_stockmaster.stockid=weberp_orderdeliverydifferenceslog.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_custbranch','weberp_orderdeliverydifferenceslog.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_orderdeliverydifferencesl','weberp_custbranch.debtorno=weberp_orderdeliverydifferenceslog.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_salesorders','weberp_orderdeliverydifferenceslog.branchcode=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_orderdeliverydifferencesl','weberp_salesorders.orderno=weberp_orderdeliverydifferenceslog.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_stockmaster','weberp_prices.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_prices','weberp_stockmaster.stockid=weberp_prices.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_currencies','weberp_prices.currabrev=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_prices','weberp_currencies.currabrev=weberp_prices.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_salestypes','weberp_prices.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_prices','weberp_salestypes.typeabbrev=weberp_prices.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_stockmaster','weberp_purchdata.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_purchdata','weberp_stockmaster.stockid=weberp_purchdata.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_suppliers','weberp_purchdata.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchdata','weberp_suppliers.supplierid=weberp_purchdata.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_purchorders','weberp_purchorderdetails.orderno=weberp_purchorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_purchorderdetails','weberp_purchorders.orderno=weberp_purchorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_suppliers','weberp_purchorders.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchorders','weberp_suppliers.supplierid=weberp_purchorders.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_locations','weberp_purchorders.intostocklocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_purchorders','weberp_locations.loccode=weberp_purchorders.intostocklocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_custbranch','weberp_recurringsalesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_recurringsalesorders','weberp_custbranch.branchcode=weberp_recurringsalesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_recurringsalesorders','weberp_recurrsalesorderdetails.recurrorderno=weberp_recurringsalesorders.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_recurrsalesorderdetails','weberp_recurringsalesorders.recurrorderno=weberp_recurrsalesorderdetails.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_stockmaster','weberp_recurrsalesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_recurrsalesorderdetails','weberp_stockmaster.stockid=weberp_recurrsalesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportcolumns','weberp_reportheaders','weberp_reportcolumns.reportid=weberp_reportheaders.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportheaders','weberp_reportcolumns','weberp_reportheaders.reportid=weberp_reportcolumns.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesanalysis','weberp_periods','weberp_salesanalysis.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_salesanalysis','weberp_periods.periodno=weberp_salesanalysis.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_stockmaster','weberp_salescatprod.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salescatprod','weberp_stockmaster.stockid=weberp_salescatprod.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_salescat','weberp_salescatprod.salescatid=weberp_salescat.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescat','weberp_salescatprod','weberp_salescat.salescatid=weberp_salescatprod.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_salesorders','weberp_salesorderdetails.orderno=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_salesorderdetails','weberp_salesorders.orderno=weberp_salesorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_stockmaster','weberp_salesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salesorderdetails','weberp_stockmaster.stockid=weberp_salesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_custbranch','weberp_salesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesorders','weberp_custbranch.branchcode=weberp_salesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_shippers','weberp_salesorders.debtorno=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_salesorders','weberp_shippers.shipper_id=weberp_salesorders.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_locations','weberp_salesorders.fromstkloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_salesorders','weberp_locations.loccode=weberp_salesorders.fromstkloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securityroles','weberp_securitygroups.secroleid=weberp_securityroles.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securityroles','weberp_securitygroups','weberp_securityroles.secroleid=weberp_securitygroups.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securitytokens','weberp_securitygroups.tokenid=weberp_securitytokens.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitytokens','weberp_securitygroups','weberp_securitytokens.tokenid=weberp_securitygroups.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_shipments','weberp_shipmentcharges.shiptref=weberp_shipments.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_shipmentcharges','weberp_shipments.shiptref=weberp_shipmentcharges.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_systypes','weberp_shipmentcharges.transtype=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_shipmentcharges','weberp_systypes.typeid=weberp_shipmentcharges.transtype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_suppliers','weberp_shipments.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_shipments','weberp_suppliers.supplierid=weberp_shipments.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_stockmaster','weberp_stockcheckfreeze.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcheckfreeze','weberp_stockmaster.stockid=weberp_stockcheckfreeze.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_locations','weberp_stockcheckfreeze.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcheckfreeze','weberp_locations.loccode=weberp_stockcheckfreeze.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_stockmaster','weberp_stockcounts.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcounts','weberp_stockmaster.stockid=weberp_stockcounts.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_locations','weberp_stockcounts.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcounts','weberp_locations.loccode=weberp_stockcounts.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcategory','weberp_stockmaster.categoryid=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_stockmaster','weberp_stockcategory.categoryid=weberp_stockmaster.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_taxcategories','weberp_stockmaster.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_stockmaster','weberp_taxcategories.taxcatid=weberp_stockmaster.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockmaster','weberp_stockmoves.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockmoves','weberp_stockmaster.stockid=weberp_stockmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_systypes','weberp_stockmoves.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_stockmoves','weberp_systypes.typeid=weberp_stockmoves.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_locations','weberp_stockmoves.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockmoves','weberp_locations.loccode=weberp_stockmoves.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_periods','weberp_stockmoves.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_stockmoves','weberp_periods.periodno=weberp_stockmoves.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmovestaxes','weberp_taxauthorities','weberp_stockmovestaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_stockmovestaxes','weberp_taxauthorities.taxid=weberp_stockmovestaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockmaster','weberp_stockserialitems.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockserialitems','weberp_stockmaster.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_locations','weberp_stockserialitems.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockserialitems','weberp_locations.loccode=weberp_stockserialitems.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockmoves','weberp_stockserialmoves.stockmoveno=weberp_stockmoves.stkmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockserialmoves','weberp_stockmoves.stkmoveno=weberp_stockserialmoves.stockmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockserialitems','weberp_stockserialmoves.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockserialmoves','weberp_stockserialitems.stockid=weberp_stockserialmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocfrom=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocto=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliercontacts','weberp_suppliers','weberp_suppliercontacts.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_suppliercontacts','weberp_suppliers.supplierid=weberp_suppliercontacts.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_currencies','weberp_suppliers.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_suppliers','weberp_currencies.currabrev=weberp_suppliers.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_paymentterms','weberp_suppliers.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_suppliers','weberp_paymentterms.termsindicator=weberp_suppliers.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_taxgroups','weberp_suppliers.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_suppliers','weberp_taxgroups.taxgroupid=weberp_suppliers.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_systypes','weberp_supptrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_supptrans','weberp_systypes.typeid=weberp_supptrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppliers','weberp_supptrans.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_supptrans','weberp_suppliers.supplierid=weberp_supptrans.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_taxauthorities','weberp_supptranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_supptranstaxes','weberp_taxauthorities.taxid=weberp_supptranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_supptrans','weberp_supptranstaxes.supptransid=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_supptranstaxes','weberp_supptrans.id=weberp_supptranstaxes.supptransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.taxglcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.taxglcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.purchtaxglaccount=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.purchtaxglaccount');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxauthorities','weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxauthrates','weberp_taxauthorities.taxid=weberp_taxauthrates.taxauthority');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxcategories','weberp_taxauthrates.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_taxauthrates','weberp_taxcategories.taxcatid=weberp_taxauthrates.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxprovinces','weberp_taxauthrates.dispatchtaxprovince=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_taxauthrates','weberp_taxprovinces.taxprovinceid=weberp_taxauthrates.dispatchtaxprovince');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxgroups','weberp_taxgrouptaxes.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_taxgrouptaxes','weberp_taxgroups.taxgroupid=weberp_taxgrouptaxes.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxauthorities','weberp_taxgrouptaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxgrouptaxes','weberp_taxauthorities.taxid=weberp_taxgrouptaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_locations','weberp_workcentres.location=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_workcentres','weberp_locations.loccode=weberp_workcentres.location');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_locations','weberp_worksorders.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_worksorders','weberp_locations.loccode=weberp_worksorders.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_stockmaster','weberp_worksorders.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_worksorders','weberp_stockmaster.stockid=weberp_worksorders.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_www_users','weberp_locations','weberp_www_users.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_www_users','weberp_locations.loccode=weberp_www_users.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_accountsection','weberp_accountgroups.sectioninaccounts=weberp_accountsection.sectionid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountsection','weberp_accountgroups','weberp_accountsection.sectionid=weberp_accountgroups.sectioninaccounts');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_chartmaster','weberp_bankaccounts.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_bankaccounts','weberp_chartmaster.accountcode=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_systypes','weberp_banktrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_banktrans','weberp_systypes.typeid=weberp_banktrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_banktrans','weberp_bankaccounts','weberp_banktrans.bankact=weberp_bankaccounts.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bankaccounts','weberp_banktrans','weberp_bankaccounts.accountcode=weberp_banktrans.bankact');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.parent=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.parent');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_stockmaster','weberp_bom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_bom','weberp_stockmaster.stockid=weberp_bom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_workcentres','weberp_bom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_bom','weberp_workcentres.code=weberp_bom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_bom','weberp_locations','weberp_bom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_bom','weberp_locations.loccode=weberp_bom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_buckets','weberp_workcentres','weberp_buckets.workcentre=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_buckets','weberp_workcentres.code=weberp_buckets.workcentre');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_chartmaster','weberp_chartdetails.accountcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_chartdetails','weberp_chartmaster.accountcode=weberp_chartdetails.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartdetails','weberp_periods','weberp_chartdetails.period=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_chartdetails','weberp_periods.periodno=weberp_chartdetails.period');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_accountgroups','weberp_chartmaster.group_=weberp_accountgroups.groupname');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_accountgroups','weberp_chartmaster','weberp_accountgroups.groupname=weberp_chartmaster.group_');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_workcentres','weberp_contractbom.workcentreadded=weberp_workcentres.code');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_contractbom','weberp_workcentres.code=weberp_contractbom.workcentreadded');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_locations','weberp_contractbom.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_contractbom','weberp_locations.loccode=weberp_contractbom.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractbom','weberp_stockmaster','weberp_contractbom.component=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_contractbom','weberp_stockmaster.stockid=weberp_contractbom.component');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contractreqts','weberp_contracts','weberp_contractreqts.contract=weberp_contracts.contractref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_contractreqts','weberp_contracts.contractref=weberp_contractreqts.contract');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_custbranch','weberp_contracts.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_contracts','weberp_custbranch.debtorno=weberp_contracts.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_stockcategory','weberp_contracts.branchcode=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_contracts','weberp_stockcategory.categoryid=weberp_contracts.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_contracts','weberp_salestypes','weberp_contracts.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_contracts','weberp_salestypes.typeabbrev=weberp_contracts.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocfrom=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custallocns','weberp_debtortrans','weberp_custallocns.transid_allocto=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custallocns','weberp_debtortrans.id=weberp_custallocns.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtorsmaster','weberp_custbranch.debtorno=weberp_debtorsmaster.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_custbranch','weberp_debtorsmaster.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_areas','weberp_custbranch.area=weberp_areas.areacode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_areas','weberp_custbranch','weberp_areas.areacode=weberp_custbranch.area');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesman','weberp_custbranch.salesman=weberp_salesman.salesmancode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesman','weberp_custbranch','weberp_salesman.salesmancode=weberp_custbranch.salesman');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_locations','weberp_custbranch.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_custbranch','weberp_locations.loccode=weberp_custbranch.defaultlocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_shippers','weberp_custbranch.defaultshipvia=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_custbranch','weberp_shippers.shipper_id=weberp_custbranch.defaultshipvia');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_holdreasons','weberp_debtorsmaster.holdreason=weberp_holdreasons.reasoncode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_holdreasons','weberp_debtorsmaster','weberp_holdreasons.reasoncode=weberp_debtorsmaster.holdreason');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_currencies','weberp_debtorsmaster.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_debtorsmaster','weberp_currencies.currabrev=weberp_debtorsmaster.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_paymentterms','weberp_debtorsmaster.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_debtorsmaster','weberp_paymentterms.termsindicator=weberp_debtorsmaster.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtorsmaster','weberp_salestypes','weberp_debtorsmaster.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_debtorsmaster','weberp_salestypes.typeabbrev=weberp_debtorsmaster.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_custbranch','weberp_debtortrans.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_debtortrans','weberp_custbranch.debtorno=weberp_debtortrans.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_systypes','weberp_debtortrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_debtortrans','weberp_systypes.typeid=weberp_debtortrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_periods','weberp_debtortrans.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_debtortrans','weberp_periods.periodno=weberp_debtortrans.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_taxauthorities','weberp_debtortranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_debtortranstaxes','weberp_taxauthorities.taxid=weberp_debtortranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortranstaxes','weberp_debtortrans','weberp_debtortranstaxes.debtortransid=weberp_debtortrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_debtortrans','weberp_debtortranstaxes','weberp_debtortrans.id=weberp_debtortranstaxes.debtortransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_discountmatrix','weberp_salestypes','weberp_discountmatrix.salestype=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_discountmatrix','weberp_salestypes.typeabbrev=weberp_discountmatrix.salestype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_locations','weberp_freightcosts.locationfrom=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_freightcosts','weberp_locations.loccode=weberp_freightcosts.locationfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_freightcosts','weberp_shippers','weberp_freightcosts.shipperid=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_freightcosts','weberp_shippers.shipper_id=weberp_freightcosts.shipperid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_chartmaster','weberp_gltrans.account=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_gltrans','weberp_chartmaster.accountcode=weberp_gltrans.account');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_systypes','weberp_gltrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_gltrans','weberp_systypes.typeid=weberp_gltrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_gltrans','weberp_periods','weberp_gltrans.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_gltrans','weberp_periods.periodno=weberp_gltrans.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_suppliers','weberp_grns.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_grns','weberp_suppliers.supplierid=weberp_grns.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_grns','weberp_purchorderdetails','weberp_grns.podetailitem=weberp_purchorderdetails.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_grns','weberp_purchorderdetails.podetailitem=weberp_grns.podetailitem');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_taxprovinces','weberp_locations.taxprovinceid=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_locations','weberp_taxprovinces.taxprovinceid=weberp_locations.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_locations','weberp_locstock.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_locstock','weberp_locations.loccode=weberp_locstock.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locstock','weberp_stockmaster','weberp_locstock.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_locstock','weberp_stockmaster.stockid=weberp_locstock.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.shiploc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.shiploc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_locations','weberp_loctransfers.recloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_loctransfers','weberp_locations.loccode=weberp_loctransfers.recloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_loctransfers','weberp_stockmaster','weberp_loctransfers.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_loctransfers','weberp_stockmaster.stockid=weberp_loctransfers.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_stockmaster','weberp_orderdeliverydifferenceslog.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_orderdeliverydifferencesl','weberp_stockmaster.stockid=weberp_orderdeliverydifferenceslog.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_custbranch','weberp_orderdeliverydifferenceslog.debtorno=weberp_custbranch.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_orderdeliverydifferencesl','weberp_custbranch.debtorno=weberp_orderdeliverydifferenceslog.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_orderdeliverydifferencesl','weberp_salesorders','weberp_orderdeliverydifferenceslog.branchcode=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_orderdeliverydifferencesl','weberp_salesorders.orderno=weberp_orderdeliverydifferenceslog.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_stockmaster','weberp_prices.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_prices','weberp_stockmaster.stockid=weberp_prices.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_currencies','weberp_prices.currabrev=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_prices','weberp_currencies.currabrev=weberp_prices.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_prices','weberp_salestypes','weberp_prices.typeabbrev=weberp_salestypes.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salestypes','weberp_prices','weberp_salestypes.typeabbrev=weberp_prices.typeabbrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_stockmaster','weberp_purchdata.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_purchdata','weberp_stockmaster.stockid=weberp_purchdata.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchdata','weberp_suppliers','weberp_purchdata.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchdata','weberp_suppliers.supplierid=weberp_purchdata.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorderdetails','weberp_purchorders','weberp_purchorderdetails.orderno=weberp_purchorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_purchorderdetails','weberp_purchorders.orderno=weberp_purchorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_suppliers','weberp_purchorders.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_purchorders','weberp_suppliers.supplierid=weberp_purchorders.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_purchorders','weberp_locations','weberp_purchorders.intostocklocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_purchorders','weberp_locations.loccode=weberp_purchorders.intostocklocation');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_custbranch','weberp_recurringsalesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_recurringsalesorders','weberp_custbranch.branchcode=weberp_recurringsalesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_recurringsalesorders','weberp_recurrsalesorderdetails.recurrorderno=weberp_recurringsalesorders.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurringsalesorders','weberp_recurrsalesorderdetails','weberp_recurringsalesorders.recurrorderno=weberp_recurrsalesorderdetails.recurrorderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_recurrsalesorderdetails','weberp_stockmaster','weberp_recurrsalesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_recurrsalesorderdetails','weberp_stockmaster.stockid=weberp_recurrsalesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportcolumns','weberp_reportheaders','weberp_reportcolumns.reportid=weberp_reportheaders.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_reportheaders','weberp_reportcolumns','weberp_reportheaders.reportid=weberp_reportcolumns.reportid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesanalysis','weberp_periods','weberp_salesanalysis.periodno=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_salesanalysis','weberp_periods.periodno=weberp_salesanalysis.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_stockmaster','weberp_salescatprod.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salescatprod','weberp_stockmaster.stockid=weberp_salescatprod.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescatprod','weberp_salescat','weberp_salescatprod.salescatid=weberp_salescat.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salescat','weberp_salescatprod','weberp_salescat.salescatid=weberp_salescatprod.salescatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_salesorders','weberp_salesorderdetails.orderno=weberp_salesorders.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_salesorderdetails','weberp_salesorders.orderno=weberp_salesorderdetails.orderno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorderdetails','weberp_stockmaster','weberp_salesorderdetails.stkcode=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_salesorderdetails','weberp_stockmaster.stockid=weberp_salesorderdetails.stkcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_custbranch','weberp_salesorders.branchcode=weberp_custbranch.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_custbranch','weberp_salesorders','weberp_custbranch.branchcode=weberp_salesorders.branchcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_shippers','weberp_salesorders.debtorno=weberp_shippers.shipper_id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shippers','weberp_salesorders','weberp_shippers.shipper_id=weberp_salesorders.debtorno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_salesorders','weberp_locations','weberp_salesorders.fromstkloc=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_salesorders','weberp_locations.loccode=weberp_salesorders.fromstkloc');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securityroles','weberp_securitygroups.secroleid=weberp_securityroles.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securityroles','weberp_securitygroups','weberp_securityroles.secroleid=weberp_securitygroups.secroleid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitygroups','weberp_securitytokens','weberp_securitygroups.tokenid=weberp_securitytokens.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_securitytokens','weberp_securitygroups','weberp_securitytokens.tokenid=weberp_securitygroups.tokenid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_shipments','weberp_shipmentcharges.shiptref=weberp_shipments.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_shipmentcharges','weberp_shipments.shiptref=weberp_shipmentcharges.shiptref');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipmentcharges','weberp_systypes','weberp_shipmentcharges.transtype=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_shipmentcharges','weberp_systypes.typeid=weberp_shipmentcharges.transtype');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_shipments','weberp_suppliers','weberp_shipments.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_shipments','weberp_suppliers.supplierid=weberp_shipments.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_stockmaster','weberp_stockcheckfreeze.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcheckfreeze','weberp_stockmaster.stockid=weberp_stockcheckfreeze.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcheckfreeze','weberp_locations','weberp_stockcheckfreeze.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcheckfreeze','weberp_locations.loccode=weberp_stockcheckfreeze.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_stockmaster','weberp_stockcounts.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcounts','weberp_stockmaster.stockid=weberp_stockcounts.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcounts','weberp_locations','weberp_stockcounts.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockcounts','weberp_locations.loccode=weberp_stockcounts.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockcategory','weberp_stockmaster.categoryid=weberp_stockcategory.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockcategory','weberp_stockmaster','weberp_stockcategory.categoryid=weberp_stockmaster.categoryid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_taxcategories','weberp_stockmaster.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_stockmaster','weberp_taxcategories.taxcatid=weberp_stockmaster.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockmaster','weberp_stockmoves.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockmoves','weberp_stockmaster.stockid=weberp_stockmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_systypes','weberp_stockmoves.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_stockmoves','weberp_systypes.typeid=weberp_stockmoves.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_locations','weberp_stockmoves.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockmoves','weberp_locations.loccode=weberp_stockmoves.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_periods','weberp_stockmoves.prd=weberp_periods.periodno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_periods','weberp_stockmoves','weberp_periods.periodno=weberp_stockmoves.prd');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmovestaxes','weberp_taxauthorities','weberp_stockmovestaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_stockmovestaxes','weberp_taxauthorities.taxid=weberp_stockmovestaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockmaster','weberp_stockserialitems.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_stockserialitems','weberp_stockmaster.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_locations','weberp_stockserialitems.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_stockserialitems','weberp_locations.loccode=weberp_stockserialitems.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockmoves','weberp_stockserialmoves.stockmoveno=weberp_stockmoves.stkmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmoves','weberp_stockserialmoves','weberp_stockmoves.stkmoveno=weberp_stockserialmoves.stockmoveno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialmoves','weberp_stockserialitems','weberp_stockserialmoves.stockid=weberp_stockserialitems.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockserialitems','weberp_stockserialmoves','weberp_stockserialitems.stockid=weberp_stockserialmoves.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocfrom=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocfrom');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppallocs','weberp_supptrans','weberp_suppallocs.transid_allocto=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppallocs','weberp_supptrans.id=weberp_suppallocs.transid_allocto');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliercontacts','weberp_suppliers','weberp_suppliercontacts.supplierid=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_suppliercontacts','weberp_suppliers.supplierid=weberp_suppliercontacts.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_currencies','weberp_suppliers.currcode=weberp_currencies.currabrev');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_currencies','weberp_suppliers','weberp_currencies.currabrev=weberp_suppliers.currcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_paymentterms','weberp_suppliers.paymentterms=weberp_paymentterms.termsindicator');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_paymentterms','weberp_suppliers','weberp_paymentterms.termsindicator=weberp_suppliers.paymentterms');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_taxgroups','weberp_suppliers.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_suppliers','weberp_taxgroups.taxgroupid=weberp_suppliers.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_systypes','weberp_supptrans.type=weberp_systypes.typeid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_systypes','weberp_supptrans','weberp_systypes.typeid=weberp_supptrans.type');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_suppliers','weberp_supptrans.supplierno=weberp_suppliers.supplierid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_suppliers','weberp_supptrans','weberp_suppliers.supplierid=weberp_supptrans.supplierno');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_taxauthorities','weberp_supptranstaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_supptranstaxes','weberp_taxauthorities.taxid=weberp_supptranstaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptranstaxes','weberp_supptrans','weberp_supptranstaxes.supptransid=weberp_supptrans.id');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_supptrans','weberp_supptranstaxes','weberp_supptrans.id=weberp_supptranstaxes.supptransid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.taxglcode=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.taxglcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_chartmaster','weberp_taxauthorities.purchtaxglaccount=weberp_chartmaster.accountcode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_chartmaster','weberp_taxauthorities','weberp_chartmaster.accountcode=weberp_taxauthorities.purchtaxglaccount');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxauthorities','weberp_taxauthrates.taxauthority=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxauthrates','weberp_taxauthorities.taxid=weberp_taxauthrates.taxauthority');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxcategories','weberp_taxauthrates.taxcatid=weberp_taxcategories.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxcategories','weberp_taxauthrates','weberp_taxcategories.taxcatid=weberp_taxauthrates.taxcatid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthrates','weberp_taxprovinces','weberp_taxauthrates.dispatchtaxprovince=weberp_taxprovinces.taxprovinceid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxprovinces','weberp_taxauthrates','weberp_taxprovinces.taxprovinceid=weberp_taxauthrates.dispatchtaxprovince');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxgroups','weberp_taxgrouptaxes.taxgroupid=weberp_taxgroups.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgroups','weberp_taxgrouptaxes','weberp_taxgroups.taxgroupid=weberp_taxgrouptaxes.taxgroupid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxgrouptaxes','weberp_taxauthorities','weberp_taxgrouptaxes.taxauthid=weberp_taxauthorities.taxid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_taxauthorities','weberp_taxgrouptaxes','weberp_taxauthorities.taxid=weberp_taxgrouptaxes.taxauthid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_workcentres','weberp_locations','weberp_workcentres.location=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_workcentres','weberp_locations.loccode=weberp_workcentres.location');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_locations','weberp_worksorders.loccode=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_worksorders','weberp_locations.loccode=weberp_worksorders.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_worksorders','weberp_stockmaster','weberp_worksorders.stockid=weberp_stockmaster.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_stockmaster','weberp_worksorders','weberp_stockmaster.stockid=weberp_worksorders.stockid');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_www_users','weberp_locations','weberp_www_users.defaultlocation=weberp_locations.loccode');
INSERT INTO `weberp_reportlinks` VALUES ('weberp_locations','weberp_www_users','weberp_locations.loccode=weberp_www_users.defaultlocation');

--
-- Dumping data for table `salesglpostings`
--

INSERT INTO `weberp_salesglpostings` VALUES (1,'AN','ANY','4900','4100','AN');
INSERT INTO `weberp_salesglpostings` VALUES (2,'AN','AIRCON','5000','4800','DE');
INSERT INTO `weberp_salesglpostings` VALUES (3,'AN','ZPAYT','7230','7230','AN');

--
-- Dumping data for table `systypes`
--

INSERT INTO `weberp_systypes` VALUES (0,'Journal - GL',8);
INSERT INTO `weberp_systypes` VALUES (1,'Payment - GL',7);
INSERT INTO `weberp_systypes` VALUES (2,'Receipt - GL',1);
INSERT INTO `weberp_systypes` VALUES (3,'Standing Journal',0);
INSERT INTO `weberp_systypes` VALUES (10,'Sales Invoice',2);
INSERT INTO `weberp_systypes` VALUES (11,'Credit Note',0);
INSERT INTO `weberp_systypes` VALUES (12,'Receipt',4);
INSERT INTO `weberp_systypes` VALUES (15,'Journal - Debtors',0);
INSERT INTO `weberp_systypes` VALUES (16,'Location Transfer',27);
INSERT INTO `weberp_systypes` VALUES (17,'Stock Adjustment',28);
INSERT INTO `weberp_systypes` VALUES (18,'Purchase Order',35);
INSERT INTO `weberp_systypes` VALUES (19,'Picking List',0);
INSERT INTO `weberp_systypes` VALUES (20,'Purchase Invoice',45);
INSERT INTO `weberp_systypes` VALUES (21,'Debit Note',8);
INSERT INTO `weberp_systypes` VALUES (22,'Creditors Payment',11);
INSERT INTO `weberp_systypes` VALUES (23,'Creditors Journal',0);
INSERT INTO `weberp_systypes` VALUES (25,'Purchase Order Delivery',59);
INSERT INTO `weberp_systypes` VALUES (26,'Work Order Receipt',8);
INSERT INTO `weberp_systypes` VALUES (28,'Work Order Issue',17);
INSERT INTO `weberp_systypes` VALUES (29,'Work Order Variance',1);
INSERT INTO `weberp_systypes` VALUES (30,'Sales Order',10);
INSERT INTO `weberp_systypes` VALUES (31,'Shipment Close',28);
INSERT INTO `weberp_systypes` VALUES (32,'Contract Close',6);
INSERT INTO `weberp_systypes` VALUES (35,'Cost Update',26);
INSERT INTO `weberp_systypes` VALUES (36,'Exchange Difference',1);
INSERT INTO `weberp_systypes` VALUES (37,'Tenders',0);
INSERT INTO `weberp_systypes` VALUES (38,'Stock Requests',2);
INSERT INTO `weberp_systypes` VALUES (40,'Work Order',36);
INSERT INTO `weberp_systypes` VALUES (41,'Asset Addition',1);
INSERT INTO `weberp_systypes` VALUES (42,'Asset Category Change',1);
INSERT INTO `weberp_systypes` VALUES (43,'Delete w/down asset',1);
INSERT INTO `weberp_systypes` VALUES (44,'Depreciation',1);
INSERT INTO `weberp_systypes` VALUES (49,'Import Fixed Assets',1);
INSERT INTO `weberp_systypes` VALUES (50,'Opening Balance',0);
INSERT INTO `weberp_systypes` VALUES (500,'Auto Debtor Number',19);
INSERT INTO `weberp_systypes` VALUES (600,'Auto Supplier Number',0);

--
-- Dumping data for table `taxauthorities`
--

INSERT INTO `weberp_taxauthorities` VALUES (1,'Australian GST','2300','2310','','','','');
INSERT INTO `weberp_taxauthorities` VALUES (5,'Sales Tax','2300','2310','','','','');
INSERT INTO `weberp_taxauthorities` VALUES (11,'Canadian GST','2300','2310','','','','');
INSERT INTO `weberp_taxauthorities` VALUES (12,'Ontario PST','2300','2310','','','','');
INSERT INTO `weberp_taxauthorities` VALUES (13,'UK VAT','2300','2310','','','','');

--
-- Dumping data for table `taxgroups`
--

INSERT INTO `weberp_taxgroups` VALUES (1,'Default');
INSERT INTO `weberp_taxgroups` VALUES (2,'Ontario');
INSERT INTO `weberp_taxgroups` VALUES (3,'UK Inland Revenue');

--
-- Dumping data for table `taxauthrates`
--

INSERT INTO `weberp_taxauthrates` VALUES (1,1,1,0.1);
INSERT INTO `weberp_taxauthrates` VALUES (1,1,2,0);
INSERT INTO `weberp_taxauthrates` VALUES (1,1,5,0);
INSERT INTO `weberp_taxauthrates` VALUES (5,1,1,0.2);
INSERT INTO `weberp_taxauthrates` VALUES (5,1,2,0.35);
INSERT INTO `weberp_taxauthrates` VALUES (5,1,5,0);
INSERT INTO `weberp_taxauthrates` VALUES (11,1,1,0.07);
INSERT INTO `weberp_taxauthrates` VALUES (11,1,2,0.12);
INSERT INTO `weberp_taxauthrates` VALUES (11,1,5,0.07);
INSERT INTO `weberp_taxauthrates` VALUES (12,1,1,0.05);
INSERT INTO `weberp_taxauthrates` VALUES (12,1,2,0.075);
INSERT INTO `weberp_taxauthrates` VALUES (12,1,5,0);
INSERT INTO `weberp_taxauthrates` VALUES (13,1,1,0);
INSERT INTO `weberp_taxauthrates` VALUES (13,1,2,0);
INSERT INTO `weberp_taxauthrates` VALUES (13,1,5,0);

--
-- Dumping data for table `taxcategories`
--

INSERT INTO `weberp_taxcategories` VALUES (1,'Taxable supply');
INSERT INTO `weberp_taxcategories` VALUES (2,'Luxury Items');
INSERT INTO `weberp_taxcategories` VALUES (4,'Exempt');
INSERT INTO `weberp_taxcategories` VALUES (5,'Freight');

--
-- Dumping data for table `taxprovinces`
--

INSERT INTO `weberp_taxprovinces` VALUES (1,'Default Tax province');

--
-- Dumping data for table `www_users`
--

INSERT INTO `weberp_www_users` VALUES ('admin','$2y$10$Q8HLC/2rQaB5NcCcK6V6ZOQG3chIsx16mKtZRoSaUsU9okMBDbUwG','Demonstration user','','','','','admin@weberp.org','MEL',8,1,'2016-05-16 21:28:23','','A4','1,1,1,1,1,1,1,1,1,1,1,',0,0,50,'xenos','en_US.utf8',0,0);

--
-- Dumping data for table `edi_orders_segs`
--

INSERT INTO `weberp_edi_orders_segs` VALUES (1,'UNB',0,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (2,'UNH',0,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (3,'BGM',0,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (4,'DTM',0,35);
INSERT INTO `weberp_edi_orders_segs` VALUES (5,'PAI',0,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (6,'ALI',0,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (7,'FTX',0,99);
INSERT INTO `weberp_edi_orders_segs` VALUES (8,'RFF',1,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (9,'DTM',1,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (10,'NAD',2,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (11,'LOC',2,99);
INSERT INTO `weberp_edi_orders_segs` VALUES (12,'FII',2,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (13,'RFF',3,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (14,'CTA',5,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (15,'COM',5,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (16,'TAX',6,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (17,'MOA',6,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (18,'CUX',7,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (19,'DTM',7,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (20,'PAT',8,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (21,'DTM',8,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (22,'PCD',8,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (23,'MOA',9,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (24,'TDT',10,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (25,'LOC',11,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (26,'DTM',11,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (27,'TOD',12,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (28,'LOC',12,2);
INSERT INTO `weberp_edi_orders_segs` VALUES (29,'PAC',13,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (30,'PCI',14,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (31,'RFF',14,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (32,'DTM',14,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (33,'GIN',14,10);
INSERT INTO `weberp_edi_orders_segs` VALUES (34,'EQD',15,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (35,'ALC',19,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (36,'ALI',19,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (37,'DTM',19,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (38,'QTY',20,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (39,'RNG',20,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (40,'PCD',21,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (41,'RNG',21,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (42,'MOA',22,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (43,'RNG',22,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (44,'RTE',23,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (45,'RNG',23,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (46,'TAX',24,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (47,'MOA',24,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (48,'LIN',28,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (49,'PIA',28,25);
INSERT INTO `weberp_edi_orders_segs` VALUES (50,'IMD',28,99);
INSERT INTO `weberp_edi_orders_segs` VALUES (51,'MEA',28,99);
INSERT INTO `weberp_edi_orders_segs` VALUES (52,'QTY',28,99);
INSERT INTO `weberp_edi_orders_segs` VALUES (53,'ALI',28,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (54,'DTM',28,35);
INSERT INTO `weberp_edi_orders_segs` VALUES (55,'MOA',28,10);
INSERT INTO `weberp_edi_orders_segs` VALUES (56,'GIN',28,127);
INSERT INTO `weberp_edi_orders_segs` VALUES (57,'QVR',28,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (58,'FTX',28,99);
INSERT INTO `weberp_edi_orders_segs` VALUES (59,'PRI',32,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (60,'CUX',32,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (61,'DTM',32,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (62,'RFF',33,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (63,'DTM',33,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (64,'PAC',34,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (65,'QTY',34,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (66,'PCI',36,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (67,'RFF',36,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (68,'DTM',36,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (69,'GIN',36,10);
INSERT INTO `weberp_edi_orders_segs` VALUES (70,'LOC',37,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (71,'QTY',37,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (72,'DTM',37,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (73,'TAX',38,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (74,'MOA',38,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (75,'NAD',39,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (76,'CTA',42,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (77,'COM',42,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (78,'ALC',43,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (79,'ALI',43,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (80,'DTM',43,5);
INSERT INTO `weberp_edi_orders_segs` VALUES (81,'QTY',44,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (82,'RNG',44,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (83,'PCD',45,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (84,'RNG',45,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (85,'MOA',46,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (86,'RNG',46,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (87,'RTE',47,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (88,'RNG',47,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (89,'TAX',48,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (90,'MOA',48,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (91,'TDT',49,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (92,'UNS',50,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (93,'MOA',50,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (94,'CNT',50,1);
INSERT INTO `weberp_edi_orders_segs` VALUES (95,'UNT',50,1);

--
-- Dumping data for table `edi_orders_seg_groups`
--

INSERT INTO `weberp_edi_orders_seg_groups` VALUES (0,1,0);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (1,9999,0);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (2,99,0);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (3,99,2);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (5,5,2);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (6,5,0);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (7,5,0);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (8,10,0);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (9,9999,8);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (10,10,0);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (11,10,10);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (12,5,0);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (13,99,0);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (14,5,13);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (15,10,0);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (19,99,0);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (20,1,19);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (21,1,19);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (22,2,19);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (23,1,19);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (24,5,19);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (28,200000,0);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (32,25,28);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (33,9999,28);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (34,99,28);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (36,5,34);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (37,9999,28);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (38,10,28);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (39,999,28);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (42,5,39);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (43,99,28);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (44,1,43);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (45,1,43);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (46,2,43);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (47,1,43);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (48,5,43);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (49,10,28);
INSERT INTO `weberp_edi_orders_seg_groups` VALUES (50,1,0);

--
-- Dumping data for table `config`
--

INSERT INTO `weberp_config` VALUES ('AllowOrderLineItemNarrative','1');
INSERT INTO `weberp_config` VALUES ('AllowSalesOfZeroCostItems','0');
INSERT INTO `weberp_config` VALUES ('AutoAuthorisePO','1');
INSERT INTO `weberp_config` VALUES ('AutoCreateWOs','1');
INSERT INTO `weberp_config` VALUES ('AutoDebtorNo','0');
INSERT INTO `weberp_config` VALUES ('AutoIssue','1');
INSERT INTO `weberp_config` VALUES ('AutoSupplierNo','0');
INSERT INTO `weberp_config` VALUES ('CheckCreditLimits','1');
INSERT INTO `weberp_config` VALUES ('Check_Price_Charged_vs_Order_Price','1');
INSERT INTO `weberp_config` VALUES ('Check_Qty_Charged_vs_Del_Qty','1');
INSERT INTO `weberp_config` VALUES ('CountryOfOperation','US');
INSERT INTO `weberp_config` VALUES ('CreditingControlledItems_MustExist','0');
INSERT INTO `weberp_config` VALUES ('DB_Maintenance','0');
INSERT INTO `weberp_config` VALUES ('DB_Maintenance_LastRun','2015-08-14');
INSERT INTO `weberp_config` VALUES ('DefaultBlindPackNote','1');
INSERT INTO `weberp_config` VALUES ('DefaultCreditLimit','1000');
INSERT INTO `weberp_config` VALUES ('DefaultCustomerType','1');
INSERT INTO `weberp_config` VALUES ('DefaultDateFormat','d/m/Y');
INSERT INTO `weberp_config` VALUES ('DefaultDisplayRecordsMax','50');
INSERT INTO `weberp_config` VALUES ('DefaultFactoryLocation','MEL');
INSERT INTO `weberp_config` VALUES ('DefaultPriceList','DE');
INSERT INTO `weberp_config` VALUES ('DefaultSupplierType','1');
INSERT INTO `weberp_config` VALUES ('DefaultTaxCategory','1');
INSERT INTO `weberp_config` VALUES ('Default_Shipper','1');
INSERT INTO `weberp_config` VALUES ('DefineControlledOnWOEntry','1');
INSERT INTO `weberp_config` VALUES ('DispatchCutOffTime','14');
INSERT INTO `weberp_config` VALUES ('DoFreightCalc','0');
INSERT INTO `weberp_config` VALUES ('EDIHeaderMsgId','D:01B:UN:EAN010');
INSERT INTO `weberp_config` VALUES ('EDIReference','WEBERP');
INSERT INTO `weberp_config` VALUES ('EDI_Incoming_Orders','companies/test/EDI_Incoming_Orders');
INSERT INTO `weberp_config` VALUES ('EDI_MsgPending','companies/test/EDI_Pending');
INSERT INTO `weberp_config` VALUES ('EDI_MsgSent','companies/test/EDI__Sent');
INSERT INTO `weberp_config` VALUES ('ExchangeRateFeed','Google');
INSERT INTO `weberp_config` VALUES ('Extended_CustomerInfo','1');
INSERT INTO `weberp_config` VALUES ('Extended_SupplierInfo','1');
INSERT INTO `weberp_config` VALUES ('FactoryManagerEmail','manager@company.com');
INSERT INTO `weberp_config` VALUES ('FreightChargeAppliesIfLessThan','1000');
INSERT INTO `weberp_config` VALUES ('FreightTaxCategory','1');
INSERT INTO `weberp_config` VALUES ('FrequentlyOrderedItems','0');
INSERT INTO `weberp_config` VALUES ('geocode_integration','0');
INSERT INTO `weberp_config` VALUES ('GoogleTranslatorAPIKey','');
INSERT INTO `weberp_config` VALUES ('HTTPS_Only','0');
INSERT INTO `weberp_config` VALUES ('InventoryManagerEmail','test@company.com');
INSERT INTO `weberp_config` VALUES ('InvoicePortraitFormat','0');
INSERT INTO `weberp_config` VALUES ('InvoiceQuantityDefault','1');
INSERT INTO `weberp_config` VALUES ('ItemDescriptionLanguages',',fr_FR.utf8,');
INSERT INTO `weberp_config` VALUES ('LogPath','');
INSERT INTO `weberp_config` VALUES ('LogSeverity','0');
INSERT INTO `weberp_config` VALUES ('MaxImageSize','300');
INSERT INTO `weberp_config` VALUES ('MonthsAuditTrail','1');
INSERT INTO `weberp_config` VALUES ('NumberOfMonthMustBeShown','6');
INSERT INTO `weberp_config` VALUES ('NumberOfPeriodsOfStockUsage','12');
INSERT INTO `weberp_config` VALUES ('OverChargeProportion','30');
INSERT INTO `weberp_config` VALUES ('OverReceiveProportion','20');
INSERT INTO `weberp_config` VALUES ('PackNoteFormat','1');
INSERT INTO `weberp_config` VALUES ('PageLength','48');
INSERT INTO `weberp_config` VALUES ('part_pics_dir','companies/weberpdemo/part_pics');
INSERT INTO `weberp_config` VALUES ('PastDueDays1','30');
INSERT INTO `weberp_config` VALUES ('PastDueDays2','60');
INSERT INTO `weberp_config` VALUES ('PO_AllowSameItemMultipleTimes','1');
INSERT INTO `weberp_config` VALUES ('ProhibitJournalsToControlAccounts','1');
INSERT INTO `weberp_config` VALUES ('ProhibitNegativeStock','0');
INSERT INTO `weberp_config` VALUES ('ProhibitPostingsBefore','2013-12-31');
INSERT INTO `weberp_config` VALUES ('PurchasingManagerEmail','test@company.com');
INSERT INTO `weberp_config` VALUES ('QualityCOAText','');
INSERT INTO `weberp_config` VALUES ('QualityLogSamples','0');
INSERT INTO `weberp_config` VALUES ('QualityProdSpecText','');
INSERT INTO `weberp_config` VALUES ('QuickEntries','10');
INSERT INTO `weberp_config` VALUES ('RadioBeaconFileCounter','/home/RadioBeacon/FileCounter');
INSERT INTO `weberp_config` VALUES ('RadioBeaconFTP_user_name','RadioBeacon ftp server user name');
INSERT INTO `weberp_config` VALUES ('RadioBeaconHomeDir','/home/RadioBeacon');
INSERT INTO `weberp_config` VALUES ('RadioBeaconStockLocation','BL');
INSERT INTO `weberp_config` VALUES ('RadioBraconFTP_server','192.168.2.2');
INSERT INTO `weberp_config` VALUES ('RadioBreaconFilePrefix','ORDXX');
INSERT INTO `weberp_config` VALUES ('RadionBeaconFTP_user_pass','Radio Beacon remote ftp server password');
INSERT INTO `weberp_config` VALUES ('reports_dir','companies/weberpdemo/reportwriter');
INSERT INTO `weberp_config` VALUES ('RequirePickingNote','0');
INSERT INTO `weberp_config` VALUES ('RomalpaClause','Ownership will not pass to the buyer until the goods have been paid for in full.');
INSERT INTO `weberp_config` VALUES ('ShopAboutUs','This web-shop software has been developed by Logic Works Ltd for webERP. For support contact Phil Daintree by rn<a href=\\\"mailto:support@logicworks.co.nz\\\">email</a>rn');
INSERT INTO `weberp_config` VALUES ('ShopAllowBankTransfer','1');
INSERT INTO `weberp_config` VALUES ('ShopAllowCreditCards','1');
INSERT INTO `weberp_config` VALUES ('ShopAllowPayPal','1');
INSERT INTO `weberp_config` VALUES ('ShopAllowSurcharges','1');
INSERT INTO `weberp_config` VALUES ('ShopBankTransferSurcharge','0.0');
INSERT INTO `weberp_config` VALUES ('ShopBranchCode','ANGRY');
INSERT INTO `weberp_config` VALUES ('ShopContactUs','For support contact Logic Works Ltd by rn<a href=\\\"mailto:support@logicworks.co.nz\\\">email</a>');
INSERT INTO `weberp_config` VALUES ('ShopCreditCardBankAccount','1030');
INSERT INTO `weberp_config` VALUES ('ShopCreditCardGateway','SwipeHQ');
INSERT INTO `weberp_config` VALUES ('ShopCreditCardSurcharge','2.95');
INSERT INTO `weberp_config` VALUES ('ShopDebtorNo','ANGRY');
INSERT INTO `weberp_config` VALUES ('ShopFreightMethod','NoFreight');
INSERT INTO `weberp_config` VALUES ('ShopFreightPolicy','Shipping information');
INSERT INTO `weberp_config` VALUES ('ShopManagerEmail','shopmanager@yourdomain.com');
INSERT INTO `weberp_config` VALUES ('ShopMode','test');
INSERT INTO `weberp_config` VALUES ('ShopName','webERP Demo Store');
INSERT INTO `weberp_config` VALUES ('ShopPayFlowMerchant','');
INSERT INTO `weberp_config` VALUES ('ShopPayFlowPassword','');
INSERT INTO `weberp_config` VALUES ('ShopPayFlowUser','');
INSERT INTO `weberp_config` VALUES ('ShopPayFlowVendor','');
INSERT INTO `weberp_config` VALUES ('ShopPayPalBankAccount','1040');
INSERT INTO `weberp_config` VALUES ('ShopPaypalCommissionAccount','1');
INSERT INTO `weberp_config` VALUES ('ShopPayPalPassword','');
INSERT INTO `weberp_config` VALUES ('ShopPayPalProPassword','');
INSERT INTO `weberp_config` VALUES ('ShopPayPalProSignature','');
INSERT INTO `weberp_config` VALUES ('ShopPayPalProUser','');
INSERT INTO `weberp_config` VALUES ('ShopPayPalSignature','');
INSERT INTO `weberp_config` VALUES ('ShopPayPalSurcharge','3.4');
INSERT INTO `weberp_config` VALUES ('ShopPayPalUser','');
INSERT INTO `weberp_config` VALUES ('ShopPrivacyStatement','<h2>We are committed to protecting your privacy.</h2><p>We recognise that your personal information is confidential and we understand that it is important for you to know how we treat your personal information. Please read on for more information about our Privacy Policy.</p><ul><li><h2>1. What information do we collect and how do we use it?</h2><br />We use the information it collects from you for the following purposes:<ul><li>To assist us in providing you with a quality service</li><li>To respond to, and process, your request</li><li>To notify competition winners or fulfil promotional obligations</li><li>To inform you of, and provide you with, new and existing products and services offered by us from time to time </li></ul><p>Any information we collect will not be used in ways that you have not consented to.</p><p>If you send us an email, we will store your email address and the contents of the email. This information will only be used for the purpose for which you have provided it. Electronic mail submitted to us is handled and saved according to the provisions of the the relevant statues.</p><p>When we offer contests and promotions, customers who choose to enter are asked to provide personal information. This information may then be used by us to notify winners, or to fulfil promotional obligations.</p><p>We may use the information we collect to occasionally notify you about important functionality changes to our website, new and special offers we think you will find valuable. If at any stage you no longer wish to receive these notifications you may opt out by sending us an email.</p><p>We do monitor this website in order to identify user trends and to improve the site if necessary. Any of this information, such as the type of site browser your computer has, will be used only in aggregate form and your individual details will not be identified.</p></li><li><h2>2. How do we store and protect your personal information and who has access to that information?</h2><p>As required by statute, we follow strict procedures when storing and using the information you have provided.</p><p>We do not sell, trade or rent your personal information to others. We may provide aggregate statistics about our customers and website trends. However, these statistics will not have any personal information which would identify you.</p><p>Only specific employees within our company are able to access your personal data.</p><p>This policy means that we may require proof of identity before we disclose any information to you.</p></li><li><h2>3. What should I do if I want to change my details or if I donÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢t want to be contacted any more?</h2><p>At any stage you have the right to access and amend or update your personal details. If you do not want to receive any communications from us you may opt out by contacting us see <a href=\\\"index.php?Page=ContactUs\\\">the Contact Us Page</a></p></li><li><h2>4. What happens if we decide to change this Privacy Policy?</h2><p>If we change any aspect of our Privacy Policy we will post these changes on this page so that you are always aware of how we are treating your personal information.</p></li><li><h2>5. How can you contact us if you have any questions, comments or concerns about our Privacy Policy?</h2><p>We welcome any questions or comments you may have please email us via the contact details provided on our <a href=\\\"index.php?Page=ContactUs\\\">Contact Us Page</a></p></li></ul><p>Please also refer to our <a href=\\\"index.php?Page=TermsAndConditions\\\">Terms and Conditions</a> for more information.</p>');
INSERT INTO `weberp_config` VALUES ('ShopShowOnlyAvailableItems','0');
INSERT INTO `weberp_config` VALUES ('ShopShowQOHColumn','1');
INSERT INTO `weberp_config` VALUES ('ShopStockLocations','MEL,TOR');
INSERT INTO `weberp_config` VALUES ('ShopSurchargeStockID','PAYTSURCHARGE');
INSERT INTO `weberp_config` VALUES ('ShopSwipeHQAPIKey','');
INSERT INTO `weberp_config` VALUES ('ShopSwipeHQMerchantID','');
INSERT INTO `weberp_config` VALUES ('ShopTermsConditions','<p>These terms cover the use of this website. Use includes visits to our sites, purchases on our sites, participation in our database and promotions. These terms of use apply to you when you use our websites. Please read these terms carefully - if you need to refer to them again they can be accessed from the link at the bottom of any page of our websites.</p><br /><ul><li><h2>1. Content</h2><p>While we endeavour to supply accurate information on this site, errors and omissions may occur. We do not accept any liability, direct or indirect, for any loss or damage which may directly or indirectly result from any advice, opinion, information, representation or omission whether negligent or otherwise, contained on this site. You are solely responsible for the actions you take in reliance on the content on, or accessed, through this site.</p><p>We reserve the right to make changes to the content on this site at any time and without notice.</p><p>To the extent permitted by law, we make no warranties in relation to the merchantability, fitness for purpose, freedom from computer virus, accuracy or availability of this web site or any other web site.</p></li><li><h2>2. Making a contract with us</h2><p>When you place an order with us, you are making an offer to buy goods. We will send you an e-mail to confirm that we have received and accepted your order, which indicates that a contract has been made between us. We will take payment from you when we accept your order. In the unlikely event that the goods are no longer available, we will refund your payment to the account it originated from, and advise that the goods are no longer available.</p><p>An order is placed on our website via adding a product to the shopping cart and proceeding through our checkout process. The checkout process includes giving us delivery and any other relevant details for your order, entering payment information and submitting your order. The final step consists of a confirmation page with full details of your order, which you are able to print as a receipt of your order. We will also email you with confirmation of your order.</p><p>We reserve the right to refuse or cancel any orders that we believe, solely by our own judgement, to be placed for commercial purposes, e.g. any kind of reseller. We also reserve the right to refuse or cancel any orders that we believe, solely by our own judgement, to have been placed fraudulently.</p><p>We reserve the right to limit the number of an item customers can purchase in a single transaction.</p></li><li><h2>3. Payment options</h2><p>We currently accept the following credit cards:</p><ul><li>Visa</li><li>MasterCard</li><li>American Express</li></ul>You can also pay using PayPal and internet bank transfer. Surcharges may apply for payment by PayPal or credit cards.</p></li><li><h2>4. Pricing</h2><p>All prices listed are inclusive of relevant taxes.  All prices are correct when published. Please note that we reserve the right to alter prices at any time for any reason. If this should happen after you have ordered a product, we will contact you prior to processing your order. Online and in store pricing may differ.</p></li><li><h2>5. Website and Credit Card Security</h2><p>We want you to have a safe and secure shopping experience online. All payments via our sites are processed using SSL (Secure Socket Layer) protocol, whereby sensitive information is encrypted to protect your privacy.</p><p>You can help to protect your details from unauthorised access by logging out each time you finish using the site, particularly if you are doing so from a public or shared computer.</p><p>For security purposes certain transactions may require proof of identification.</p></li><li><h2>6. Delivery and Delivery Charges</h2><p>We do not deliver to Post Office boxes.</p><p>Please note that a signature is required for all deliveries. The goods become the recipientÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢s property and responsibility once they have been signed for at the time of delivery. If goods are lost or damaged in transit, please contact us within 7 business days <a href=\\\"index.php?Page=ContactUs\\\">see Contact Us page for contact details</a>. We will use this delivery information to make a claim against our courier company. We will offer you the choice of a replacement or a full refund, once we have received confirmation from our courier company that delivery was not successful.</p></li><li><h2>7. Restricted Products</h2><p>Some products on our site carry an age restriction, if a product you have selected is R16 or R18 a message will appear in the cart asking you to confirm you are an appropriate age to purchase the item(s).  Confirming this means that you are of an eligible age to purchase the selected product(s).  You are also agreeing that you are not purchasing the item on behalf of a person who is not the appropriate age.</p></li><li><h2>8. Delivery Period</h2><p>Delivery lead time for products may vary. Deliveries to rural addresses may take longer.  You will receive an email that confirms that your order has been dispatched.</p><p>To ensure successful delivery, please provide a delivery address where someone will be present during business hours to sign for the receipt of your package. You can track your order by entering the tracking number emailed to you in the dispatch email at the Courier\\\'s web-site.</p></li><li><h2>9. Disclaimer</h2><p>Our websites are intended to provide information for people shopping our products and accessing our services, including making purchases via our website and registering on our database to receive e-mails from us.</p><p>While we endeavour to supply accurate information on this site, errors and omissions may occur. We do not accept any liability, direct or indirect, for any loss or damage which may directly or indirectly result from any advice, opinion, information, representation or omission whether negligent or otherwise, contained on this site. You are solely responsible for the actions you take in reliance on the content on, or accessed, through this site.</p><p>We reserve the right to make changes to the content on this site at any time and without notice.</p><p>To the extent permitted by law, we make no warranties in relation to the merchantability, fitness for purpose, freedom from computer virus, accuracy or availability of this web site or any other web site.</p></li><li><h2>10. Links</h2><p>Please note that although this site has some hyperlinks to other third party websites, these sites have not been prepared by us are not under our control. The links are only provided as a convenience, and do not imply that we endorse, check, or approve of the third party site. We are not responsible for the privacy principles or content of these third party sites. We are not responsible for the availability of any of these links.</p></li><li><h2>11. Jurisdiction</h2><p>This website is governed by, and is to be interpreted in accordance with, the laws of  ????.</p></li><li><h2>12. Changes to this Agreement</h2><p>We reserve the right to alter, modify or update these terms of use. These terms apply to your order. We may change our terms and conditions at any time, so please do not assume that the same terms will apply to future orders.</p></li></ul>');
INSERT INTO `weberp_config` VALUES ('ShopTitle','Shop Home');
INSERT INTO `weberp_config` VALUES ('ShowStockidOnImages','0');
INSERT INTO `weberp_config` VALUES ('ShowValueOnGRN','1');
INSERT INTO `weberp_config` VALUES ('Show_Settled_LastMonth','1');
INSERT INTO `weberp_config` VALUES ('SmtpSetting','0');
INSERT INTO `weberp_config` VALUES ('SO_AllowSameItemMultipleTimes','1');
INSERT INTO `weberp_config` VALUES ('StandardCostDecimalPlaces','2');
INSERT INTO `weberp_config` VALUES ('TaxAuthorityReferenceName','');
INSERT INTO `weberp_config` VALUES ('UpdateCurrencyRatesDaily','2016-05-16');
INSERT INTO `weberp_config` VALUES ('VersionNumber','4.13');
INSERT INTO `weberp_config` VALUES ('WeightedAverageCosting','0');
INSERT INTO `weberp_config` VALUES ('WikiApp','DokuWiki');
INSERT INTO `weberp_config` VALUES ('WikiPath','wiki');
INSERT INTO `weberp_config` VALUES ('WorkingDaysWeek','5');
INSERT INTO `weberp_config` VALUES ('YearEnd','3');

--
-- Dumping data for table `unitsofmeasure`
--

INSERT INTO `weberp_unitsofmeasure` VALUES (1,'each');
INSERT INTO `weberp_unitsofmeasure` VALUES (2,'meters');
INSERT INTO `weberp_unitsofmeasure` VALUES (3,'kgs');
INSERT INTO `weberp_unitsofmeasure` VALUES (4,'litres');
INSERT INTO `weberp_unitsofmeasure` VALUES (5,'length');
INSERT INTO `weberp_unitsofmeasure` VALUES (6,'hours');
INSERT INTO `weberp_unitsofmeasure` VALUES (7,'feet');

--
-- Dumping data for table `paymentmethods`
--

INSERT INTO `weberp_paymentmethods` VALUES (1,'Cheque',1,1,1,0);
INSERT INTO `weberp_paymentmethods` VALUES (2,'Cash',1,1,0,0);
INSERT INTO `weberp_paymentmethods` VALUES (3,'Direct Credit',1,1,0,0);

--
-- Dumping data for table `scripts`
--

INSERT INTO `weberp_scripts` VALUES ('AccountGroups.php',10,'Defines the groupings of general ledger accounts');
INSERT INTO `weberp_scripts` VALUES ('AccountSections.php',10,'Defines the sections in the general ledger reports');
INSERT INTO `weberp_scripts` VALUES ('AddCustomerContacts.php',3,'Adds customer contacts');
INSERT INTO `weberp_scripts` VALUES ('AddCustomerNotes.php',3,'Adds notes about customers');
INSERT INTO `weberp_scripts` VALUES ('AddCustomerTypeNotes.php',3,'');
INSERT INTO `weberp_scripts` VALUES ('AgedControlledInventory.php',11,'Report of Controlled Items and their age');
INSERT INTO `weberp_scripts` VALUES ('AgedDebtors.php',2,'Lists customer account balances in detail or summary in selected currency');
INSERT INTO `weberp_scripts` VALUES ('AgedSuppliers.php',2,'Lists supplier account balances in detail or summary in selected currency');
INSERT INTO `weberp_scripts` VALUES ('AnalysisHorizontalIncome.php',8,'Shows the horizontal analysis of the statement of comprehensive income');
INSERT INTO `weberp_scripts` VALUES ('AnalysisHorizontalPosition.php',8,'Shows the horizontal analysis of the statement of financial position');
INSERT INTO `weberp_scripts` VALUES ('Areas.php',3,'Defines the sales areas - all customers must belong to a sales area for the purposes of sales analysis');
INSERT INTO `weberp_scripts` VALUES ('AuditTrail.php',15,'Shows the activity with SQL statements and who performed the changes');
INSERT INTO `weberp_scripts` VALUES ('AutomaticTranslationDescriptions.php',15,'Translates via Google Translator all empty translated descriptions');
INSERT INTO `weberp_scripts` VALUES ('BankAccounts.php',10,'Defines the general ledger code for bank accounts and specifies that bank transactions be created for these accounts for the purposes of reconciliation');
INSERT INTO `weberp_scripts` VALUES ('BankAccountUsers.php',15,'Maintains table bankaccountusers (Authorized users to work with a bank account in webERP)');
INSERT INTO `weberp_scripts` VALUES ('BankMatching.php',7,'Allows payments and receipts to be matched off against bank statements');
INSERT INTO `weberp_scripts` VALUES ('BankReconciliation.php',7,'Displays the bank reconciliation for a selected bank account');
INSERT INTO `weberp_scripts` VALUES ('BOMExtendedQty.php',2,'Shows the component requirements to make an item');
INSERT INTO `weberp_scripts` VALUES ('BOMIndented.php',2,'Shows the bill of material indented for each level');
INSERT INTO `weberp_scripts` VALUES ('BOMIndentedReverse.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('BOMInquiry.php',2,'Displays the bill of material with cost information');
INSERT INTO `weberp_scripts` VALUES ('BOMListing.php',2,'Lists the bills of material for a selected range of items');
INSERT INTO `weberp_scripts` VALUES ('BOMs.php',9,'Administers the bills of material for a selected item');
INSERT INTO `weberp_scripts` VALUES ('BOMs_SingleLevel.php',2,'Single Level BOM entry');
INSERT INTO `weberp_scripts` VALUES ('COGSGLPostings.php',10,'Defines the general ledger account to be used for cost of sales entries');
INSERT INTO `weberp_scripts` VALUES ('CollectiveWorkOrderCost.php',2,'Multiple work orders cost review');
INSERT INTO `weberp_scripts` VALUES ('CompanyPreferences.php',10,'Defines the settings applicable for the company, including name, address, tax authority reference, whether GL integration used etc.');
INSERT INTO `weberp_scripts` VALUES ('ConfirmDispatchControlled_Invoice.php',2,'Specifies the batch references/serial numbers of items dispatched that are being invoiced');
INSERT INTO `weberp_scripts` VALUES ('ConfirmDispatch_Invoice.php',2,'Creates sales invoices from entered sales orders based on the quantities dispatched that can be modified');
INSERT INTO `weberp_scripts` VALUES ('ContractBOM.php',6,'Creates the item requirements from stock for a contract as part of the contract cost build up');
INSERT INTO `weberp_scripts` VALUES ('ContractCosting.php',6,'Shows a contract cost - the components and other non-stock costs issued to the contract');
INSERT INTO `weberp_scripts` VALUES ('ContractOtherReqts.php',4,'Creates the other requirements for a contract cost build up');
INSERT INTO `weberp_scripts` VALUES ('Contracts.php',6,'Creates or modifies a customer contract costing');
INSERT INTO `weberp_scripts` VALUES ('CopyBOM.php',9,'Allows a bill of material to be copied between items');
INSERT INTO `weberp_scripts` VALUES ('CostUpdate',10,'NB Not a script but allows users to maintain item costs from withing StockCostUpdate.php');
INSERT INTO `weberp_scripts` VALUES ('CounterReturns.php',5,'Allows credits and refunds from the default Counter Sale account for an inventory location');
INSERT INTO `weberp_scripts` VALUES ('CounterSales.php',1,'Allows sales to be entered against a cash sale customer account defined in the users location record');
INSERT INTO `weberp_scripts` VALUES ('CreditItemsControlled.php',3,'Specifies the batch references/serial numbers of items being credited back into stock');
INSERT INTO `weberp_scripts` VALUES ('CreditStatus.php',3,'Defines the credit status records. Each customer account is given a credit status from this table. Some credit status records can prohibit invoicing and new orders being entered.');
INSERT INTO `weberp_scripts` VALUES ('Credit_Invoice.php',3,'Creates a credit note based on the details of an existing invoice');
INSERT INTO `weberp_scripts` VALUES ('Currencies.php',9,'Defines the currencies available. Each customer and supplier must be defined as transacting in one of the currencies defined here.');
INSERT INTO `weberp_scripts` VALUES ('CustEDISetup.php',11,'Allows the set up the customer specified EDI parameters for server, email or ftp.');
INSERT INTO `weberp_scripts` VALUES ('CustItem.php',11,'Customer Items');
INSERT INTO `weberp_scripts` VALUES ('CustLoginSetup.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('CustomerAccount.php',1,'Shows customer account/statement on screen rather than PDF');
INSERT INTO `weberp_scripts` VALUES ('CustomerAllocations.php',3,'Allows customer receipts and credit notes to be allocated to sales invoices');
INSERT INTO `weberp_scripts` VALUES ('CustomerBalancesMovement.php',3,'Allow customers to be listed in local currency with balances and activity over a date range');
INSERT INTO `weberp_scripts` VALUES ('CustomerBranches.php',3,'Defines the details of customer branches such as delivery address and contact details - also sales area, representative etc');
INSERT INTO `weberp_scripts` VALUES ('CustomerInquiry.php',1,'Shows the customers account transactions with balances outstanding, links available to drill down to invoice/credit note or email invoices/credit notes');
INSERT INTO `weberp_scripts` VALUES ('CustomerPurchases.php',5,'Shows the purchases a customer has made.');
INSERT INTO `weberp_scripts` VALUES ('CustomerReceipt.php',3,'Entry of both customer receipts against accounts receivable and also general ledger or nominal receipts');
INSERT INTO `weberp_scripts` VALUES ('Customers.php',3,'Defines the setup of a customer account, including payment terms, billing address, credit status, currency etc');
INSERT INTO `weberp_scripts` VALUES ('CustomerTransInquiry.php',2,'Lists in html the sequence of customer transactions, invoices, credit notes or receipts by a user entered date range');
INSERT INTO `weberp_scripts` VALUES ('CustomerTypes.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('CustWhereAlloc.php',2,'Shows to which invoices a receipt was allocated to');
INSERT INTO `weberp_scripts` VALUES ('DailyBankTransactions.php',8,'Allows you to view all bank transactions for a selected date range, and the inquiry can be filtered by matched or unmatched transactions, or all transactions can be chosen');
INSERT INTO `weberp_scripts` VALUES ('DailySalesInquiry.php',2,'Shows the daily sales with GP in a calendar format');
INSERT INTO `weberp_scripts` VALUES ('Dashboard.php',1,'Display outstanding debtors, creditors etc');
INSERT INTO `weberp_scripts` VALUES ('DebtorsAtPeriodEnd.php',2,'Shows the debtors control account as at a previous period end - based on system calendar monthly periods');
INSERT INTO `weberp_scripts` VALUES ('DeliveryDetails.php',1,'Used during order entry to allow the entry of delivery addresses other than the defaulted branch delivery address and information about carrier/shipping method etc');
INSERT INTO `weberp_scripts` VALUES ('Departments.php',1,'Create business departments');
INSERT INTO `weberp_scripts` VALUES ('DiscountCategories.php',11,'Defines the items belonging to a discount category. Discount Categories are used to allow discounts based on quantities across a range of producs');
INSERT INTO `weberp_scripts` VALUES ('DiscountMatrix.php',11,'Defines the rates of discount applicable to discount categories and the customer groupings to which the rates are to apply');
INSERT INTO `weberp_scripts` VALUES ('EDIMessageFormat.php',10,'Specifies the EDI message format used by a customer - administrator use only.');
INSERT INTO `weberp_scripts` VALUES ('EDIProcessOrders.php',11,'Processes incoming EDI orders into sales orders');
INSERT INTO `weberp_scripts` VALUES ('EDISendInvoices.php',15,'Processes invoiced EDI customer invoices into EDI messages and sends using the customers preferred method either ftp or email attachments.');
INSERT INTO `weberp_scripts` VALUES ('EmailConfirmation.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('EmailCustTrans.php',2,'Emails selected invoice or credit to the customer');
INSERT INTO `weberp_scripts` VALUES ('ExchangeRateTrend.php',2,'Shows the trend in exchange rates as retrieved from ECB');
INSERT INTO `weberp_scripts` VALUES ('Factors.php',5,'Defines supplier factor companies');
INSERT INTO `weberp_scripts` VALUES ('FixedAssetCategories.php',11,'Defines the various categories of fixed assets');
INSERT INTO `weberp_scripts` VALUES ('FixedAssetDepreciation.php',10,'Calculates and creates GL transactions to post depreciation for a period');
INSERT INTO `weberp_scripts` VALUES ('FixedAssetItems.php',11,'Allows fixed assets to be defined');
INSERT INTO `weberp_scripts` VALUES ('FixedAssetLocations.php',11,'Allows the locations of fixed assets to be defined');
INSERT INTO `weberp_scripts` VALUES ('FixedAssetRegister.php',11,'Produces a csv, html or pdf report of the fixed assets over a period showing period depreciation, additions and disposals');
INSERT INTO `weberp_scripts` VALUES ('FixedAssetTransfer.php',11,'Allows the fixed asset locations to be changed in bulk');
INSERT INTO `weberp_scripts` VALUES ('FormDesigner.php',14,'');
INSERT INTO `weberp_scripts` VALUES ('FormMaker.php',1,'Allows running user defined Forms');
INSERT INTO `weberp_scripts` VALUES ('FreightCosts.php',11,'Defines the setup of the freight cost using different shipping methods to different destinations. The system can use this information to calculate applicable freight if the items are defined with the correct kgs and cubic volume');
INSERT INTO `weberp_scripts` VALUES ('FTP_RadioBeacon.php',2,'FTPs sales orders for dispatch to a radio beacon software enabled warehouse dispatching facility');
INSERT INTO `weberp_scripts` VALUES ('geocode.php',3,'');
INSERT INTO `weberp_scripts` VALUES ('GeocodeSetup.php',3,'');
INSERT INTO `weberp_scripts` VALUES ('geocode_genxml_customers.php',3,'');
INSERT INTO `weberp_scripts` VALUES ('geocode_genxml_suppliers.php',3,'');
INSERT INTO `weberp_scripts` VALUES ('geo_displaymap_customers.php',3,'');
INSERT INTO `weberp_scripts` VALUES ('geo_displaymap_suppliers.php',3,'');
INSERT INTO `weberp_scripts` VALUES ('GetStockImage.php',1,'');
INSERT INTO `weberp_scripts` VALUES ('GLAccountCSV.php',8,'Produces a CSV of the GL transactions for a particular range of periods and GL account');
INSERT INTO `weberp_scripts` VALUES ('GLAccountInquiry.php',8,'Shows the general ledger transactions for a specified account over a specified range of periods');
INSERT INTO `weberp_scripts` VALUES ('GLAccountReport.php',8,'Produces a report of the GL transactions for a particular account');
INSERT INTO `weberp_scripts` VALUES ('GLAccounts.php',10,'Defines the general ledger accounts');
INSERT INTO `weberp_scripts` VALUES ('GLBalanceSheet.php',8,'Shows the balance sheet for the company as at a specified date');
INSERT INTO `weberp_scripts` VALUES ('GLBudgets.php',10,'Defines GL Budgets');
INSERT INTO `weberp_scripts` VALUES ('GLCodesInquiry.php',8,'Shows the list of general ledger codes defined with account names and groupings');
INSERT INTO `weberp_scripts` VALUES ('GLJournal.php',10,'Entry of general ledger journals, periods are calculated based on the date entered here');
INSERT INTO `weberp_scripts` VALUES ('GLJournalInquiry.php',15,'General Ledger Journal Inquiry');
INSERT INTO `weberp_scripts` VALUES ('GLProfit_Loss.php',8,'Shows the profit and loss of the company for the range of periods entered');
INSERT INTO `weberp_scripts` VALUES ('GLTagProfit_Loss.php',8,'');
INSERT INTO `weberp_scripts` VALUES ('GLTags.php',10,'Allows GL tags to be defined');
INSERT INTO `weberp_scripts` VALUES ('GLTransInquiry.php',8,'Shows the general ledger journal created for the sub ledger transaction specified');
INSERT INTO `weberp_scripts` VALUES ('GLTrialBalance.php',8,'Shows the trial balance for the month and the for the period selected together with the budgeted trial balances');
INSERT INTO `weberp_scripts` VALUES ('GLTrialBalance_csv.php',8,'Produces a CSV of the Trial Balance for a particular period');
INSERT INTO `weberp_scripts` VALUES ('GoodsReceived.php',11,'Entry of items received against purchase orders');
INSERT INTO `weberp_scripts` VALUES ('GoodsReceivedControlled.php',11,'Entry of the serial numbers or batch references for controlled items received against purchase orders');
INSERT INTO `weberp_scripts` VALUES ('GoodsReceivedNotInvoiced.php',2,'Shows the list of goods received but not yet invoiced, both in supplier currency and home currency. Total in home curency should match the GL Account for Goods received not invoiced. Any discrepancy is due to multicurrency errors.');
INSERT INTO `weberp_scripts` VALUES ('HistoricalTestResults.php',16,'Historical Test Results');
INSERT INTO `weberp_scripts` VALUES ('ImportBankTrans.php',11,'Imports bank transactions');
INSERT INTO `weberp_scripts` VALUES ('ImportBankTransAnalysis.php',11,'Allows analysis of bank transactions being imported');
INSERT INTO `weberp_scripts` VALUES ('index.php',1,'The main menu from where all functions available to the user are accessed by clicking on the links');
INSERT INTO `weberp_scripts` VALUES ('InternalStockCategoriesByRole.php',15,'Maintains the stock categories to be used as internal for any user security role');
INSERT INTO `weberp_scripts` VALUES ('InternalStockRequest.php',1,'Create an internal stock request');
INSERT INTO `weberp_scripts` VALUES ('InternalStockRequestAuthorisation.php',1,'Authorise internal stock requests');
INSERT INTO `weberp_scripts` VALUES ('InternalStockRequestFulfill.php',1,'Fulfill an internal stock request');
INSERT INTO `weberp_scripts` VALUES ('InventoryPlanning.php',2,'Creates a pdf report showing the last 4 months use of items including as a component of assemblies together with stock quantity on hand, current demand for the item and current quantity on sales order.');
INSERT INTO `weberp_scripts` VALUES ('InventoryPlanningPrefSupplier.php',2,'Produces a report showing the inventory to be ordered by supplier');
INSERT INTO `weberp_scripts` VALUES ('InventoryPlanningPrefSupplier_CSV.php',2,'Inventory planning spreadsheet');
INSERT INTO `weberp_scripts` VALUES ('InventoryQuantities.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('InventoryValuation.php',2,'Creates a pdf report showing the value of stock at standard cost for a range of product categories selected');
INSERT INTO `weberp_scripts` VALUES ('Labels.php',15,'Produces item pricing labels in a pdf from a range of selected criteria');
INSERT INTO `weberp_scripts` VALUES ('Locations.php',11,'Defines the inventory stocking locations or warehouses');
INSERT INTO `weberp_scripts` VALUES ('LocationUsers.php',15,'Allows users that have permission to access a location to be defined');
INSERT INTO `weberp_scripts` VALUES ('Logout.php',1,'Shows when the user logs out of webERP');
INSERT INTO `weberp_scripts` VALUES ('MailingGroupMaintenance.php',15,'Mainting mailing lists for items to mail');
INSERT INTO `weberp_scripts` VALUES ('MailInventoryValuation.php',1,'Meant to be run as a scheduled process to email the stock valuation off to a specified person. Creates the same stock valuation report as InventoryValuation.php');
INSERT INTO `weberp_scripts` VALUES ('MailSalesReport_csv.php',15,'Mailing the sales report');
INSERT INTO `weberp_scripts` VALUES ('MaintenanceReminders.php',1,'Sends email reminders for scheduled asset maintenance tasks');
INSERT INTO `weberp_scripts` VALUES ('MaintenanceTasks.php',1,'Allows set up and edit of scheduled maintenance tasks');
INSERT INTO `weberp_scripts` VALUES ('MaintenanceUserSchedule.php',1,'List users or managers scheduled maintenance tasks and allow to be flagged as completed');
INSERT INTO `weberp_scripts` VALUES ('Manufacturers.php',15,'Maintain brands of sales products');
INSERT INTO `weberp_scripts` VALUES ('MaterialsNotUsed.php',4,'Lists the items from Raw Material Categories not used in any BOM (thus, not used at all)');
INSERT INTO `weberp_scripts` VALUES ('MRP.php',9,'');
INSERT INTO `weberp_scripts` VALUES ('MRPCalendar.php',9,'');
INSERT INTO `weberp_scripts` VALUES ('MRPCreateDemands.php',9,'');
INSERT INTO `weberp_scripts` VALUES ('MRPDemands.php',9,'');
INSERT INTO `weberp_scripts` VALUES ('MRPDemandTypes.php',9,'');
INSERT INTO `weberp_scripts` VALUES ('MRPPlannedPurchaseOrders.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('MRPPlannedWorkOrders.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('MRPReport.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('MRPReschedules.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('MRPShortages.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('NoSalesItems.php',2,'Shows the No Selling (worst) items');
INSERT INTO `weberp_scripts` VALUES ('OffersReceived.php',4,'');
INSERT INTO `weberp_scripts` VALUES ('OrderDetails.php',1,'Shows the detail of a sales order');
INSERT INTO `weberp_scripts` VALUES ('OrderEntryDiscountPricing',13,'Not a script but an authority level marker - required if the user is allowed to enter discounts and special pricing against a customer order');
INSERT INTO `weberp_scripts` VALUES ('OutstandingGRNs.php',2,'Creates a pdf showing all GRNs for which there has been no purchase invoice matched off against.');
INSERT INTO `weberp_scripts` VALUES ('PageSecurity.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('PaymentAllocations.php',5,'');
INSERT INTO `weberp_scripts` VALUES ('PaymentMethods.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Payments.php',5,'Entry of bank account payments either against an AP account or a general ledger payment - if the AP-GL link in company preferences is set');
INSERT INTO `weberp_scripts` VALUES ('PaymentTerms.php',10,'Defines the payment terms records, these can be expressed as either a number of days credit or a day in the following month. All customers and suppliers must have a corresponding payment term recorded against their account');
INSERT INTO `weberp_scripts` VALUES ('PcAnalysis.php',15,'Creates an Excel with details of PC expnese for 24 months');
INSERT INTO `weberp_scripts` VALUES ('PcAssignCashToTab.php',6,'');
INSERT INTO `weberp_scripts` VALUES ('PcAuthorizeExpenses.php',6,'');
INSERT INTO `weberp_scripts` VALUES ('PcClaimExpensesFromTab.php',6,'');
INSERT INTO `weberp_scripts` VALUES ('PcExpenses.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('PcExpensesTypeTab.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('PcReportTab.php',6,'');
INSERT INTO `weberp_scripts` VALUES ('PcTabs.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('PcTypeTabs.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('PDFBankingSummary.php',3,'Creates a pdf showing the amounts entered as receipts on a specified date together with references for the purposes of banking');
INSERT INTO `weberp_scripts` VALUES ('PDFChequeListing.php',3,'Creates a pdf showing all payments that have been made from a specified bank account over a specified period. This can be emailed to an email account defined in config.php - ie a financial controller');
INSERT INTO `weberp_scripts` VALUES ('PDFCOA.php',0,'PDF of COA');
INSERT INTO `weberp_scripts` VALUES ('PDFCustomerList.php',2,'Creates a report of the customer and branch information held. This report has options to print only customer branches in a specified sales area and sales person. Additional option allows to list only those customers with activity either under or over a specified amount, since a specified date.');
INSERT INTO `weberp_scripts` VALUES ('PDFCustTransListing.php',3,'');
INSERT INTO `weberp_scripts` VALUES ('PDFDeliveryDifferences.php',3,'Creates a pdf report listing the delivery differences from what the customer requested as recorded in the order entry. The report calculates a percentage of order fill based on the number of orders filled in full on time');
INSERT INTO `weberp_scripts` VALUES ('PDFDIFOT.php',3,'Produces a pdf showing the delivery in full on time performance');
INSERT INTO `weberp_scripts` VALUES ('PDFFGLabel.php',11,'Produces FG Labels');
INSERT INTO `weberp_scripts` VALUES ('PDFGLJournal.php',15,'General Ledger Journal Print');
INSERT INTO `weberp_scripts` VALUES ('PDFGrn.php',2,'Produces a GRN report on the receipt of stock');
INSERT INTO `weberp_scripts` VALUES ('PDFLowGP.php',2,'Creates a pdf report showing the low gross profit sales made in the selected date range. The percentage of gp deemed acceptable can also be entered');
INSERT INTO `weberp_scripts` VALUES ('PDFOrdersInvoiced.php',3,'Produces a pdf of orders invoiced based on selected criteria');
INSERT INTO `weberp_scripts` VALUES ('PDFOrderStatus.php',3,'Reports on sales order status by date range, by stock location and stock category - producing a pdf showing each line items and any quantites delivered');
INSERT INTO `weberp_scripts` VALUES ('PDFPeriodStockTransListing.php',3,'Allows stock transactions of a specific transaction type to be listed over a single day or period range');
INSERT INTO `weberp_scripts` VALUES ('PDFPickingList.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('PDFPriceList.php',2,'Creates a pdf of the price list applicable to a given sales type and customer. Also allows the listing of prices specific to a customer');
INSERT INTO `weberp_scripts` VALUES ('PDFPrintLabel.php',10,'');
INSERT INTO `weberp_scripts` VALUES ('PDFProdSpec.php',0,'PDF OF Product Specification');
INSERT INTO `weberp_scripts` VALUES ('PDFQALabel.php',2,'Produces a QA label on receipt of stock');
INSERT INTO `weberp_scripts` VALUES ('PDFQuotation.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('PDFQuotationPortrait.php',2,'Portrait quotation');
INSERT INTO `weberp_scripts` VALUES ('PDFReceipt.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('PDFRemittanceAdvice.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('PDFSellThroughSupportClaim.php',9,'Reports the sell through support claims to be made against all suppliers for a given date range.');
INSERT INTO `weberp_scripts` VALUES ('PDFStockCheckComparison.php',2,'Creates a pdf comparing the quantites entered as counted at a given range of locations against the quantity stored as on hand as at the time a stock check was initiated.');
INSERT INTO `weberp_scripts` VALUES ('PDFStockLocTransfer.php',1,'Creates a stock location transfer docket for the selected location transfer reference number');
INSERT INTO `weberp_scripts` VALUES ('PDFStockNegatives.php',1,'Produces a pdf of the negative stocks by location');
INSERT INTO `weberp_scripts` VALUES ('PDFStockTransfer.php',2,'Produces a report for stock transfers');
INSERT INTO `weberp_scripts` VALUES ('PDFSuppTransListing.php',3,'');
INSERT INTO `weberp_scripts` VALUES ('PDFTestPlan.php',16,'PDF of Test Plan');
INSERT INTO `weberp_scripts` VALUES ('PDFTopItems.php',2,'Produces a pdf report of the top items sold');
INSERT INTO `weberp_scripts` VALUES ('PDFWOPrint.php',11,'Produces W/O Paperwork');
INSERT INTO `weberp_scripts` VALUES ('PeriodsInquiry.php',2,'Shows a list of all the system defined periods');
INSERT INTO `weberp_scripts` VALUES ('POReport.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('PO_AuthorisationLevels.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('PO_AuthoriseMyOrders.php',4,'');
INSERT INTO `weberp_scripts` VALUES ('PO_Header.php',4,'Entry of a purchase order header record - date, references buyer etc');
INSERT INTO `weberp_scripts` VALUES ('PO_Items.php',4,'Entry of a purchase order items - allows entry of items with lookup of currency cost from Purchasing Data previously entered also allows entry of nominal items against a general ledger code if the AP is integrated to the GL');
INSERT INTO `weberp_scripts` VALUES ('PO_OrderDetails.php',2,'Purchase order inquiry shows the quantity received and invoiced of purchase order items as well as the header information');
INSERT INTO `weberp_scripts` VALUES ('PO_PDFPurchOrder.php',2,'Creates a pdf of the selected purchase order for printing or email to one of the supplier contacts entered');
INSERT INTO `weberp_scripts` VALUES ('PO_SelectOSPurchOrder.php',2,'Shows the outstanding purchase orders for selecting with links to receive or modify the purchase order header and items');
INSERT INTO `weberp_scripts` VALUES ('PO_SelectPurchOrder.php',2,'Allows selection of any purchase order with links to the inquiry');
INSERT INTO `weberp_scripts` VALUES ('PriceMatrix.php',11,'Mantain stock prices according to quantity break and sales types');
INSERT INTO `weberp_scripts` VALUES ('Prices.php',9,'Entry of prices for a selected item also allows selection of sales type and currency for the price');
INSERT INTO `weberp_scripts` VALUES ('PricesBasedOnMarkUp.php',11,'');
INSERT INTO `weberp_scripts` VALUES ('PricesByCost.php',11,'Allows prices to be updated based on cost');
INSERT INTO `weberp_scripts` VALUES ('Prices_Customer.php',11,'Entry of prices for a selected item and selected customer/branch. The currency and sales type is defaulted from the customer\'s record');
INSERT INTO `weberp_scripts` VALUES ('PrintCheque.php',5,'');
INSERT INTO `weberp_scripts` VALUES ('PrintCustOrder.php',2,'Creates a pdf of the dispatch note - by default this is expected to be on two part pre-printed stationery to allow pickers to note discrepancies for the confirmer to update the dispatch at the time of invoicing');
INSERT INTO `weberp_scripts` VALUES ('PrintCustOrder_generic.php',2,'Creates two copies of a laser printed dispatch note - both copies need to be written on by the pickers with any discrepancies to advise customer of any shortfall and on the office copy to ensure the correct quantites are invoiced');
INSERT INTO `weberp_scripts` VALUES ('PrintCustStatements.php',2,'Creates a pdf for the customer statements in the selected range');
INSERT INTO `weberp_scripts` VALUES ('PrintCustTrans.php',1,'Creates either a html invoice or credit note or a pdf. A range of invoices or credit notes can be selected also.');
INSERT INTO `weberp_scripts` VALUES ('PrintCustTransPortrait.php',1,'');
INSERT INTO `weberp_scripts` VALUES ('PrintSalesOrder_generic.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('PrintWOItemSlip.php',4,'PDF WO Item production Slip ');
INSERT INTO `weberp_scripts` VALUES ('ProductSpecs.php',16,'Product Specification Maintenance');
INSERT INTO `weberp_scripts` VALUES ('PurchaseByPrefSupplier.php',2,'Purchase ordering by preferred supplier');
INSERT INTO `weberp_scripts` VALUES ('PurchData.php',4,'Entry of supplier purchasing data, the suppliers part reference and the suppliers currency cost of the item');
INSERT INTO `weberp_scripts` VALUES ('QATests.php',16,'Quality Test Maintenance');
INSERT INTO `weberp_scripts` VALUES ('RecurringSalesOrders.php',1,'');
INSERT INTO `weberp_scripts` VALUES ('RecurringSalesOrdersProcess.php',1,'Process Recurring Sales Orders');
INSERT INTO `weberp_scripts` VALUES ('RelatedItemsUpdate.php',2,'Maintains Related Items');
INSERT INTO `weberp_scripts` VALUES ('ReorderLevel.php',2,'Allows reorder levels of inventory to be updated');
INSERT INTO `weberp_scripts` VALUES ('ReorderLevelLocation.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('ReportCreator.php',13,'Report Writer and Form Creator script that creates templates for user defined reports and forms');
INSERT INTO `weberp_scripts` VALUES ('ReportMaker.php',1,'Produces reports from the report writer templates created');
INSERT INTO `weberp_scripts` VALUES ('reportwriter/admin/ReportCreator.php',15,'Report Writer');
INSERT INTO `weberp_scripts` VALUES ('ReprintGRN.php',11,'Allows selection of a goods received batch for reprinting the goods received note given a purchase order number');
INSERT INTO `weberp_scripts` VALUES ('ReverseGRN.php',11,'Reverses the entry of goods received - creating stock movements back out and necessary general ledger journals to effect the reversal');
INSERT INTO `weberp_scripts` VALUES ('RevisionTranslations.php',15,'Human revision for automatic descriptions translations');
INSERT INTO `weberp_scripts` VALUES ('SalesAnalReptCols.php',2,'Entry of the definition of a sales analysis report\'s columns.');
INSERT INTO `weberp_scripts` VALUES ('SalesAnalRepts.php',2,'Entry of the definition of a sales analysis report headers');
INSERT INTO `weberp_scripts` VALUES ('SalesAnalysis_UserDefined.php',2,'Creates a pdf of a selected user defined sales analysis report');
INSERT INTO `weberp_scripts` VALUES ('SalesByTypePeriodInquiry.php',2,'Shows sales for a selected date range by sales type/price list');
INSERT INTO `weberp_scripts` VALUES ('SalesCategories.php',11,'');
INSERT INTO `weberp_scripts` VALUES ('SalesCategoryDescriptions.php',15,'Maintain translations for sales categories');
INSERT INTO `weberp_scripts` VALUES ('SalesCategoryPeriodInquiry.php',2,'Shows sales for a selected date range by stock category');
INSERT INTO `weberp_scripts` VALUES ('SalesGLPostings.php',10,'Defines the general ledger accounts used to post sales to based on product categories and sales areas');
INSERT INTO `weberp_scripts` VALUES ('SalesGraph.php',6,'');
INSERT INTO `weberp_scripts` VALUES ('SalesInquiry.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('SalesPeople.php',3,'Defines the sales people of the business');
INSERT INTO `weberp_scripts` VALUES ('SalesTopCustomersInquiry.php',1,'Shows the top customers');
INSERT INTO `weberp_scripts` VALUES ('SalesTopItemsInquiry.php',2,'Shows the top item sales for a selected date range');
INSERT INTO `weberp_scripts` VALUES ('SalesTypes.php',15,'Defines the sales types - prices are held against sales types they can be considered price lists. Sales analysis records are held by sales type too.');
INSERT INTO `weberp_scripts` VALUES ('SecurityTokens.php',15,'Administration of security tokens');
INSERT INTO `weberp_scripts` VALUES ('SelectAsset.php',2,'Allows a fixed asset to be selected for modification or viewing');
INSERT INTO `weberp_scripts` VALUES ('SelectCompletedOrder.php',1,'Allows the selection of completed sales orders for inquiries - choices to select by item code or customer');
INSERT INTO `weberp_scripts` VALUES ('SelectContract.php',6,'Allows a contract costing to be selected for modification or viewing');
INSERT INTO `weberp_scripts` VALUES ('SelectCreditItems.php',3,'Entry of credit notes from scratch, selecting the items in either quick entry mode or searching for them manually');
INSERT INTO `weberp_scripts` VALUES ('SelectCustomer.php',2,'Selection of customer - from where all customer related maintenance, transactions and inquiries start');
INSERT INTO `weberp_scripts` VALUES ('SelectGLAccount.php',8,'Selection of general ledger account from where all general ledger account maintenance, or inquiries are initiated');
INSERT INTO `weberp_scripts` VALUES ('SelectOrderItems.php',1,'Entry of sales order items with both quick entry and part search functions');
INSERT INTO `weberp_scripts` VALUES ('SelectProduct.php',2,'Selection of items. All item maintenance, transactions and inquiries start with this script');
INSERT INTO `weberp_scripts` VALUES ('SelectQASamples.php',16,'Select  QA Samples');
INSERT INTO `weberp_scripts` VALUES ('SelectRecurringSalesOrder.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('SelectSalesOrder.php',2,'Selects a sales order irrespective of completed or not for inquiries');
INSERT INTO `weberp_scripts` VALUES ('SelectSupplier.php',2,'Selects a supplier. A supplier is required to be selected before any AP transactions and before any maintenance or inquiry of the supplier');
INSERT INTO `weberp_scripts` VALUES ('SelectWorkOrder.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('SellThroughSupport.php',9,'Defines the items, period and quantum of support for which supplier has agreed to provide.');
INSERT INTO `weberp_scripts` VALUES ('ShipmentCosting.php',11,'Shows the costing of a shipment with all the items invoice values and any shipment costs apportioned. Updating the shipment has an option to update standard costs of all items on the shipment and create any general ledger variance journals');
INSERT INTO `weberp_scripts` VALUES ('Shipments.php',11,'Entry of shipments from outstanding purchase orders for a selected supplier - changes in the delivery date will cascade into the different purchase orders on the shipment');
INSERT INTO `weberp_scripts` VALUES ('Shippers.php',15,'Defines the shipping methods available. Each customer branch has a default shipping method associated with it which must match a record from this table');
INSERT INTO `weberp_scripts` VALUES ('ShiptsList.php',2,'Shows a list of all the open shipments for a selected supplier. Linked from POItems.php');
INSERT INTO `weberp_scripts` VALUES ('Shipt_Select.php',11,'Selection of a shipment for displaying and modification or updating');
INSERT INTO `weberp_scripts` VALUES ('ShopParameters.php',15,'Maintain web-store configuration and set up');
INSERT INTO `weberp_scripts` VALUES ('SMTPServer.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('SpecialOrder.php',4,'Allows for a sales order to be created and an indent order to be created on a supplier for a one off item that may never be purchased again. A dummy part is created based on the description and cost details given.');
INSERT INTO `weberp_scripts` VALUES ('StockAdjustments.php',11,'Entry of quantity corrections to stocks in a selected location.');
INSERT INTO `weberp_scripts` VALUES ('StockAdjustmentsControlled.php',11,'Entry of batch references or serial numbers on controlled stock items being adjusted');
INSERT INTO `weberp_scripts` VALUES ('StockCategories.php',11,'Defines the stock categories. All items must refer to one of these categories. The category record also allows the specification of the general ledger codes where stock items are to be posted - the balance sheet account and the profit and loss effect of any adjustments and the profit and loss effect of any price variances');
INSERT INTO `weberp_scripts` VALUES ('StockCategorySalesInquiry.php',2,'Sales inquiry by stock category showing top items');
INSERT INTO `weberp_scripts` VALUES ('StockCheck.php',2,'Allows creation of a stock check file - copying the current quantites in stock for later comparison to the entered counts. Also produces a pdf for the count sheets.');
INSERT INTO `weberp_scripts` VALUES ('StockClone.php',11,'Script to copy a stock item and associated properties, image, price, purchase and cost data');
INSERT INTO `weberp_scripts` VALUES ('StockCostUpdate.php',9,'Allows update of the standard cost of items producing general ledger journals if the company preferences stock GL interface is active');
INSERT INTO `weberp_scripts` VALUES ('StockCounts.php',2,'Allows entry of stock counts');
INSERT INTO `weberp_scripts` VALUES ('StockDispatch.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('StockLocMovements.php',2,'Inquiry shows the Movements of all stock items for a specified location');
INSERT INTO `weberp_scripts` VALUES ('StockLocStatus.php',2,'Shows the stock on hand together with outstanding sales orders and outstanding purchase orders by stock location for all items in the selected stock category');
INSERT INTO `weberp_scripts` VALUES ('StockLocTransfer.php',11,'Entry of a bulk stock location transfer for many parts from one location to another.');
INSERT INTO `weberp_scripts` VALUES ('StockLocTransferReceive.php',11,'Effects the transfer and creates the stock movements for a bulk stock location transfer initiated from StockLocTransfer.php');
INSERT INTO `weberp_scripts` VALUES ('StockMovements.php',2,'Shows a list of all the stock movements for a selected item and stock location including the price at which they were sold in local currency and the price at which they were purchased for in local currency');
INSERT INTO `weberp_scripts` VALUES ('StockQties_csv.php',5,'Makes a comma separated values (CSV)file of the stock item codes and quantities');
INSERT INTO `weberp_scripts` VALUES ('StockQuantityByDate.php',2,'Shows the stock on hand for each item at a selected location and stock category as at a specified date');
INSERT INTO `weberp_scripts` VALUES ('StockReorderLevel.php',4,'Entry and review of the re-order level of items by stocking location');
INSERT INTO `weberp_scripts` VALUES ('Stocks.php',11,'Defines an item - maintenance and addition of new parts');
INSERT INTO `weberp_scripts` VALUES ('StockSerialItemResearch.php',3,'');
INSERT INTO `weberp_scripts` VALUES ('StockSerialItems.php',2,'Shows a list of the serial numbers or the batch references and quantities of controlled items. This inquiry is linked from the stock status inquiry');
INSERT INTO `weberp_scripts` VALUES ('StockStatus.php',2,'Shows the stock on hand together with outstanding sales orders and outstanding purchase orders by stock location for a selected part. Has a link to show the serial numbers in stock at the location selected if the item is controlled');
INSERT INTO `weberp_scripts` VALUES ('StockTransferControlled.php',11,'Entry of serial numbers/batch references for controlled items being received on a stock transfer. The script is used by both bulk transfers and point to point transfers');
INSERT INTO `weberp_scripts` VALUES ('StockTransfers.php',11,'Entry of point to point stock location transfers of a single part');
INSERT INTO `weberp_scripts` VALUES ('StockUsage.php',2,'Inquiry showing the quantity of stock used by period calculated from the sum of the stock movements over that period - by item and stock location. Also available over all locations');
INSERT INTO `weberp_scripts` VALUES ('StockUsageGraph.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('SuppContractChgs.php',5,'');
INSERT INTO `weberp_scripts` VALUES ('SuppCreditGRNs.php',5,'Entry of a supplier credit notes (debit notes) against existing GRN which have already been matched in full or in part');
INSERT INTO `weberp_scripts` VALUES ('SuppFixedAssetChgs.php',5,'');
INSERT INTO `weberp_scripts` VALUES ('SuppInvGRNs.php',5,'Entry of supplier invoices against goods received');
INSERT INTO `weberp_scripts` VALUES ('SupplierAllocations.php',5,'Entry of allocations of supplier payments and credit notes to invoices');
INSERT INTO `weberp_scripts` VALUES ('SupplierBalsAtPeriodEnd.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('SupplierContacts.php',5,'Entry of supplier contacts and contact details including email addresses');
INSERT INTO `weberp_scripts` VALUES ('SupplierCredit.php',5,'Entry of supplier credit notes (debit notes)');
INSERT INTO `weberp_scripts` VALUES ('SupplierInquiry.php',2,'Inquiry showing invoices, credit notes and payments made to suppliers together with the amounts outstanding');
INSERT INTO `weberp_scripts` VALUES ('SupplierInvoice.php',5,'Entry of supplier invoices');
INSERT INTO `weberp_scripts` VALUES ('SupplierPriceList.php',4,'Maintain Supplier Price Lists');
INSERT INTO `weberp_scripts` VALUES ('Suppliers.php',5,'Entry of new suppliers and maintenance of existing suppliers');
INSERT INTO `weberp_scripts` VALUES ('SupplierTenderCreate.php',4,'Create or Edit tenders');
INSERT INTO `weberp_scripts` VALUES ('SupplierTenders.php',9,'');
INSERT INTO `weberp_scripts` VALUES ('SupplierTransInquiry.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('SupplierTypes.php',4,'');
INSERT INTO `weberp_scripts` VALUES ('SuppLoginSetup.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('SuppPaymentRun.php',5,'Automatic creation of payment records based on calculated amounts due from AP invoices entered');
INSERT INTO `weberp_scripts` VALUES ('SuppPriceList.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('SuppShiptChgs.php',5,'Entry of supplier invoices against shipments as charges against a shipment');
INSERT INTO `weberp_scripts` VALUES ('SuppTransGLAnalysis.php',5,'Entry of supplier invoices against general ledger codes');
INSERT INTO `weberp_scripts` VALUES ('SuppWhereAlloc.php',3,'Suppliers Where allocated');
INSERT INTO `weberp_scripts` VALUES ('SystemParameters.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Tax.php',2,'Creates a report of the ad-valoerm tax - GST/VAT - for the period selected from accounts payable and accounts receivable data');
INSERT INTO `weberp_scripts` VALUES ('TaxAuthorities.php',15,'Entry of tax authorities - the state intitutions that charge tax');
INSERT INTO `weberp_scripts` VALUES ('TaxAuthorityRates.php',11,'Entry of the rates of tax applicable to the tax authority depending on the item tax level');
INSERT INTO `weberp_scripts` VALUES ('TaxCategories.php',15,'Allows for categories of items to be defined that might have different tax rates applied to them');
INSERT INTO `weberp_scripts` VALUES ('TaxGroups.php',15,'Allows for taxes to be grouped together where multiple taxes might apply on sale or purchase of items');
INSERT INTO `weberp_scripts` VALUES ('TaxProvinces.php',15,'Allows for inventory locations to be defined so that tax applicable from sales in different provinces can be dealt with');
INSERT INTO `weberp_scripts` VALUES ('TestPlanResults.php',16,'Test Plan Results Entry');
INSERT INTO `weberp_scripts` VALUES ('TopItems.php',2,'Shows the top selling items');
INSERT INTO `weberp_scripts` VALUES ('UnitsOfMeasure.php',15,'Allows for units of measure to be defined');
INSERT INTO `weberp_scripts` VALUES ('UpgradeDatabase.php',15,'Allows for the database to be automatically upgraded based on currently recorded DBUpgradeNumber config option');
INSERT INTO `weberp_scripts` VALUES ('UserBankAccounts.php',15,'Maintains table bankaccountusers (Authorized users to work with a bank account in webERP)');
INSERT INTO `weberp_scripts` VALUES ('UserGLAccounts.php',15,'Maintenance of GL Accounts allowed for a user');
INSERT INTO `weberp_scripts` VALUES ('UserLocations.php',15,'Location User Maintenance');
INSERT INTO `weberp_scripts` VALUES ('UserSettings.php',1,'Allows the user to change system wide defaults for the theme - appearance, the number of records to show in searches and the language to display messages in');
INSERT INTO `weberp_scripts` VALUES ('WhereUsedInquiry.php',2,'Inquiry showing where an item is used ie all the parents where the item is a component of');
INSERT INTO `weberp_scripts` VALUES ('WOCanBeProducedNow.php',4,'List of WO items that can be produced with available stock in location');
INSERT INTO `weberp_scripts` VALUES ('WorkCentres.php',9,'Defines the various centres of work within a manufacturing company. Also the overhead and labour rates applicable to the work centre and its standard capacity');
INSERT INTO `weberp_scripts` VALUES ('WorkOrderCosting.php',11,'');
INSERT INTO `weberp_scripts` VALUES ('WorkOrderEntry.php',10,'Entry of new work orders');
INSERT INTO `weberp_scripts` VALUES ('WorkOrderIssue.php',11,'Issue of materials to a work order');
INSERT INTO `weberp_scripts` VALUES ('WorkOrderReceive.php',11,'Allows for receiving of works orders');
INSERT INTO `weberp_scripts` VALUES ('WorkOrderStatus.php',11,'Shows the status of works orders');
INSERT INTO `weberp_scripts` VALUES ('WOSerialNos.php',10,'');
INSERT INTO `weberp_scripts` VALUES ('WWW_Access.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('WWW_Users.php',15,'Entry of users and security settings of users');
INSERT INTO `weberp_scripts` VALUES ('Z_BottomUpCosts.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_ChangeBranchCode.php',15,'Utility to change the branch code of a customer that cascades the change through all the necessary tables');
INSERT INTO `weberp_scripts` VALUES ('Z_ChangeCustomerCode.php',15,'Utility to change a customer code that cascades the change through all the necessary tables');
INSERT INTO `weberp_scripts` VALUES ('Z_ChangeGLAccountCode.php',15,'Script to change a GL account code accross all tables necessary');
INSERT INTO `weberp_scripts` VALUES ('Z_ChangeLocationCode.php',15,'Change a locations code and in all tables where the old code was used to the new code');
INSERT INTO `weberp_scripts` VALUES ('Z_ChangeStockCategory.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_ChangeStockCode.php',15,'Utility to change an item code that cascades the change through all the necessary tables');
INSERT INTO `weberp_scripts` VALUES ('Z_ChangeSupplierCode.php',15,'Script to change a supplier code accross all tables necessary');
INSERT INTO `weberp_scripts` VALUES ('Z_CheckAllocationsFrom.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_CheckAllocs.php',2,'');
INSERT INTO `weberp_scripts` VALUES ('Z_CheckDebtorsControl.php',15,'Inquiry that shows the total local currency (functional currency) balance of all customer accounts to reconcile with the general ledger debtors account');
INSERT INTO `weberp_scripts` VALUES ('Z_CheckGLTransBalance.php',15,'Checks all GL transactions balance and reports problem ones');
INSERT INTO `weberp_scripts` VALUES ('Z_CreateChartDetails.php',9,'Utility page to create chart detail records for all general ledger accounts and periods created - needs expert assistance in use');
INSERT INTO `weberp_scripts` VALUES ('Z_CreateCompany.php',15,'Utility to insert company number 1 if not already there - actually only company 1 is used - the system is not multi-company');
INSERT INTO `weberp_scripts` VALUES ('Z_CreateCompanyTemplateFile.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_CurrencyDebtorsBalances.php',15,'Inquiry that shows the total foreign currency together with the total local currency (functional currency) balances of all customer accounts to reconcile with the general ledger debtors account');
INSERT INTO `weberp_scripts` VALUES ('Z_CurrencySuppliersBalances.php',15,'Inquiry that shows the total foreign currency amounts and also the local currency (functional currency) balances of all supplier accounts to reconcile with the general ledger creditors account');
INSERT INTO `weberp_scripts` VALUES ('Z_DataExport.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_DeleteCreditNote.php',15,'Utility to reverse a customer credit note - a desperate measure that should not be used except in extreme circumstances');
INSERT INTO `weberp_scripts` VALUES ('Z_DeleteInvoice.php',15,'Utility to reverse a customer invoice - a desperate measure that should not be used except in extreme circumstances');
INSERT INTO `weberp_scripts` VALUES ('Z_DeleteOldPrices.php',15,'Deletes all old prices');
INSERT INTO `weberp_scripts` VALUES ('Z_DeleteSalesTransActions.php',15,'Utility to delete all sales transactions, sales analysis the lot! Extreme care required!!!');
INSERT INTO `weberp_scripts` VALUES ('Z_DescribeTable.php',11,'');
INSERT INTO `weberp_scripts` VALUES ('Z_ImportChartOfAccounts.php',11,'');
INSERT INTO `weberp_scripts` VALUES ('Z_ImportDebtors.php',15,'Import debtors by csv file');
INSERT INTO `weberp_scripts` VALUES ('Z_ImportFixedAssets.php',15,'Allow fixed assets to be imported from a csv');
INSERT INTO `weberp_scripts` VALUES ('Z_ImportGLAccountGroups.php',11,'');
INSERT INTO `weberp_scripts` VALUES ('Z_ImportGLAccountSections.php',11,'');
INSERT INTO `weberp_scripts` VALUES ('Z_ImportGLTransactions.php',15,'Import General Ledger Transactions');
INSERT INTO `weberp_scripts` VALUES ('Z_ImportPartCodes.php',11,'Allows inventory items to be imported from a csv');
INSERT INTO `weberp_scripts` VALUES ('Z_ImportPriceList.php',15,'Loads a new price list from a csv file');
INSERT INTO `weberp_scripts` VALUES ('Z_ImportStocks.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_ImportSuppliers.php',15,'Import suppliers by csv file');
INSERT INTO `weberp_scripts` VALUES ('Z_index.php',15,'Utility menu page');
INSERT INTO `weberp_scripts` VALUES ('Z_ItemsWithoutPicture.php',15,'Shows the list of curent items without picture in webERP');
INSERT INTO `weberp_scripts` VALUES ('Z_MakeLocUsers.php',15,'Create User Location records');
INSERT INTO `weberp_scripts` VALUES ('Z_MakeNewCompany.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_MakeStockLocns.php',15,'Utility to make LocStock records for all items and locations if not already set up.');
INSERT INTO `weberp_scripts` VALUES ('Z_poAddLanguage.php',15,'Allows a new language po file to be created');
INSERT INTO `weberp_scripts` VALUES ('Z_poAdmin.php',15,'Allows for a gettext language po file to be administered');
INSERT INTO `weberp_scripts` VALUES ('Z_poEditLangHeader.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_poEditLangModule.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_poEditLangRemaining.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_poRebuildDefault.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_PriceChanges.php',15,'Utility to make bulk pricing alterations to selected sales type price lists or selected customer prices only');
INSERT INTO `weberp_scripts` VALUES ('Z_ReApplyCostToSA.php',15,'Utility to allow the sales analysis table to be updated with the latest cost information - the sales analysis takes the cost at the time the sale was made to reconcile with the enteries made in the gl.');
INSERT INTO `weberp_scripts` VALUES ('Z_RePostGLFromPeriod.php',15,'Utility to repost all general ledger transaction commencing from a specified period. This can take some time in busy environments. Normally GL transactions are posted automatically each time a trial balance or profit and loss account is run');
INSERT INTO `weberp_scripts` VALUES ('Z_ReverseSuppPaymentRun.php',15,'Utility to reverse an entire Supplier payment run');
INSERT INTO `weberp_scripts` VALUES ('Z_SalesIntegrityCheck.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_UpdateChartDetailsBFwd.php',15,'Utility to recalculate the ChartDetails table B/Fwd balances - extreme care!!');
INSERT INTO `weberp_scripts` VALUES ('Z_UpdateItemCosts.php',15,'Use CSV of item codes and costs to update webERP item costs');
INSERT INTO `weberp_scripts` VALUES ('Z_UpdateSalesAnalysisWithLatestCustomerData.php',15,'Updates the salesanalysis table with the latest data from the customer debtorsmaster salestype and custbranch sales area and sales person irrespective of the sales type, area, salesperson at the time when the sale was made');
INSERT INTO `weberp_scripts` VALUES ('Z_Upgrade3.10.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_Upgrade_3.01-3.02.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_Upgrade_3.04-3.05.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_Upgrade_3.05-3.06.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_Upgrade_3.07-3.08.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_Upgrade_3.08-3.09.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_Upgrade_3.09-3.10.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_Upgrade_3.10-3.11.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_Upgrade_3.11-4.00.php',15,'');
INSERT INTO `weberp_scripts` VALUES ('Z_UploadForm.php',15,'Utility to upload a file to a remote server');
INSERT INTO `weberp_scripts` VALUES ('Z_UploadResult.php',15,'Utility to upload a file to a remote server');

--
-- Dumping data for table `securitygroups`
--

INSERT INTO `weberp_securitygroups` VALUES (1,0);
INSERT INTO `weberp_securitygroups` VALUES (1,1);
INSERT INTO `weberp_securitygroups` VALUES (1,2);
INSERT INTO `weberp_securitygroups` VALUES (1,5);
INSERT INTO `weberp_securitygroups` VALUES (2,0);
INSERT INTO `weberp_securitygroups` VALUES (2,1);
INSERT INTO `weberp_securitygroups` VALUES (2,2);
INSERT INTO `weberp_securitygroups` VALUES (2,11);
INSERT INTO `weberp_securitygroups` VALUES (3,0);
INSERT INTO `weberp_securitygroups` VALUES (3,1);
INSERT INTO `weberp_securitygroups` VALUES (3,2);
INSERT INTO `weberp_securitygroups` VALUES (3,3);
INSERT INTO `weberp_securitygroups` VALUES (3,4);
INSERT INTO `weberp_securitygroups` VALUES (3,5);
INSERT INTO `weberp_securitygroups` VALUES (3,11);
INSERT INTO `weberp_securitygroups` VALUES (4,0);
INSERT INTO `weberp_securitygroups` VALUES (4,1);
INSERT INTO `weberp_securitygroups` VALUES (4,2);
INSERT INTO `weberp_securitygroups` VALUES (4,5);
INSERT INTO `weberp_securitygroups` VALUES (5,0);
INSERT INTO `weberp_securitygroups` VALUES (5,1);
INSERT INTO `weberp_securitygroups` VALUES (5,2);
INSERT INTO `weberp_securitygroups` VALUES (5,3);
INSERT INTO `weberp_securitygroups` VALUES (5,11);
INSERT INTO `weberp_securitygroups` VALUES (6,0);
INSERT INTO `weberp_securitygroups` VALUES (6,1);
INSERT INTO `weberp_securitygroups` VALUES (6,2);
INSERT INTO `weberp_securitygroups` VALUES (6,3);
INSERT INTO `weberp_securitygroups` VALUES (6,4);
INSERT INTO `weberp_securitygroups` VALUES (6,5);
INSERT INTO `weberp_securitygroups` VALUES (6,6);
INSERT INTO `weberp_securitygroups` VALUES (6,7);
INSERT INTO `weberp_securitygroups` VALUES (6,8);
INSERT INTO `weberp_securitygroups` VALUES (6,9);
INSERT INTO `weberp_securitygroups` VALUES (6,10);
INSERT INTO `weberp_securitygroups` VALUES (6,11);
INSERT INTO `weberp_securitygroups` VALUES (7,0);
INSERT INTO `weberp_securitygroups` VALUES (7,1);
INSERT INTO `weberp_securitygroups` VALUES (8,0);
INSERT INTO `weberp_securitygroups` VALUES (8,1);
INSERT INTO `weberp_securitygroups` VALUES (8,2);
INSERT INTO `weberp_securitygroups` VALUES (8,3);
INSERT INTO `weberp_securitygroups` VALUES (8,4);
INSERT INTO `weberp_securitygroups` VALUES (8,5);
INSERT INTO `weberp_securitygroups` VALUES (8,6);
INSERT INTO `weberp_securitygroups` VALUES (8,7);
INSERT INTO `weberp_securitygroups` VALUES (8,8);
INSERT INTO `weberp_securitygroups` VALUES (8,9);
INSERT INTO `weberp_securitygroups` VALUES (8,10);
INSERT INTO `weberp_securitygroups` VALUES (8,11);
INSERT INTO `weberp_securitygroups` VALUES (8,12);
INSERT INTO `weberp_securitygroups` VALUES (8,13);
INSERT INTO `weberp_securitygroups` VALUES (8,14);
INSERT INTO `weberp_securitygroups` VALUES (8,15);
INSERT INTO `weberp_securitygroups` VALUES (8,16);
INSERT INTO `weberp_securitygroups` VALUES (9,0);
INSERT INTO `weberp_securitygroups` VALUES (9,9);

--
-- Dumping data for table `securitytokens`
--

INSERT INTO `weberp_securitytokens` VALUES (0,'Main Index Page');
INSERT INTO `weberp_securitytokens` VALUES (1,'Order Entry/Inquiries customer access only');
INSERT INTO `weberp_securitytokens` VALUES (2,'Basic Reports and Inquiries with selection options');
INSERT INTO `weberp_securitytokens` VALUES (3,'Credit notes and AR management');
INSERT INTO `weberp_securitytokens` VALUES (4,'Purchasing data/PO Entry/Reorder Levels');
INSERT INTO `weberp_securitytokens` VALUES (5,'Accounts Payable');
INSERT INTO `weberp_securitytokens` VALUES (6,'Petty Cash');
INSERT INTO `weberp_securitytokens` VALUES (7,'Bank Reconciliations');
INSERT INTO `weberp_securitytokens` VALUES (8,'General ledger reports/inquiries');
INSERT INTO `weberp_securitytokens` VALUES (9,'Supplier centre - Supplier access only');
INSERT INTO `weberp_securitytokens` VALUES (10,'General Ledger Maintenance, stock valuation & Configuration');
INSERT INTO `weberp_securitytokens` VALUES (11,'Inventory Management and Pricing');
INSERT INTO `weberp_securitytokens` VALUES (12,'Prices Security');
INSERT INTO `weberp_securitytokens` VALUES (13,'Customer services Price modifications');
INSERT INTO `weberp_securitytokens` VALUES (14,'Unknown');
INSERT INTO `weberp_securitytokens` VALUES (15,'User Management and System Administration');
INSERT INTO `weberp_securitytokens` VALUES (16,'QA');
INSERT INTO `weberp_securitytokens` VALUES (18,'Cost authority');

--
-- Dumping data for table `securityroles`
--

INSERT INTO `weberp_securityroles` VALUES (1,'Inquiries/Order Entry');
INSERT INTO `weberp_securityroles` VALUES (2,'Manufac/Stock Admin');
INSERT INTO `weberp_securityroles` VALUES (3,'Purchasing Officer');
INSERT INTO `weberp_securityroles` VALUES (4,'AP Clerk');
INSERT INTO `weberp_securityroles` VALUES (5,'AR Clerk');
INSERT INTO `weberp_securityroles` VALUES (6,'Accountant');
INSERT INTO `weberp_securityroles` VALUES (7,'Customer Log On Only');
INSERT INTO `weberp_securityroles` VALUES (8,'System Administrator');
INSERT INTO `weberp_securityroles` VALUES (9,'Supplier Log On Only');

--
-- Dumping data for table `accountsection`
--

INSERT INTO `weberp_accountsection` VALUES (1,'Income');
INSERT INTO `weberp_accountsection` VALUES (2,'Cost Of Sales');
INSERT INTO `weberp_accountsection` VALUES (5,'Overheads');
INSERT INTO `weberp_accountsection` VALUES (10,'Fixed Assets');
INSERT INTO `weberp_accountsection` VALUES (15,'Inventory');
INSERT INTO `weberp_accountsection` VALUES (20,'Amounts Receivable');
INSERT INTO `weberp_accountsection` VALUES (25,'Cash');
INSERT INTO `weberp_accountsection` VALUES (30,'Amounts Payable');
INSERT INTO `weberp_accountsection` VALUES (50,'Financed By');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-05-16 21:37:02
SET FOREIGN_KEY_CHECKS = 1;
UPDATE weberp_systypes SET typeno=0;
INSERT INTO weberp_shippers VALUES (1,'Default Shipper',0);
UPDATE weberp_config SET confvalue='1' WHERE confname='Default_Shipper';
