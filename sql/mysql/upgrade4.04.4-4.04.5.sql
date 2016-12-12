ALTER TABLE `weberp_custcontacts` ADD `email` VARCHAR( 55 ) NOT NULL;
INSERT INTO weberp_config (confname, confvalue) VALUES ('WorkingDaysWeek','5');
INSERT INTO `weberp_scripts` (`script` ,`pagesecurity` ,`description`) VALUES ('PDFQuotationPortrait.php', '2', 'Quotation printout in portrait');
UPDATE config SET confvalue='4.04.5' WHERE confname='VersionNumber'; 