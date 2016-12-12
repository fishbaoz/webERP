ALTER TABLE `weberp_custcontacts` ADD `statement` TINYINT(4) NOT NULL DEFAULT 0;
-- standardise transaction date to DATE type:
ALTER TABLE `weberp_debtortrans` CHANGE `trandate` `trandate` DATE NOT NULL DEFAULT '2016-01-01';
ALTER TABLE `weberp_salesanalysis` CHANGE `salesperson` `salesperson` VARCHAR(4) DEFAULT '' NOT NULL;
ALTER TABLE `weberp_stockrequest` ADD `initiator` VARCHAR(20) NOT NULL DEFAULT '';
ALTER TABLE `weberp_supplierdiscounts` CONVERT TO CHARACTER SET utf8;
ALTER TABLE `weberp_workorders` ADD `reference` VARCHAR(40) NOT NULL DEFAULT '';
ALTER TABLE `weberp_workorders` ADD `remark` TEXT DEFAULT NULL;
INSERT INTO `weberp_scripts` VALUES ('InternalStockRequestInquiry.php', 1, 'Internal Stock Request inquiry');
INSERT INTO `weberp_scripts` VALUES ('PcAssignCashTabToTab.php', 12, 'Assign cash from one tab to another');
INSERT INTO `weberp_scripts` VALUES ('PcTabExpensesList.php', '15', 'Creates excel with all movements of tab between dates');
INSERT INTO `weberp_scripts` VALUES ('PDFGLJournalCN.php', 1, 'Print GL Journal Chinese version');
INSERT INTO `weberp_securitytokens` VALUES (19, 'Internal stock request fully access authority');

-- Add the CashFlowsSection identificator:
ALTER TABLE `weberp_chartmaster` ADD `cashflowsactivity` TINYINT(1) NOT NULL DEFAULT '-1' COMMENT 'Cash flows activity' AFTER `group_`;

-- Add new scripts:
INSERT INTO `weberp_scripts` (`script`, `pagesecurity`, `description`) VALUES ('GLCashFlowsIndirect.php', '8', 'Shows a statement of cash flows for the period using the indirect method');
INSERT INTO `weberp_scripts` (`script`, `pagesecurity`, `description`) VALUES ('GLCashFlowsSetup.php', '8', 'Setups the statement of cash flows sections');

-- Update version number:
UPDATE weberp_config SET confvalue='4.13.1' WHERE confname='VersionNumber';
