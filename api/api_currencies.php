<?php
/* $Id: api_currencies.php 6941 2014-10-26 23:18:08Z daintree $*/

/* This function returns a list of the currency abbreviations
 * currently setup on webERP
 */

	function GetCurrencyList($user, $password) {
		$Errors = array();
		$db = db($user, $password);
		if (gettype($db)=='integer') {
			$Errors[0]=NoAuthorisation;
			return $Errors;
		}
		$sql = 'SELECT currabrev FROM weberp_currencies';
		$result = DB_query($sql);
		$i=0;
		while ($myrow=DB_fetch_array($result)) {
			$CurrencyList[$i]=$myrow[0];
			$i++;
		}
		return $CurrencyList;
	}

/* This function takes as a parameter a currency abbreviation
 * and returns an array containing the details of the selected
 * currency.
 */

	function GetCurrencyDetails($currency, $user, $password) {
		$Errors = array();
		$db = db($user, $password);
		if (gettype($db)=='integer') {
			$Errors[0]=NoAuthorisation;
			return $Errors;
		}
		$sql = "SELECT * FROM weberp_currencies WHERE currabrev='".$currency."'";
		$result = DB_query($sql);
		return DB_fetch_array($result);
	}

?>