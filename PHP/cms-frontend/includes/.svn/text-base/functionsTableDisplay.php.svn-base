<?php

$displayLimit = $_GET['limit']; // amount of result to display per page
$currentPage = $_GET['page']; // current page of results

/* CREATE/UPDATE ANY FILTER VARIABLES */
if ($_POST) {
	foreach (array_keys($fieldFilterArray) as $filter) {
		if ($_POST[$filter]) {
			$_SESSION[$filter] = $_POST[$filter];
		} else {
			unset($_SESSION[$filter]); // reset any variables not used
		}
	}
}

/* if no $_GET or $_POST, a new area is being loaded or user has clicked "reset" on filter */
if (!$_GET && !$_POST) {
	foreach (array_keys($fieldFilterArray) as $filter) {
		unset($_SESSION[$filter]); // clear any $_SESSION variables used in the previous area
	}
}

/* USE SESSION VARIABLES TO CREATE A NEW VARIABLE ($sqlFilter) CONTAINING PARAMETERS FOR THE SQL QUERY */
foreach (array_keys($fieldFilterArray) as $filter) {
	if ($_SESSION[$filter]) {
		if ($fieldFilterArray[$filter] == 'search') {
			/* when input is from a search box, query like results instead of exact results */
			$operator = ' like ';
			$value = '%'.$_SESSION[$filter].'%';
		} elseif (is_array($_SESSION[$filter])) {
			/* when input is from an array (checkbox), get first element of array to initiate the query */
			$operator = '=';
			$value = $_SESSION[$filter][0];
		} else {
			/* DEFUALT - get input info set query variables accordingly */
			$operator = '=';
			$value = $_SESSION[$filter];
		}
		/* first item of the query */
		if (!$sqlFilter) {
			if (is_array($_SESSION[$filter])) {
				$i = 1;
				$sqlFilter .= " WHERE (";
				foreach ($_SESSION[$filter] as $check) {
					if ($i == 1) {
						$sqlFilter .= $filter.$operator."'".$check."'";
					} else {
						$sqlFilter .= " OR ".$filter.$operator."'".$check."'";
					}
					$i++;
				}
				$sqlFilter .= ")";
			} else {
				$sqlFilter = " WHERE ".$filter.$operator."'".$value."'";
			}
		/* all proceeding items of the query */
		} else {
			if (is_array($_SESSION[$filter])) {
				$i = 1;
				$sqlFilter .= " AND (";
				foreach ($_SESSION[$filter] as $check) {
					if ($i == 1) {
						$sqlFilter .= $filter.$operator."'".$check."'";
					} else {
						$sqlFilter .= " OR ".$filter.$operator."'".$check."'";
					}
					$i++;
				}
				$sqlFilter .= ")";
			} else {
				$sqlFilter .= " AND ".$filter.$operator."'".$value."'";
			}
		}
	}
}

/* uncomment to see all $_SESSION variables for debugging purposes */
//var_dump($_SESSION);

/* SET DEFAULT LIMIT IF NO LIMIT IS SET BY USER */
if ((!$displayLimit) || (is_numeric($displayLimit) == false) || ($displayLimit < 1)) {
	$displayLimit = 25;
}

/* SET DEFAULT PAGE IF NO PAGE IS SELECTED BY USER */
if ((!$currentPage) || (is_numeric($currentPage) == false) || ($currentPage < 1)) {
	$currentPage = 1;
}

$displayStart = ($currentPage * $displayLimit) - $displayLimit; // variable for which item in array is to start the display
$displayStop = ($currentPage * $displayLimit) - 1; // variable for which item in array is to stop the display

if ($currentPage==$pageCount) {
	if (($displayLimit*$pageCount)>$rowCount) {
		$displayStop = (($displayLimit*($pageCount-1))+($rowCount-($displayLimit*($pageCount-1)))-1);
	}
}

/* CREATE TABLE WITH SPECIFIED FIELDS */
function createTable ($displayFields,$filterFields) {
	
	/* query the database */
	$sql = "SELECT * FROM ".$_SESSION['table'].$GLOBALS['sqlFilter']." ORDER BY id ASC"." LIMIT ".$GLOBALS['displayStart'].",".$GLOBALS['displayLimit'];
	$result = mysql_query($sql);
	/* uncomment to see the sql query for debugging purposes */
	//echo $sql;
	
	/* create the table */
	echo "\t".'<form action="index.php" method="POST">'."\n";
	echo "\t\t".'<table class="mainContent">'."\n";
	/* create columns and headers for each field */
	echo "\t\t\t".'<thead>'."\n";
	echo "\t\t\t\t".'<tr>'."\n";
	echo "\t\t\t\t\t".'<th>'.'action'.'</th>'."\n";
	foreach ($displayFields as $field) {
		echo "\t\t\t\t\t".'<th>'.$field.'</th>'."\n";
	}
	echo "\t\t\t\t".'</tr>'."\n";
	echo "\t\t\t".'</thead>'."\n";
	/* create table body */
	echo "\t\t\t".'<tbody>'."\n";
	/* create each row */
	if (mysql_num_rows($result)==0) {
		echo "\t\t\t\t".'<tr>'."\n";
			echo "\t\t\t\t\t".'<td class="btnEditOptionsContainer">'.'-'.'</td>'."\n";
		foreach ($displayFields as $field) {
			echo "\t\t\t\t\t".'<td title="'.$field.' = '.$row[$field].'">'.'-'.'</td>'."\n";
		};
		echo "\t\t\t\t".'</tr>'."\n";
	} else {
		while ($row = mysql_fetch_array($result)) {
			echo "\t\t\t\t".'<tr>'."\n";
			echo "\t\t\t\t\t".'<td class="btnEditOptionsContainer">'.'<input type="checkbox" name="item[]" value="'.$row['id'].'" class="action" />'.' | '.'<a class="delete">de</a>'.' | '.'<a class="edit" href="edit.php?'.$row['id'].'">ed</a>'.'</td>'."\n";
			foreach ($displayFields as $field) {
				echo "\t\t\t\t\t".'<td title="'.$field.' = '.$row[$field].'">'.$row[$field].'</td>'."\n";
			};
			echo "\t\t\t\t".'</tr>'."\n";
		}
	}
	/* create table footer */
	echo "\t\t\t\t".'<tr id="tableFooter">'."\n";
	echo "\t\t\t\t\t".'<td colspan="'.(count($displayFields)+1).'">'.'<select name="change"><option value="delete">delete checked</option></select>'.'<button type="submit">Submit Changes</submit>'."\n";
	echo "\t\t\t\t".'</tr>'."\n";
	/* close the table */
	echo "\t\t\t".'</tbody>'."\n";
	echo "\t\t".'</table>'."\n";
	echo "\t".'</form>'."\n";
}

