<!DOCTYPE HTML>
<html>

<?php include_once('includes/headerMeta.php'); ?>

<body>
	<div id="containerMain">
		<?php 
			include_once('includes/headerHome.php');
			include_once('includes/slideshowHome.php');
		?>
		<div id="contentMain" class="container">
			<?php 
				include_once('includes/pluginTestimonials.php');
				include_once('includes/pluginNewPatientsHome.php');
				include_once('includes/pluginOfficeAppointments.php');
			?>
		</div>
		<?php include_once('includes/footer.php'); ?>
	</div>
</body>

</html>