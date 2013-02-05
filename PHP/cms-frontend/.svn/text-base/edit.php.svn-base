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
include('includes/functionsForms.php'); // needed for forms

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
			
<!-- area for main content to be displayed -->
<article id="contentAreaMain" class="content left mianContent" style="overflow:auto;">

<?php

createForm (); // create blank form

?>
<!-- end contentAreaMain -->
</article>
			
<!-- end containerContent -->
</section>
<!-- end containerBody -->
</div>
<!-- end containerMain -->
</section>
	
<?php include('includes/footer.php'); ?>

</body>
</html>