/* CREATE NUMBERED NAVIGATION FOR VIEWING DISPLAYED RESULTS */
function createPageNav () {
	$pagesDisplayed = 9; // amount of page links to display
	$start = ($GLOBALS['currentPage'] - floor($pagesDisplayed/2)); // fist page link to display - DEFAULT
	$stop = (($start+$pagesDisplayed)-1); // last page link to display - DEFAULT

	$sql = "SELECT COUNT(id) as num FROM ".$_SESSION['table'].$GLOBALS['sqlFilter'];
	$result = mysql_query($sql);
	while ($row = mysql_fetch_array($result)) {
		$rowCount = $row['num']; // how many rows which need to be created for the table
		$pageCount = ceil($rowCount/$GLOBALS['displayLimit']); // total number of page results
	}
	array_push($GLOBALS['notificationsArray']['There are '.$rowCount.' results.'] = 'black');
	$prevPage = $GLOBALS['currentPage'] - 1;
	$nextPage = $GLOBALS['currentPage'] + 1;
	
	if ($start<=0) {
		$start = 1;
		$stop = (($start+$pagesDisplayed)-1);
	}
	
	if ($stop>$pageCount) {
		$stop=$pageCount;
		if ((($stop-$pagesDisplayed)+1) <= 1) {
			$start = 1;
		} else {
			$start = (($stop-$pagesDisplayed)+1);
		}
	}
	
	if ($pageCount>1) {
		echo '<!-- page nav for results -->'."\n";
		echo '<nav id="pageNav" class="left">'."\n";
		if ($prevPage>=1) {
			echo "\t".'<a href="?limit='.$GLOBALS['displayLimit'].'&amp;page='.$prevPage.'" class="active">'.'&laquo; previous'.'</a>'."\n";
		} else {
			echo "\t".'<a class="inactive">'.'&laquo; previous'.'</a>'."\n";
		}
		if ($start>1) {
			echo "\t".'<a href="?limit='.$GLOBALS['displayLimit'].'&amp;page='.'1'.'" class="active">'.'1'.' ... '.'</a>'."\n";
		}
		for ($i=$start; $i<=$stop; $i++) {
			if ($i==$GLOBALS['currentPage']) {
				echo "\t".' | '.'<a class="inactive">'.$i.'</a>'."\n";
			} else {
				echo "\t".' | '.'<a href="?limit='.$GLOBALS['displayLimit'].'&amp;page='.$i.'" class="active">'.$i.'</a>'."\n";
			}
		}
		if ($pageCount>$stop) {
			echo "\t".' | '.'<a href="?limit='.$GLOBALS['displayLimit'].'&amp;page='.$pageCount.'" class="active">'.' ... '.$pageCount.'</a>'."\n";
		} else {
			echo "\t".' | '."\n";
		}
		if ($nextPage<=$pageCount) {
			echo "\t".'<a href="?limit='.$GLOBALS['displayLimit'].'&amp;page='.$nextPage.'" class="active">'.'next &raquo;'.'</a>'."\n";
		} else {
			echo "\t".'<a class="inactive">'.'next &raquo;'.'</a>'."\n";
		}
		echo '</nav>'."\n";
	}
}

/* CREATE RESULTS PER PAGE CONTROL */

$resultLimitOptionsArray = array(10,15,25,50,100);
function createResultPerPageControl () {
	echo '<!-- controls for results shown per page -->'."\n";
	echo '<div id="limitOptions" class="right">'."\n";
	echo "\t".'<p>'.'Results per Page: '."\n";
	foreach ($GLOBALS['resultLimitOptionsArray'] as $limit) {
		if ($limit == $GLOBALS['displayLimit']) {
			echo "\t".'<a class="inactive">'.$limit.'</a>'.' | '."\n";
		} else {
			echo "\t".'<a href="?limit='.$limit.'" class="active">'.$limit.'</a>'.' | '."\n";
		}
	}
	echo "\t".'</p>'."\n";
	echo '</div>'."\n";
}

?>