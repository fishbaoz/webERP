CREATE TABLE `weberp_custcontacts` (
  `contid` int(11) NOT NULL auto_increment,
  `debtorno` varchar(10) NOT NULL,
  `contactname` varchar(40) NOT NULL,
  `role` varchar(40) NOT NULL,
  `phoneno` varchar(20) NOT NULL,
  `notes` varchar(255) NOT NULL,
  PRIMARY KEY  (`contid`)
) ENGINE=InnoDB;

ALTER TABLE weberp_suppliers ADD COLUMN `factorcompanyid` int(11) NOT NULL DEFAULT '1';

CREATE TABLE weberp_IF NOT EXISTS `factorcompanies` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

ALTER TABLE `weberp_suppliers` ADD COLUMN `taxref` varchar(20) NOT NULL default '';

CREATE TABLE `weberp_tags` (
`tagref` tinyint(4) NOT NULL auto_increment,
`tagdescription` varchar(50) NOT NULL,
PRIMARY KEY (`tagref`)
) ENGINE=InnoDB;

ALTER TABLE `weberp_gltrans` ADD COLUMN `tag` tinyint(4) NOT NULL default '0' AFTER `jobref`;

ALTER TABLE `weberp_custbranch` DROP COLUMN `vtiger_accountid`;
ALTER TABLE `weberp_salesorders` DROP COLUMN `vtiger_accountid`;
ALTER TABLE `weberp_stockmaster` DROP COLUMN `vtiger_productid`;
DELETE FROM `config` WHERE `confname`='vtiger_integration';

ALTER TABLE `weberp_custbranch` ADD `lat` FLOAT( 10, 6 ) NOT NULL AFTER `braddress6` ,
ADD `lng` FLOAT( 10, 6 ) NOT NULL AFTER `lat`;
ALTER TABLE `weberp_suppliers` ADD `lat` FLOAT( 10, 6 ) NOT NULL AFTER `address6` ,
ADD `lng` FLOAT( 10, 6 ) NOT NULL AFTER `lat`;

CREATE TABLE `weberp_geocode_param` (
 `geocodeid` varchar(4) NOT NULL default '',
 `geocode_key` varchar(200) NOT NULL default '',
 `center_long` varchar(20) NOT NULL default '',
 `center_lat` varchar(20) NOT NULL default '',
 `map_height` varchar(10) NOT NULL default '',
 `map_width` varchar(10) NOT NULL default '',
 `map_host` varchar(50) NOT NULL default ''
) ENGINE=InnoDB;

INSERT INTO `weberp_config` ( `confname` , `confvalue` ) VALUES ('geocode_integration', '0');

INSERT INTO `weberp_config` ( `confname` , `confvalue` ) VALUES ('DefaultCustomerType', '1');

CREATE TABLE `weberp_debtortype` (
`typeid` tinyint(4) NOT NULL auto_increment,
`typename` varchar(100) NOT NULL,
PRIMARY KEY (`typeid`)
) ENGINE=InnoDB;

INSERT INTO `weberp_debtortype` ( `typeid` , `typename` ) VALUES (1, 'Default');

ALTER TABLE `weberp_debtorsmaster` ADD `typeid` tinyint(4) NOT NULL default '1';
ALTER TABLE `weberp_debtorsmaster` ADD CONSTRAINT `debtorsmaster_ibfk_5` FOREIGN KEY (`typeid`) REFERENCES `debtortype` (`typeid`);
ALTER TABLE `weberp_purchdata` ADD `effectivefrom` DATE NOT NULL;

CREATE TABLE `weberp_debtortypenotes` (
`noteid` tinyint(4) NOT NULL auto_increment,
`typeid` tinyint(4) NOT NULL default '0',
`href` varchar(100) NOT NULL,
`note` varchar(200) NOT NULL,
`date` date NOT NULL default '0000-00-00',
`priority` varchar(20) NOT NULL,
PRIMARY KEY (`noteid`)
) ENGINE=InnoDB;

CREATE TABLE `weberp_custnotes` (
`noteid` tinyint(4) NOT NULL auto_increment,
`debtorno` varchar(10) NOT NULL default '0',
`href` varchar(100) NOT NULL,
`note` varchar(200) NOT NULL,
`date` date NOT NULL default '0000-00-00',
`priority` varchar(20) NOT NULL,
PRIMARY KEY (`noteid`)
) ENGINE=InnoDB;

INSERT INTO `weberp_config` ( `confname` , `confvalue` ) VALUES ('Extended_CustomerInfo', '0');
INSERT INTO `weberp_config` ( `confname` , `confvalue` ) VALUES ('Extended_SupplierInfo', '0');

ALTER TABLE weberp_salesglpostings MODIFY COLUMN area VARCHAR(3) NOT NULL;
ALTER TABLE weberp_salesanalysis MODIFY COLUMN area VARCHAR(3) NOT NULL;
ALTER TABLE `weberp_debtortrans` CHANGE `trandate` `trandate` DATE NOT NULL DEFAULT '0000-00-00';