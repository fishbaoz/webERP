<?php
/* $Id: GetPrice.inc 6941 2014-10-26 23:18:08Z daintree $*/
function GetPrice ($StockID, $DebtorNo, $BranchCode, $OrderLineQty=1, $ReportZeroPrice=1){
	global $db;
	$Price = 0;

	/*Search by branch and customer for a date specified price */
	$sql="SELECT weberp_prices.price
			FROM weberp_prices,
				weberp_debtorsmaster
			WHERE weberp_debtorsmaster.salestype=weberp_prices.typeabbrev
			AND weberp_debtorsmaster.debtorno='" . $DebtorNo . "'
			AND weberp_prices.stockid = '" . $StockID . "'
			AND weberp_prices.currabrev = weberp_debtorsmaster.currcode
			AND weberp_prices.debtorno=weberp_debtorsmaster.debtorno
			AND weberp_prices.branchcode='" . $BranchCode . "'
			AND weberp_prices.startdate <='" . Date('Y-m-d') . "'
			AND weberp_prices.enddate >='" . Date('Y-m-d') . "'";

	$ErrMsg =  _('There is a problem in retrieving the pricing information for part') . ' ' . $StockID  . ' ' . _('and for Customer') . ' ' . $DebtorNo .  ' ' . _('the error message returned by the SQL server was');
	$result = DB_query($sql,$ErrMsg);

	if (DB_num_rows($result)==0){
		/*Need to try same specific search but for a default price with a zero end date */
		$sql="SELECT weberp_prices.price,
					weberp_prices.startdate
				FROM weberp_prices,
					weberp_debtorsmaster
				WHERE weberp_debtorsmaster.salestype=weberp_prices.typeabbrev
				AND weberp_debtorsmaster.debtorno='" . $DebtorNo . "'
				AND weberp_prices.stockid = '" . $StockID . "'
				AND weberp_prices.currabrev = weberp_debtorsmaster.currcode
				AND weberp_prices.debtorno=weberp_debtorsmaster.debtorno
				AND weberp_prices.branchcode='" . $BranchCode . "'
				AND weberp_prices.startdate <='" . Date('Y-m-d') . "'
				AND weberp_prices.enddate ='0000-00-00'
				ORDER BY weberp_prices.startdate DESC";

		$result = DB_query($sql,$ErrMsg);

		if (DB_num_rows($result)==0){

			/* No result returned for customer and branch search try for just a customer match */
			$sql = "SELECT weberp_prices.price
					FROM weberp_prices,
					weberp_debtorsmaster
					WHERE weberp_debtorsmaster.salestype=weberp_prices.typeabbrev
					AND weberp_debtorsmaster.debtorno='" . $DebtorNo . "'
					AND weberp_prices.stockid = '" . $StockID . "'
					AND weberp_prices.currabrev = weberp_debtorsmaster.currcode
					AND weberp_prices.debtorno=weberp_debtorsmaster.debtorno
					AND weberp_prices.branchcode=''
					AND weberp_prices.startdate <='" . Date('Y-m-d') . "'
					AND weberp_prices.enddate >='" . Date('Y-m-d') . "'";

			$result = DB_query($sql,$ErrMsg);
			if (DB_num_rows($result)==0){
				//if no specific price between the dates maybe there is a default price with no end date specified
				$sql = "SELECT weberp_prices.price,
							   weberp_prices.startdate
						FROM weberp_prices,
							weberp_debtorsmaster
						WHERE weberp_debtorsmaster.salestype=weberp_prices.typeabbrev
						AND weberp_debtorsmaster.debtorno='" . $DebtorNo . "'
						AND weberp_prices.stockid = '" . $StockID . "'
						AND weberp_prices.currabrev = weberp_debtorsmaster.currcode
						AND weberp_prices.debtorno=weberp_debtorsmaster.debtorno
						AND weberp_prices.branchcode=''
						AND weberp_prices.startdate <='" . Date('Y-m-d') . "'
						AND weberp_prices.enddate >='0000-00-00'
						ORDER BY weberp_prices.startdate DESC";

				$result = DB_query($sql,$ErrMsg);

				if (DB_num_rows($result)==0){

					/*No special customer specific pricing use the customers normal price list but look for special limited time prices with specific end date*/
					$sql = "SELECT weberp_prices.price
							FROM weberp_prices,
							weberp_debtorsmaster
							WHERE weberp_debtorsmaster.salestype=weberp_prices.typeabbrev
							AND weberp_debtorsmaster.debtorno='" . $DebtorNo . "'
							AND weberp_prices.stockid = '" . $StockID . "'
							AND weberp_prices.debtorno=''
							AND weberp_prices.currabrev = weberp_debtorsmaster.currcode
							AND weberp_prices.startdate <='" . Date('Y-m-d') . "'
							AND weberp_prices.enddate >='" . Date('Y-m-d') . "'";

					$result = DB_query($sql,$ErrMsg);

					if (DB_num_rows($result)==0){
						/*No special customer specific pricing use the customers normal price list but look for default price with 0000-00-00 end date*/
						$sql = "SELECT weberp_prices.price,
									   weberp_prices.startdate
								FROM weberp_prices,
									weberp_debtorsmaster
								WHERE weberp_debtorsmaster.salestype=weberp_prices.typeabbrev
								AND weberp_debtorsmaster.debtorno='" . $DebtorNo . "'
								AND weberp_prices.stockid = '" . $StockID . "'
								AND weberp_prices.debtorno=''
								AND weberp_prices.currabrev = weberp_debtorsmaster.currcode
								AND weberp_prices.startdate <='" . Date('Y-m-d') . "'
								AND weberp_prices.enddate ='0000-00-00'
								ORDER BY weberp_prices.startdate DESC";

						$result = DB_query($sql,$ErrMsg);

						if (DB_num_rows($result)==0){

							/* Now use the default salestype/price list cos all else has failed */
							$sql="SELECT weberp_prices.price
									FROM weberp_prices,
										weberp_debtorsmaster
									WHERE weberp_prices.stockid = '" . $StockID . "'
									AND weberp_prices.currabrev = weberp_debtorsmaster.currcode
									AND weberp_debtorsmaster.debtorno='" . $DebtorNo . "'
									AND weberp_prices.typeabbrev='" . $_SESSION['DefaultPriceList'] . "'
									AND weberp_prices.debtorno=''
									AND weberp_prices.startdate <='" . Date('Y-m-d') . "'
									AND weberp_prices.enddate >='" . Date('Y-m-d') . "'";;

							$result = DB_query($sql,$ErrMsg);

							if (DB_num_rows($result)==0){

								/* Now use the default salestype/price list cos all else has failed */
								$sql="SELECT weberp_prices.price,
											 weberp_prices.startdate
										FROM weberp_prices,
											weberp_debtorsmaster
										WHERE weberp_prices.stockid = '" . $StockID . "'
										AND weberp_prices.currabrev = weberp_debtorsmaster.currcode
										AND weberp_debtorsmaster.debtorno='" . $DebtorNo . "'
										AND weberp_prices.typeabbrev='" . $_SESSION['DefaultPriceList'] . "'
										AND weberp_prices.debtorno=''
										AND weberp_prices.startdate <='" . Date('Y-m-d') . "'
										AND weberp_prices.enddate ='0000-00-00'
										ORDER BY weberp_prices.startdate DESC";

								$result = DB_query($sql,$ErrMsg);

								if (DB_num_rows($result)==0){
									/* Now check the price matrix */
									$sql = "SELECT max(weberp_pricematrix.price) FROM weberp_pricematrix,
															weberp_debtorsmaster
												WHERE weberp_pricematrix.stockid = '" . $StockID . "'
												AND weberp_pricematrix.currabrev = weberp_debtorsmaster.currcode
												AND weberp_pricematrix.salestype = weberp_debtorsmaster.salestype
												AND weberp_pricematrix.quantitybreak >= '" . $OrderLineQty . "'
												AND weberp_pricematrix.startdate <= '" . Date('Y-m-d') . "' 
												AND weberp_pricematrix.enddate >='" . Date('Y-m-d') . "'";
									$ErrMsg = _('There is an error to retrieve price from price matrix for stock') . ' ' . $StockID . ' ' . _('and the error message returned by SQL server is ');
									$result = DB_query($sql,$ErrMsg);
									$MaxPriceRow = DB_fetch_row($result);
								}
								if ($MaxPriceRow[0]==NULL){	
									/*Not even a price set up in the default price list so return 0 */
									if ($ReportZeroPrice ==1){
										prnMsg(_('There are no prices set up for') . ' ' . $StockID,'warn');
									}
									Return 0;
								}
							}
						}
					}
				}
			}
		}
	}

	if (DB_num_rows($result)!=0){
		/*There is a price from one of the above so return that */
		$myrow=DB_fetch_row($result);

		
		Return $myrow[0];
	} else {
		Return 0;
	}

}
?>
