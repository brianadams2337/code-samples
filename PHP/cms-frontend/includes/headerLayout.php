<?php
$con = mysql_connect("localhost","ilhigh_dev","*h@WWXqdTbl4");
$db = mysql_select_db("ilhigh_dev");
if (!$con) {
	die('Could not connect: ' . mysql_error());
}
?>
<header>
	<section id="containerHeader">
		<p id="userInfo">
			<span id="username">Welcome Username</span>&nbsp;|&nbsp;
			<span id="editProfile">Edit Profile</span>&nbsp;|&nbsp;
			<span id="logout">Logout</span>
		</p>
		<h1 id="pageTitle">CMS Admin &mdash; [Insert Client Here]</h1>
	</section>
</header>
