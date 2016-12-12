<?php

include('includes/session.inc');
$Title = _('WO items can be produced with available stock');
include('includes/header.inc');

if (isset($_POST['submit'])) {
    submit($db, $RootPath, $_POST['Location']);
} else {
    display($db);
}

//####_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT_SUBMIT####
function submit(&$db, $RootPath, $Location) {

	$WhereLocation 	= " AND weberp_workorders.loccode = '". $Location ."' ";
	
	$sql = "SELECT weberp_woitems.wo,
				weberp_woitems.stockid,
				weberp_woitems.qtyreqd,
				weberp_woitems.qtyrecd,
				weberp_stockmaster.decimalplaces,
				weberp_stockmaster.units
			FROM weberp_workorders, weberp_woitems, weberp_stockmaster
			WHERE weberp_workorders.wo = weberp_woitems.wo
				AND weberp_stockmaster.stockid = weberp_woitems.stockid 
				AND weberp_workorders.closed = 0
				AND weberp_woitems.qtyreqd > weberp_woitems.qtyrecd ".
				$WhereLocation .
			"ORDER BY weberp_woitems.wo, weberp_woitems.stockid"
			;
	
	$ErrMsg = _('The SQL to find the WO items to produce ');
	$resultItems = DB_query($sql,$ErrMsg);
	if (DB_num_rows($resultItems) != 0){
	
		echo '<p class="page_title_text" align="center"><strong>' . "Items in WO to be produced now in " . $Location . " with available stock" . '</strong></p>';
		echo '<div>';
		echo '<table class="selection">';
		$TableHeader = '
						<tr>
							<th>' . _('WO') . '</th>
							<th>' . _('Stock ID') . '</th>
							<th>' . _('Requested') . '</th>
							<th>' . _('Received') . '</th>
							<th>' . _('Pending') . '</th>
							<th>' . _('UOM') . '</th>
							<th>' . _('Component') . '</th>
							<th>' . _('QOH') . '</th>
							<th>' . _('Needed') . '</th>
							<th>' . _('Shrinkage') . '</th>
							<th>' . _('UOM') . '</th>
							<th></th>
							<th>' . _('Result') . '</th>
						</tr>';

		while ($myItem = DB_fetch_array($resultItems)) {
			echo $TableHeader;
			
			$QtyPending = $myItem['qtyreqd'] - $myItem['qtyrecd'];
			$QtyCanBeProduced = $QtyPending;

			$WOLink = '<a href="' . $RootPath . '/WorkOrderEntry.php?WO=' . $myItem['wo'] . '">' . $myItem['wo'] . '</a>';
			$CodeLink = '<a href="' . $RootPath . '/SelectProduct.php?StockID=' . $myItem['stockid'] . '">' . $myItem['stockid'] . '</a>';
			
			printf('<td class="number">%s</td>
					<td>%s</td>
					<td class="number">%s</td>
					<td class="number">%s</td>
					<td class="number">%s</td>
					<td>%s</td>
					<td>%s</td>
					<td class="number">%s</td>
					<td class="number">%s</td>
					<td class="number">%s</td>
					<td>%s</td>
					<td>%s</td>
					<td>%s</td>
					</tr>', 
					$WOLink,
					$CodeLink, 
					locale_number_format($myItem['qtyreqd'],$myItem['decimalplaces']),
					locale_number_format($myItem['qtyrecd'],$myItem['decimalplaces']),
					locale_number_format($QtyPending,$myItem['decimalplaces']),
					$myItem['units'], 
					'',
					'',
					'',
					'',
					'',
					'',
					''
					);

			// Get the BOM for this item
			$sqlBOM = "SELECT weberp_bom.parent,
						weberp_bom.component,
						weberp_bom.quantity AS bomqty,
						weberp_stockmaster.decimalplaces,
						weberp_stockmaster.units,
						weberp_stockmaster.shrinkfactor,
						weberp_locstock.quantity AS qoh
					FROM weberp_bom, weberp_stockmaster, weberp_locstock
					WHERE weberp_bom.component = weberp_stockmaster.stockid
						AND weberp_bom.component = weberp_locstock.stockid
						AND weberp_locstock.loccode = '". $Location ."'
						AND weberp_bom.parent = '" . $myItem['stockid'] . "'
                        AND weberp_bom.effectiveafter <= '" . date('Y-m-d') . "'
                        AND weberp_bom.effectiveto > '" . date('Y-m-d') . "'";
					 
			$ErrMsg = _('The bill of material could not be retrieved because');
			$BOMResult = DB_query ($sqlBOM,$ErrMsg);
			$ItemCanBeproduced = TRUE;
			
			while ($myComponent = DB_fetch_array($BOMResult)) {

				$ComponentNeeded = $myComponent['bomqty'] * $QtyPending;
				$PrevisionShrinkage = $ComponentNeeded * ($myComponent['shrinkfactor'] / 100);

				if ($myComponent['qoh'] >= $ComponentNeeded){
					$Available = "OK";
				}else{
					$Available = "";
					$ItemCanBeproduced = FALSE;
				}

				$ComponentLink = '<a href="' . $RootPath . '/SelectProduct.php?StockID=' . $myComponent['component'] . '">' . $myComponent['component'] . '</a>';
				
				printf('<td class="number">%s</td>
					<td>%s</td>
					<td class="number">%s</td>
					<td class="number">%s</td>
					<td class="number">%s</td>
					<td>%s</td>
					<td>%s</td>
					<td class="number">%s</td>
					<td class="number">%s</td>
					<td class="number">%s</td>
					<td>%s</td>
					<td>%s</td>
					<td>%s</td>
					</tr>', 
					'',
					'',
					'',
					'',
					'',
					'',
					$ComponentLink, 
					locale_number_format($myComponent['qoh'],$myComponent['decimalplaces']),
					locale_number_format($ComponentNeeded,$myComponent['decimalplaces']),
					locale_number_format($PrevisionShrinkage,$myComponent['decimalplaces']),
					$myComponent['units'], 
					$Available,
					''
					);
			}
			if ($ItemCanBeproduced){
				$Action = 'Produce ' . locale_number_format($QtyPending,0) . ' x ' . $myItem['stockid'] . ' for WO ' . locale_number_format($myItem['wo'],0);
				$ComponentLink = '<a href="' . $RootPath . '/PrintWOItemSlip.php?StockId=' . $myItem['stockid'] . '&WO='. $myItem['wo'] . '&Location=' . $Location . '">' . $Action . '</a>';
			}else{
				$ComponentLink = "";
			}
				printf('<td class="number">%s</td>
					<td>%s</td>
					<td class="number">%s</td>
					<td class="number">%s</td>
					<td class="number">%s</td>
					<td>%s</td>
					<td>%s</td>
					<td class="number">%s</td>
					<td class="number">%s</td>
					<td class="number">%s</td>
					<td>%s</td>
					<td>%s</td>
					<td>%s</td>
					</tr>', 
					'',
					'',
					'',
					'',
					'',
					'',
					'',
					'',
					'',
					'',
					'',
					'',
					$ComponentLink
					);
		}
		echo '</table>
				</div>';

	}else{
		prnMsg('No items waiting to be produced in ' . $Location);
	}
	
} // End of function submit()


