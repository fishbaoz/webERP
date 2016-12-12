CREATE TABLE weberp_taxcategories(
taxcatid tinyint( 4 ) AUTO_INCREMENT NOT NULL ,
taxcatname varchar( 30 ) NOT NULL ,
PRIMARY KEY ( taxcatid )
) TYPE=INNODB;

ALTER TABLE weberp_taxauthlevels DROP FOREIGN KEY `taxauthlevels_ibfk_2` ;
ALTER TABLE `weberp_taxauthlevels` CHANGE `dispatchtaxauthority` `dispatchtaxprovince` TINYINT( 4 ) DEFAULT '1' NOT NULL;
ALTER TABLE `weberp_taxauthlevels` CHANGE `level` `taxcatid` TINYINT( 4 ) DEFAULT '0' NOT NULL;

ALTER TABLE `weberp_taxauthlevels` DROP INDEX `dispatchtaxauthority` , ADD INDEX `dispatchtaxprovince` ( `dispatchtaxprovince` );
ALTER TABLE `weberp_taxauthlevels` ADD INDEX ( `taxcatid` ); 
INSERT INTO `weberp_taxcategories` ( `taxcatid` , `taxcatname` ) VALUES ('1', 'Taxable supply');
INSERT INTO `weberp_taxcategories` ( `taxcatid` , `taxcatname` ) VALUES ('2', 'Luxury Items');
INSERT INTO `weberp_taxcategories` ( `taxcatid` , `taxcatname` ) VALUES ('0', 'Exempt');

DELETE FROM taxauthlevels WHERE dispatchtaxprovince <>1 OR taxcatid > 2;

ALTER TABLE weberp_taxauthlevels ADD FOREIGN KEY (taxcatid) REFERENCES taxcategories (taxcatid) ;

CREATE TABLE weberp_taxprovinces(
taxprovinceid tinyint( 4 ) AUTO_INCREMENT NOT NULL ,
taxprovincename varchar( 30 ) NOT NULL ,
PRIMARY KEY ( taxprovinceid )
) TYPE=INNODB;

ALTER TABLE `weberp_locations` CHANGE `taxauthority` `taxprovinceid` TINYINT( 4 ) DEFAULT '1' NOT NULL;
ALTER TABLE `weberp_locations` ADD INDEX ( `taxprovinceid` );

UPDATE locations SET taxprovinceid=1;
INSERT INTO `weberp_taxprovinces` ( `taxprovinceid` , `taxprovincename` ) VALUES ('1', 'Default Tax province');
ALTER TABLE weberp_locations ADD FOREIGN KEY (taxprovinceid) REFERENCES taxprovinces (taxprovinceid);


CREATE TABLE weberp_taxgroups (
  taxgroupid tinyint(4) auto_increment NOT NULL,
  taxgroupdescription varchar(30) NOT NULL,
  PRIMARY KEY(taxgroupid)
)TYPE=INNODB;

CREATE TABLE weberp_taxgrouptaxes (
  taxgroupid tinyint(4) NOT NULL,
  taxauthid tinyint(4) NOT NULL,
  calculationorder tinyint(4) NOT NULL,
  taxontax tinyint(4) DEFAULT 0 NOT NULL,
  PRIMARY KEY(taxgroupid, taxauthid )
) TYPE=INNODB;

ALTER TABLE `weberp_taxgrouptaxes` ADD INDEX ( `taxgroupid` );
ALTER TABLE `weberp_taxgrouptaxes` ADD INDEX ( `taxauthid` );
ALTER TABLE weberp_taxgrouptaxes ADD FOREIGN KEY (taxgroupid) REFERENCES taxgroups (taxgroupid);
ALTER TABLE weberp_taxgrouptaxes ADD FOREIGN KEY (taxauthid) REFERENCES taxauthorities (taxid);

CREATE TABLE weberp_stockmovestaxes (
	stkmoveno int NOT NULL,
	taxauthid tinyint NOT NULL,
	taxontax TINYINT DEFAULT 0 NOT NULL,
	taxcalculationorder TINYINT NOT NULL,
	taxrate double DEFAULT 0 NOT NULL,
	PRIMARY KEY (stkmoveno,taxauthid),
	KEY (taxauthid),
	KEY (taxcalculationorder)
) ENGINE=InnoDB;

ALTER TABLE weberp_stockmovestaxes ADD FOREIGN KEY (taxauthid) REFERENCES taxauthorities (taxid);

INSERT INTO weberp_stockmovestaxes (stkmoveno, taxauthid, taxrate)
	SELECT stockmoves.stkmoveno, 
		custbranch.taxauthority, 
		stockmoves.taxrate 
	FROM stockmoves INNER JOIN custbranch 
		ON stockmoves.debtorno=custbranch.debtorno 
		AND stockmoves.branchcode=custbranch.branchcode;

