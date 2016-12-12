CREATE TABLE `weberp_mrpdemandtypes` (
  `mrpdemandtype` varchar(6) NOT NULL default '',
  `description` char(30) NOT NULL default '',
  PRIMARY KEY  (`mrpdemandtype`),
  KEY `mrpdemandtype` (`mrpdemandtype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `weberp_mrpdemands` (
  `demandid` int(11) NOT NULL AUTO_INCREMENT,
  `stockid` varchar(20) NOT NULL default '',
  `mrpdemandtype` varchar(6) NOT NULL default '',
  `quantity` double NOT NULL default '0',
  `duedate` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`demandid`),
  KEY `StockID` (`stockid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE weberp_mrpdemands ADD CONSTRAINT `mrpdemands_ibfk_1` FOREIGN KEY (`mrpdemandtype`) REFERENCES `mrpdemandtypes` (`mrpdemandtype`);
ALTER TABLE weberp_mrpdemands ADD CONSTRAINT `mrpdemands_ibfk_2` FOREIGN KEY (`stockid`) REFERENCES `stockmaster` (`stockid`);

ALTER TABLE `weberp_stockmaster` ADD `pansize` double NOT NULL default '0',
  						  ADD `shrinkfactor` double NOT NULL default '0';
  
CREATE TABLE `weberp_mrpcalendar` (
	calendardate date NOT NULL,
	daynumber int(6) NOT NULL,
	manufacturingflag smallint(6) NOT NULL default '1',
	INDEX (daynumber),
	PRIMARY KEY (calendardate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO weberp_mrpdemandtypes (mrpdemandtype,description) VALUES ('FOR','Forecast');

ALTER TABLE `weberp_geocode_param` add PRIMARY KEY (`geocodeid`);
ALTER TABLE `weberp_geocode_param` CHANGE `geocodeid` `geocodeid` TINYINT( 4 ) NOT NULL AUTO_INCREMENT;
CREATE UNIQUE INDEX factor_name ON factorcompanies (coyname);
INSERT INTO `weberp_factorcompanies` ( `id` , `coyname` ) VALUES (null, 'None');
  
ALTER TABLE weberp_bankaccounts ADD COLUMN `currcode` char(3) NOT NULL;
ALTER TABLE `weberp_custcontacts` CHANGE `role` `role` VARCHAR( 40 ) NOT NULL;

ALTER TABLE `weberp_custcontacts` CHANGE `phoneno` `phoneno` VARCHAR( 20 ) NOT NULL;
ALTER TABLE `weberp_custcontacts` CHANGE `notes` `notes` VARCHAR( 255 ) NOT NULL;
UPDATE `purchdata` SET `effectivefrom`=NOW() WHERE `effectivefrom`='0000-00-00';
ALTER TABLE `weberp_purchdata` DROP PRIMARY KEY;
ALTER TABLE `weberp_purchdata` ADD PRIMARY KEY (`supplierno`,`stockid`, `effectivefrom`); 
ALTER TABLE `weberp_salesorders` ADD `quotedate` date NOT NULL default '0000-00-00';
ALTER TABLE `weberp_salesorders` ADD `confirmeddate` date NOT NULL default '0000-00-00';
CREATE TABLE `weberp_woserialnos` (
	`wo` INT NOT NULL ,
	`stockid` VARCHAR( 20 ) NOT NULL ,
	`serialno` VARCHAR( 30 ) NOT NULL ,
	`quantity` DOUBLE NOT NULL DEFAULT '1',
	`qualitytext` TEXT NOT NULL,
	 PRIMARY KEY (`wo`,`stockid`,`serialno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO weberp_config (confname, confvalue) VALUES ('AutoCreateWOs',1);
INSERT INTO weberp_config (confname, confvalue) VALUES ('DefaultFactoryLocation','MEL');
INSERT INTO weberp_config (confname, confvalue) VALUES ('FactoryManagerEmail','manager@company.com');
INSERT INTO weberp_config (`confname`,`confvalue`) VALUES ('DefineControlledOnWOEntry', '1');
ALTER TABLE `weberp_stockmaster` ADD `nextserialno` BIGINT NOT NULL DEFAULT '0';
ALTER TABLE `weberp_salesorders` CHANGE `orderno` `orderno` INT( 11 ) NOT NULL;
ALTER TABLE `weberp_stockserialitems` ADD `qualitytext` TEXT NOT NULL;

CREATE TABLE `weberp_purchorderauth` (
	`userid` varchar(20) NOT NULL DEFAULT '',
	`currabrev` char(3) NOT NULL DEFAULT '',
	`cancreate` smallint(2) NOT NULL DEFAULT 0,
	`authlevel` int(11) NOT NULL DEFAULT 0,
	PRIMARY KEY (`userid`,`currabrev`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `weberp_purchorders` ADD `version` decimal(3,2) NOT NULL default '1.00';
ALTER TABLE `weberp_purchorders` ADD `revised` date NOT NULL default '0000-00-00';
ALTER TABLE `weberp_purchorders` ADD `realorderno` varchar(16) NOT NULL default '';
ALTER TABLE `weberp_purchorders` ADD `deliveryby` varchar(100) NOT NULL default '';
ALTER TABLE `weberp_purchorders` ADD `deliverydate` date NOT NULL default '0000-00-00';
ALTER TABLE `weberp_purchorders` ADD `status` varchar(12) NOT NULL default '';
ALTER TABLE `weberp_purchorders` ADD `stat_comment` text NOT NULL;
ALTER TABLE `weberp_purchorderdetails` ADD `itemno` varchar(50) NOT NULL default '';
ALTER TABLE `weberp_purchorderdetails` ADD `uom` varchar(50) NOT NULL default '';
ALTER TABLE `weberp_purchorderdetails` ADD `subtotal_amount` varchar(50) NOT NULL default '';
ALTER TABLE `weberp_purchorderdetails` ADD `package` varchar(100) NOT NULL default '';
ALTER TABLE `weberp_purchorderdetails` ADD `pcunit` varchar(50) NOT NULL default '';
ALTER TABLE `weberp_purchorderdetails` ADD `nw` varchar(50) NOT NULL default '';
ALTER TABLE `weberp_purchorderdetails` ADD `suppliers_partno` varchar(50) NOT NULL default '';
ALTER TABLE `weberp_purchorderdetails` ADD `gw` varchar(50) NOT NULL default '';
ALTER TABLE `weberp_purchorderdetails` ADD `cuft` varchar(50) NOT NULL default '';
ALTER TABLE `weberp_purchorderdetails` ADD `total_quantity` varchar(50) NOT NULL default '';
ALTER TABLE `weberp_purchorderdetails` ADD `total_amount` varchar(50) NOT NULL default '';
ALTER TABLE `weberp_suppliers` ADD `phn` varchar(50) NOT NULL default '';
ALTER TABLE `weberp_suppliers` ADD `port` varchar(200) NOT NULL default '';

ALTER TABLE `weberp_stockmaster` ADD `netweight` decimal(20,4) NOT NULL default '0.0000';
ALTER TABLE `weberp_purchdata` ADD `suppliers_partno` varchar(50) NOT NULL default '';

UPDATE `purchorders` SET `status`='Authorised';
UPDATE `purchorders` SET `status`='Printed' WHERE `allowprint`=0;
UPDATE `purchorders` SET `status`='Completed' WHERE (SELECT SUM(`purchorderdetails`.`completed`)-COUNT(`purchorderdetails`.`podetailitem`) FROM `purchorderdetails` where `purchorderdetails`.`orderno`=`purchorders`.`orderno`)=0;
UPDATE `purchorders` SET `deliverydate`=(SELECT MAX(`purchorderdetails`.`deliverydate`) FROM `purchorderdetails` WHERE `purchorderdetails`.`orderno`=`purchorders`.`orderno`);

ALTER TABLE weberp_custnotes CHANGE note note TEXT NOT NULL;
ALTER TABLE `weberp_bankaccounts` ADD `bankaccountcode` varchar(50) NOT NULL default '' AFTER `currcode`;
ALTER TABLE `weberp_bankaccounts` ADD `invoice` smallint(2) NOT NULL default 0 AFTER `currcode`;

ALTER TABLE `weberp_www_users` ADD `salesman` CHAR( 3 ) NOT NULL AFTER `customerid`;

ALTER TABLE weberp_debtortrans CHANGE shipvia shipvia int(11) NOT NULL DEFAULT 0;

CREATE TABLE weberp_IF NOT EXISTS `audittrail` (
  `transactiondate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `userid` varchar(20) NOT NULL DEFAULT '',
  `querystring` text,
  KEY `UserID` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `weberp_audittrail`  ADD CONSTRAINT `audittrail_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `www_users` (`userid`);

CREATE TABLE weberp_IF NOT EXISTS `deliverynotes` (
  `deliverynotenumber` int(11) NOT NULL,
  `deliverynotelineno` tinyint(4) NOT NULL,
  `salesorderno` int(11) NOT NULL,
  `salesorderlineno` int(11) NOT NULL,
  `qtydelivered` double NOT NULL DEFAULT '0',
  `printed` tinyint(4) NOT NULL DEFAULT '0',
  `invoiced` tinyint(4) NOT NULL DEFAULT '0',
  `deliverydate` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`deliverynotenumber`,`deliverynotelineno`),
  KEY `deliverynotes_ibfk_2` (`salesorderno`,`salesorderlineno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `weberp_deliverynotes`  ADD CONSTRAINT `deliverynotes_ibfk_1` FOREIGN KEY (`salesorderno`, `salesorderlineno`) REFERENCES `salesorderdetails` (`orderno`, `orderlineno`);