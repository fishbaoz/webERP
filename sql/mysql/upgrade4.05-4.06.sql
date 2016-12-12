ALTER TABLE weberp_stockmaster DROP lastcurcostdate;
ALTER TABLE weberp_stockmaster ADD lastcostupdate DATE NOT NULL;
INSERT INTO weberp_ `config` (`confname` ,`confvalue`)
VALUES ('InventoryManagerEmail',  '');
ALTER TABLE `weberp_banktrans` ADD INDEX ( `ref` );
ALTER TABLE weberp_ `pcexpenses` ADD  `tag` TINYINT( 4 ) NOT NULL DEFAULT  '0';
ALTER TABLE `weberp_debtortrans` DROP FOREIGN KEY `debtortrans_ibfk_1`;
UPDATE config SET confvalue='4.06.6' WHERE confname='VersionNumber';