ALTER TABLE weberp_stockmoves DROP COLUMN taxrate;

CREATE TABLE weberp_debtortranstaxes (
	`debtortransid` INT NOT NULL ,
	`taxauthid` TINYINT NOT NULL ,
	`taxamount` DOUBLE NOT NULL,
	PRIMARY KEY(debtortransid,
			taxauthid),
	KEY (taxauthid)
) ENGINE=innodb;

ALTER TABLE weberp_debtortranstaxes ADD FOREIGN KEY (taxauthid) REFERENCES taxauthorities (taxid);
ALTER TABLE weberp_debtortranstaxes ADD FOREIGN KEY (debtortransid) REFERENCES debtortrans (id);

INSERT INTO weberp_debtortranstaxes (debtortransid, taxauthid, taxamount)
	SELECT debtortrans.id, custbranch.taxauthority, debtortrans.ovgst
		FROM debtortrans INNER JOIN custbranch ON debtortrans.debtorno=custbranch.debtorno AND debtortrans.branchcode=custbranch.branchcode
		WHERE debtortrans.type=10 or debtortrans.type=11;
		
ALTER TABLE weberp_custbranch DROP FOREIGN KEY custbranch_ibfk_5;
ALTER TABLE `weberp_custbranch` CHANGE `taxauthority` `taxgroupid` TINYINT( 4 ) DEFAULT '1' NOT NULL;
ALTER TABLE `weberp_custbranch` DROP INDEX `area_2` ;
ALTER TABLE `weberp_custbranch` DROP INDEX `taxauthority` , ADD INDEX `taxgroupid` ( `taxgroupid` ) ;
UPDATE custbranch SET taxgroupid=1;
INSERT INTO weberp_taxgroups (taxgroupid, taxgroupdescription) VALUES (1,'Default tax group');
ALTER TABLE weberp_custbranch ADD FOREIGN KEY (taxgroupid) REFERENCES taxgroups (taxgroupid);

ALTER TABLE `weberp_taxauthlevels` RENAME `taxauthrates`;
ALTER TABLE weberp_taxauthrates ADD FOREIGN KEY (dispatchtaxprovince) REFERENCES taxprovinces (taxprovinceid);

ALTER TABLE `weberp_stockmaster` CHANGE `taxlevel` `taxcatid` TINYINT( 4 ) DEFAULT '1' NOT NULL;
ALTER TABLE `weberp_stockmaster` ADD INDEX ( `taxcatid` );

UPDATE stockmaster SET taxcatid=3 WHERE taxcatid>3;

ALTER TABLE weberp_stockmaster ADD FOREIGN KEY (taxcatid) REFERENCES taxcategories (taxcatid);

ALTER TABLE `weberp_salesorderdetails` DROP PRIMARY KEY;
ALTER TABLE `weberp_salesorderdetails` ADD `orderlineno` INT DEFAULT '0' NOT NULL FIRST ;

INSERT INTO weberp_config VALUES('FreightTaxCategory','1');
INSERT INTO weberp_config VALUES('SO_AllowSameItemMultipleTimes','1');

CREATE TABLE `weberp_supptranstaxes` (
  `supptransid` int(11) NOT NULL default '0',
  `taxauthid` tinyint(4) NOT NULL default '0',
  `taxamount` double NOT NULL default '0',
  PRIMARY KEY  (`supptransid`,`taxauthid`),
  KEY `taxauthid` (`taxauthid`),
  CONSTRAINT `supptranstaxes_ibfk_2` FOREIGN KEY (`supptransid`) REFERENCES `supptrans` (`id`)
) ENGINE=InnoDB;

ALTER TABLE `weberp_supptranstaxes`
  ADD CONSTRAINT `supptranstaxes_ibfk_1` FOREIGN KEY (`taxauthid`) REFERENCES `taxauthorities` (`taxid`);

  INSERT INTO weberp_supptranstaxes (supptransid, taxauthid, taxamount)
	SELECT supptrans.id, suppliers.taxauthority, supptrans.ovgst
		FROM supptrans INNER JOIN suppliers ON supptrans.supplierno=suppliers.supplierid 
		WHERE supptrans.type=20 or supptrans.type=21;

ALTER TABLE weberp_suppliers DROP FOREIGN KEY `suppliers_ibfk_3`;
ALTER TABLE `weberp_suppliers` CHANGE `taxauthority` `taxgroupid` TINYINT( 4 ) DEFAULT '1' NOT NULL;
ALTER TABLE `weberp_suppliers` DROP INDEX `taxauthority` , ADD INDEX `taxgroupid` ( `taxgroupid` );
UPDATE suppliers SET taxgroupid=1;
ALTER TABLE weberp_suppliers ADD FOREIGN KEY (taxgroupid) REFERENCES taxgroups (taxgroupid);  

ALTER TABLE weberp_locations ADD COLUMN managed tinyint NOT NULL default '0';
