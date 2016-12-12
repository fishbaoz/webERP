<?php
/* $Id: Z_MakeStockLocns.php 6941 2014-10-26 23:18:08Z daintree $*/
/* Script to make stock locations for all parts that do not have stock location records set up*/

include ('includes/session.inc');
$Title = _('Make LocStock Records');
include('includes/header.inc');

echo '<br /><br />' . _('This script makes stock location records for parts where they do not already exist');

$sql = "INSERT INTO weberp_locstock (stockid, loccode)
		SELECT weberp_stockmaster.stockid,
			weberp_locations.loccode
		FROM weberp_stockmaster CROSS JOIN weberp_locations
			LEFT JOIN weberp_locstock
				ON weberp_stockmaster.stockid = weberp_locstock.stockid
				AND weberp_locations.loccode = weberp_locstock.loccode
                WHERE weberp_locstock.stockid IS NULL";

$ErrMsg = _('The items/locations that need stock location records created cannot be retrieved because');
$Result = DB_query($sql,$ErrMsg);

echo '<p />';
prnMsg(_('Any stock items that may not have had stock location records have now been given new location stock records'),'info');

include('includes/footer.inc');
?>
