<!DOCTYPE HTML>
<?php

session_start();

?>
<html>

<?php include('includes/headerMeta.php'); // header including meta tags - <head> ?>

<body>
	
<?php

/* Enter the fields you want displayed - MUST BE THE EXACT SAME AS THE FIELD NAME WITHIN THE DATABASE */
$fieldDisplayArray = array("title","status","type","size","phone","city","state","zip");

/* Enter the fields you want to use as filter options, along with what type of filter - MUST BE THE EXACT SAME AS THE FIELD NAME WITHIN THE DATABASE */
$fieldFilterArray = array("name" => "search","city" => "checkbox","zip" => "checkbox","size" => "radio"); // array of fields to display from selected table (search(or input), radio, checkbox, and dropdown)

/* ENTER THE TABLE THAT YOU WANT TO PULL FROM - MUST BE THE EXACT SAME AS THE TABLE NAME WITHIN THE DATABASE */
if ($_GET['panel']) {
	$_SESSION['table'] = $_GET['panel']; // name of table to pull info from
}

include('includes/functionsNavigation.php'); // needed for navigation
include('includes/controlBox.php'); // needed for filters
include('includes/functionsTableDisplay.php'); // needed to display table
include('includes/functionsNotifications.php'); // needed to display notifications

include('includes/headerLayout.php'); // header displayed in page - <header>

?>

<!-- wrapper for entire content area excluding header and footer -->
<section id="containerMain">
<!-- wrapper for information within content area excluding header and footer -->
<div id="containerBody">
	
<?php 

createMainNav (); // insert the navigation

?>

<!-- wrapper for information area excluding side navigation -->
<section id="containerContent" class="mainContent right">
	<h1 class="left"><?php echo $_SESSION['table']; ?></h1>
	<!-- container for CTA button(s) at top of page -->
	<div id="containerControlBtns" class="right">
		<a class="btnAction"><p class="right">Add New Something</p></a>
	</div>
			
<?php

createFilterOptions ($fieldFilterArray); // create all the filters using the array variable specified
notifications (); // insert notifications area
createPageNav (); // insert page navigation for table content
createResultPerPageControl (); // insert controls for amount of results displayed per page

?>
<!-- area for main content to be displayed -->
<article id="contentAreaMain" class="content left mianContent" style="overflow:auto;">
			
<?php

createTable ($fieldDisplayArray,$fieldFilterArray); // insert the table containing information

?>
<!-- end contentAreaMain -->
</article>
			
<?php

createPageNav (); // insert page navigation for table content at the bottom in case results are long

?>

<!-- end containerContent -->
</section>
<!-- end containerBody -->
</div>
<!-- end containerMain -->
</section>
	
<?php include('includes/footer.php'); ?>

</body>
</html>
