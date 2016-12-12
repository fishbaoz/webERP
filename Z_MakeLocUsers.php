<?php
/* $Id: Z_MakeLocUsers.php 1 agaluski $*/
/* Script to make user locations for all users that do not have user location records set up*/

include ('includes/session.inc');
$Title = _('Make weberp_locationusers Records');
include('includes/header.inc');

echo '<br /><br />' . _('This script makes stock location records for parts where they do not already exist');

$sql = "INSERT INTO weberp_locationusers (userid, loccode, canview, canupd)
		SELECT weberp_www_users.userid,
		weberp_locations.loccode,
		1,
		1
		FROM weberp_www_users CROSS JOIN weberp_locations
		LEFT JOIN weberp_locationusers
		ON weberp_www_users.userid = weberp_locationusers.userid
		AND weberp_locations.loccode = weberp_locationusers.loccode
        WHERE weberp_locationusers.userid IS NULL;";

$ErrMsg = _('The users/locations that need user location records created cannot be retrieved because');
$Result = DB_query($sql,$ErrMsg);

echo '<p />';
prnMsg(_('Any users that may not have had user location records have now been given new location user records'),'info');

include('includes/footer.inc');
?>
