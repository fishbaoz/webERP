INSERT INTO weberp_scripts VALUES ('Z_DeleteOldPrices.php','15','Deletes all old prices');
INSERT INTO weberp_scripts VALUES ('Z_ChangeLocationCode.php','15','Change a locations code and in all tables where the old code was used to the new code');

CREATE TABLE weberp_IF NOT EXISTS `internalstockcatrole` (
  `categoryid` varchar(6) NOT NULL,
  `secroleid` int(11) NOT NULL,
  KEY `internalstockcatrole_ibfk_1` (`categoryid`),
  KEY `internalstockcatrole_ibfk_2` (`secroleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO weberp_scripts VALUES ('InternalStockCategoriesByRole.php','15','Maintains the stock categories to be used as internal for any user security role');

ALTER TABLE weberp_ `locations` ADD  `internalrequest` TINYINT( 4 ) NOT NULL DEFAULT  '1' COMMENT  'Allow (1) or not (0) internal request from this location';
ALTER TABLE weberp_ `loctransfers` CHANGE  `shipdate`  `shipdate` DATETIME NOT NULL DEFAULT  '0000-00-00 00:00:00';
ALTER TABLE weberp_ `loctransfers` CHANGE  `recdate`  `recdate` DATETIME NOT NULL DEFAULT  '0000-00-00 00:00:00';

INSERT INTO weberp_scripts VALUES ('GLJournalInquiry.php','15','General Ledger Journal Inquiry');
INSERT INTO weberp_scripts VALUES ('PDFGLJournal.php','15','General Ledger Journal Print');

ALTER TABLE weberp_ `www_users` ADD  `department` INT( 11 ) NOT NULL DEFAULT  '0';
INSERT INTO weberp_config VALUES('WorkingDaysWeek','5');

ALTER TABLE `weberp_suppliers` CHANGE `address6` `address6` VARCHAR( 40 ) NOT NULL DEFAULT '';
ALTER TABLE `weberp_custbranch` CHANGE `braddress6` `braddress6` VARCHAR( 40 ) NOT NULL DEFAULT '';
ALTER TABLE `weberp_debtorsmaster` CHANGE `address6` `address6` VARCHAR( 40 ) NOT NULL DEFAULT '';

ALTER TABLE `weberp_stockcatproperties` ADD FOREIGN KEY (`categoryid`) REFERENCES `stockcategory` (`categoryid`);
ALTER TABLE `weberp_stockitemproperties` ADD FOREIGN KEY (`stockid`) REFERENCES `stockmaster` (`stockid`);
ALTER TABLE `weberp_stockitemproperties` ADD FOREIGN KEY (`stkcatpropid`) REFERENCES `stockcatproperties` (`stkcatpropid`); 
ALTER TABLE `weberp_stockmovestaxes` ADD FOREIGN KEY (`stkmoveno`) REFERENCES `stockmoves` (`stkmoveno`);
ALTER TABLE `weberp_stockrequest` ADD INDEX (`loccode`);
ALTER TABLE `weberp_stockrequest` ADD FOREIGN KEY (`loccode`) REFERENCES `locations` (`loccode`);
ALTER TABLE `weberp_stockrequest` ADD INDEX (`departmentid`);
ALTER TABLE `weberp_stockrequest` ADD FOREIGN KEY (`departmentid`) REFERENCES `departments` (`departmentid`);
ALTER TABLE `weberp_stockrequestitems` ADD PRIMARY KEY ( `dispatchitemsid` );
ALTER TABLE `weberp_stockrequestitems` ADD INDEX ( `dispatchid` );
ALTER TABLE `weberp_stockrequestitems` ADD INDEX ( `stockid` );
ALTER TABLE `weberp_stockrequestitems` ADD FOREIGN KEY ( `dispatchid` ) REFERENCES `stockrequest` (`dispatchid`);
ALTER TABLE `weberp_stockrequestitems` ADD FOREIGN KEY ( `stockid` ) REFERENCES `stockmaster` (`stockid`);
ALTER TABLE `weberp_internalstockcatrole` ADD PRIMARY KEY ( `categoryid` , `secroleid` );
ALTER TABLE `weberp_internalstockcatrole` ADD FOREIGN KEY ( `categoryid` ) REFERENCES `stockcategory` (`categoryid`);
ALTER TABLE `weberp_internalstockcatrole` ADD FOREIGN KEY ( `secroleid` ) REFERENCES `securityroles` (`secroleid`);
 
INSERT INTO weberp_scripts VALUES ('PDFQuotationPortrait.php','2','Portrait quotation');

UPDATE config SET confvalue='4.09' WHERE confname='VersionNumber';