function display(&$db)  //####DISPLAY_DISPLAY_DISPLAY_DISPLAY_DISPLAY_DISPLAY_#####
{
// Display form fields. This function is called the first time
// the page is called.

	echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF'],ENT_QUOTES,'UTF-8') . '" method="post">
          <div>
			<br/>
			<br/>';
	echo '<input type="hidden" name="FormID" value="' . $_SESSION['FormID'] . '" />';

	echo '<p class="page_title_text" align="center"><strong>' . "List of items in WO ready to be produced in: " . '</strong></p>';

	echo '<table>';

		echo '<tr>
				<td>' . _('For Factory Location') . ':</td>
				<td><select name="Location">';

		$sql = "SELECT weberp_locations.loccode,
					locationname
				FROM weberp_locations
				INNER JOIN weberp_locationusers
					ON weberp_locationusers.loccode=weberp_locations.loccode
					AND weberp_locationusers.userid='" .  $_SESSION['UserID'] . "'
					AND weberp_locationusers.canview=1
				WHERE weberp_locations.usedforwo = 1";

		$LocnResult=DB_query($sql);

		while ($myrow=DB_fetch_array($LocnResult)){
			echo '<option value="' . $myrow['loccode'] . '">' . $myrow['locationname'] . '</option>';
		}
		echo '</select></td>
			</tr>';


  echo '<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" name="submit" value="' . _('Search Items To Produce') . '" /></td>
		</tr>
		</table>
	<br />';
   echo '</div>
         </form>';

} // End of function display()

include('includes/footer.inc');
?>