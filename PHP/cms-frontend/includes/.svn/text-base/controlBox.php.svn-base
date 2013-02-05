<?php

/* FILTER CONTROL BOX */

/* CREATE FORM ITEMS FOR THE ADVANCED SEARCH OPTIONS */
function createFilterOptions ($fields) {
	echo '<aside id="controlBox" class="mainContent left">'."\n";
	echo "\t".'<form action="index.php" method="POST">'."\n";
	$i = 1; // set variable to use as a count
	foreach (array_keys($fields) as $field) {
		$sql = "SELECT DISTINCT ".$field." FROM ".$_SESSION['table']." ORDER BY ".$field." ASC"; // query getting only uniques values for each filter
		$result = mysql_query($sql);
		if (!($i==1)) {
			echo "\t\t\t".'<hr />'."\n"; // create line between filters except on the first filter
		}
		echo "\t\t\t".'<div class="formObject">'."\n";
		if (!($i==1)) {
			echo "\t\t\t\t".'<label>'.$field.':&nbsp;</label>'."\n"; // create a label for this filter
			echo "\t\t\t\t".'<div class="formInputArea">'."\n";
		}
			if ($fields[$field] == "radio") {
				/* create radio button */
				while ($row = mysql_fetch_array($result)) {
					if ($row[$field]) {
						echo "\t\t\t\t\t".'<div class="formInputItem">'."\n";
						echo "\t\t\t\t\t\t".'<input type="radio" name="'.$field.'" value="'.$row[$field].'">'.'<p>'.$row[$field].'</p>'."\n";
						echo "\t\t\t\t\t".'</div>'."\n";
					}
				}
				echo "\t\t\t\t\t".'<div class="formInputItem">'."\n";
				echo "\t\t\t\t\t\t".'<input type="radio" name="'.$field.'" value="">'.'<p>all</p>'."\n"; // create an option to select all
				echo "\t\t\t\t\t".'</div>'."\n";
			} elseif ($fields[$field] == "checkbox") {
				/* create checkboxes */
				while ($row = mysql_fetch_array($result)) {
					if ($row[$field]) {
						echo "\t\t\t\t\t".'<div class="formInputItem">'."\n";
						echo "\t\t\t\t\t\t".'<input type="checkbox" name="'.$field.'[]" value="'.$row[$field].'">'.'<p>'.$row[$field].'</p>'."\n";
						echo "\t\t\t\t\t".'</div>'."\n";
					}
				}
			} elseif ($fields[$field] == "dropdown") {
				/* create dropdown select box */
				echo "\t\t\t\t".'<select name="'.$field.'">'."\n";
				echo "\t\t\t\t\t".'<option value="" selected>- no filter selected -</option>'."\n"; // create an option to select none - also set as default
				while ($row = mysql_fetch_array($result)) {
					if ($row[$field]) {
						echo "\t\t\t\t\t".'<option value="'.$row[$field].'">'.$row[$field].'</option>'."\n";
					}
				}
				echo "\t\t\t\t".'</select>'."\n";
			} elseif ($fields[$field] == "search") {
				/* create text search box */
				echo "\t\t\t\t".'<input type="search" name="'.$field.'" placeholder="Search by '.$field.'" results="5" />'."\n";
			} else {
				/* DEFAULT - create text input box */
				echo "\t\t\t\t".'<input type="text" name="'.$field.'" />'."\n";
			}
			if ($i==1) {
				echo "\t\t\t\t".'<button type="submit">Search</button>'."\n";
				if ((count($fields)>1)) {
					echo "\t\t\t\t".'<a id="btnAdvancedFilter" style="display:none;">Advanced Filter Options &raquo;</a>'."\n";
				}
			}
		if (!($i==1)) {
			echo "\t\t\t\t".'</div>'."\n";
		}
		echo "\t\t\t".'</div>'."\n";
		if ($i==1 && (count($fields)>1)) {
			echo "\t\t".'<div id="advanced">'."\n"; // open the advanced div on the first loop
		}
		$i++; // add one to the count
	}
	if ((count($fields)>1)) {
		echo "\t\t\t".'<hr />'."\n"; // create line at the end of the filter options
		echo "\t\t\t".'<div class="formObject">'."\n";
		echo "\t\t\t\t".'<button type="submit">Search</button>'."\n";
		echo "\t\t\t\t".'<a href="index.php">reset filter</a>'."\n";
		echo "\t\t\t".'</div>'."\n";
		echo "\t\t".'</div>'."\n"; // close the advanced div
	}
	echo "\t".'</form>'."\n"; // close the form
	echo '</aside>'."\n";
}
			
?>