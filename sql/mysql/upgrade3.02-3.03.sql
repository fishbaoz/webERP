/*USE weberp; */
/*May need to uncomment the line above or edit to the name of the db you wish to upgrade*/

ALTER TABLE `weberp_debtorsmaster` ADD `address5` VARCHAR( 20 ) NOT NULL AFTER `address4` , ADD `address6` VARCHAR( 15 ) NOT NULL AFTER address5;
ALTER TABLE `weberp_custbranch` ADD `braddress5` VARCHAR( 20 ) NOT NULL default '' AFTER `braddress4` , ADD `braddress6` VARCHAR( 15 ) NOT NULL default '' AFTER `braddress5` ;
ALTER TABLE `weberp_custbranch` ADD `brpostaddr5` VARCHAR( 20 ) NOT NULL default '' AFTER `brpostaddr4` , ADD `brpostaddr6` VARCHAR( 15 ) NOT NULL default '' AFTER `brpostaddr5` ;

ALTER TABLE `weberp_locations` ADD `deladd4` VARCHAR( 40 ) NOT NULL default '' AFTER `deladd3` ,
ADD `deladd5` VARCHAR( 20 ) NOT NULL default '' AFTER `deladd4` ,
ADD `deladd6` VARCHAR( 15 ) NOT NULL default '' AFTER `deladd5` ;

ALTER TABLE `weberp_purchorders` ADD `deladd5` VARCHAR( 20 ) NOT NULL default '' AFTER `deladd4` ,
ADD `deladd6` VARCHAR( 15 ) NOT NULL default '' AFTER `deladd5` ;
ALTER TABLE `weberp_purchorders` ADD `contact` VARCHAR( 30 ) NOT NULL default '' AFTER `deladd6` ;

ALTER TABLE `weberp_recurringsalesorders` ADD `deladd5` VARCHAR( 20 ) NOT NULL default '' AFTER `deladd4` ,
ADD `deladd6` VARCHAR( 15 ) NOT NULL default '' AFTER `deladd5` ;

ALTER TABLE `weberp_recurringsalesorders` CHANGE `deladd2` `deladd2` VARCHAR( 40 )  NOT NULL ,
CHANGE `deladd3` `deladd3` VARCHAR( 40 ) NOT NULL ,
CHANGE `deladd4` `deladd4` VARCHAR( 40 ) DEFAULT NULL ;

ALTER TABLE `weberp_salesorders` ADD `deladd5` VARCHAR( 20 ) NOT NULL default '' AFTER `deladd4` ,
ADD `deladd6` VARCHAR( 15 ) NOT NULL default '' AFTER `deladd5` ;

ALTER TABLE `weberp_salesorders` CHANGE `deladd2` `deladd2` VARCHAR( 40 ) NOT NULL ,
CHANGE `deladd3` `deladd3` VARCHAR( 40 ) NOT NULL ,
CHANGE `deladd4` `deladd4` VARCHAR( 40 ) DEFAULT NULL ;

ALTER TABLE `weberp_suppliers` ADD `address5` VARCHAR( 20 ) NOT NULL default '' AFTER `address4` ,
ADD `address6` VARCHAR( 15 ) NOT NULL default '' AFTER `address5` ;

ALTER TABLE `weberp_companies` CHANGE `regoffice3` `regoffice4` VARCHAR( 40 ) NOT NULL ; 
ALTER TABLE `weberp_companies` CHANGE `regoffice2` `regoffice3` VARCHAR( 40 ) NOT NULL ;
ALTER TABLE `weberp_companies` CHANGE `regoffice1` `regoffice2` VARCHAR( 40 ) NOT NULL ;
ALTER TABLE `weberp_companies` CHANGE `postaladdress` `regoffice1` VARCHAR( 40 ) NOT NULL ;
ALTER TABLE `weberp_companies` ADD `regoffice5` VARCHAR( 20 ) NOT NULL default '' AFTER `regoffice4` , 
ADD `regoffice6` VARCHAR( 15 ) NOT NULL default '' AFTER `regoffice5` ;