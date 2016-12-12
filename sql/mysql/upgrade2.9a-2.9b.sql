BEGIN;
DROP TABLE weberp_WORequirements;
DROP TABLE weberp_WOIssues;
ALTER TABLE `weberp_WorksOrders` ADD `UnitsRecd` DOUBLE DEFAULT '0' NOT NULL AFTER `UnitsReqd` ;
ALTER TABLE `weberp_WWW_Users` CHANGE `Language` `Language` VARCHAR( 5 ) DEFAULT 'en_GB' NOT NULL;
COMMIT;
