<?php

include('includes/session.inc');

$Title = _('Report a bug to the webERP team');

include('includes/header.inc');

if (http_file_exists('http://weberp.com/buggenie/thebuggenie/weberp')) {
	echo '<script type="text/javascript">window.open(\'http://weberp.com/buggenie/thebuggenie/weberp\');</script>';
	prnMsg(_('You will now be redirected to the webERP bug genie. If you do not have an account then you can login as user - guest with password - guest. If you use the guest login you will not be notified of progress with your report'), 'info');
} else {
	prnMsg(_('You do not appear to have an internet connection. To use this function you require access to the internet'), 'warn');
}
include('includes/footer.inc');

?>