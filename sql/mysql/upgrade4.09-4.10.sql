INSERT INTO weberp_config VALUES('ExchangeRateFeed','ECB');
ALTER TABLE `weberp_salesorders` ADD `salesperson` VARCHAR( 4 ) NOT NULL , ADD INDEX ( `salesperson` );
ALTER TABLE `weberp_salesman` CHANGE `salesmancode` `salesmancode` VARCHAR( 4 ) NOT NULL DEFAULT '';
ALTER TABLE `weberp_salesorderdetails` DROP `commissionrate`;
ALTER TABLE `weberp_salesorderdetails` DROP `commissionearned`;
INSERT INTO weberp_scripts VALUES ('CounterReturns.php','5','Allows credits and refunds from the default Counter Sale account for an inventory location');
ALTER TABLE weberp_purchorders MODIFY `initiator` VARCHAR(20);
INSERT INTO `weberp_scripts` (`script` , `pagesecurity` , `description`)
VALUES ('OrderEntryDiscountPricing', '13', 'Not a script but an authority level marker - required if the user is allowed to enter discounts against a customer order'
);
ALTER TABLE `weberp_gltrans` ADD INDEX ( `tag` );
INSERT INTO weberp_scripts VALUES ('CustomerPurchases.php','5','Shows the purchases a customer has made.');
INSERT INTO weberp_scripts VALUES ('GoodsReceivedNotInvoiced.php','2','Shows the list of goods received but not yet invoiced, both in supplier currency and home currency. Total in home curency should match the GL Account for Goods received not invoiced. Any discrepancy is due to multicurrency errors.');
INSERT INTO weberp_scripts VALUES ('Z_ItemsWithoutPicture.php','15','Shows the list of curent items without picture in webERP');

CREATE TABLE weberp_IF NOT EXISTS `supplierdiscounts` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


CREATE TABLE weberp_IF NOT EXISTS `sellthroughsupport` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

ALTER TABLE weberp_cogsglpostings MODIFY `area` char(3) NOT NULL DEFAULT '';

INSERT INTO weberp_scripts VALUES ('MaterialsNotUsed.php',  '4',  'Lists the items from Raw Material Categories not used in any BOM (thus, not used at all)');
INSERT INTO weberp_scripts VALUES ('SellThroughSupport.php',  '9',  'Defines the items, period and quantum of support for which supplier has agreed to provide.');
INSERT INTO weberp_scripts VALUES ('PDFSellThroughSupportClaim.php',  '9',  'Reports the sell through support claims to be made against all suppliers for a given date range.');
ALTER TABLE `weberp_locstock` ADD `bin` VARCHAR( 10 ) NOT NULL , ADD INDEX ( `bin` );
INSERT INTO weberp_scripts VALUES ('Z_ImportPriceList.php',  '15',  'Loads a new price list from a csv file');

ALTER TABLE `weberp_debtortrans` ADD `packages` INT NOT NULL DEFAULT '1' COMMENT 'number of cartons';





UPDATE config SET confvalue='4.10.1' WHERE confname='VersionNumber';
