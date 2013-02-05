<!DOCTYPE HTML>
<html>

<?php include_once('includes/headerMeta.php'); ?>

<body onload="initialize ()">
	<div id="containerMain">
		<?php include_once('includes/header.php'); ?>
		<hr class="lineThick" />
		<div id="contentMain" class="container">
			<article id="getDirections" class="main left">
				<h2>Directions to the Office</h2>
				<p>Our Office is located on South Capital of Texas Highway (TX-360 Loop) just east of the Mo-Pac Expressway (TX-1 Loop) intersection near the entrance to the Barton Creak Greenbelt trail.</p>
				<h3 class="directions">From NorthWest Austin</h3>
				<p>Take the Mo-Pac Expressway (TX-1 Loop). Go South on the South Capital of Texas Highway (TX-360 Loop), exit is in the left lane. From here, turn left at the first light into the Barton Creek Plaza buildings. We are located in the building on the left, second floor, Suite 292.</p>
				<h3 class="directions">From North NorthEast Austin</h3>
				<p>Take I-35 south to exit 230 onto US 290/71 West toward Johnson City. From here, exit onto Capital of Texas Highway (TX-360 Loop) North. Turn right into The Barton Creek Plaza business complex at the light. We are located in the building on the left, second floor, Suite 292.</p>
				<h3 class="directions">From SouthWest Austin</h3>
				<p>Take US 290/71 East to Capital of Texas Highway (TX-360 Loop) North/Manchaca Rd. Stay right for Capital of Texas Highway (TX-360 Loop) North. From here, turn left at the West Ben White Service Rd. and continue straight onto TX-360 Loop North. Turn right into the Barton Creek Plaza business complex at the light. We are located in the building on the left, second floor, Suite 292.</p>
			</article>
			<article id="paymentOptions" class="main left lineTop">
				<h2>Payment Options</h2>
				<p>For your convenience, our office accepts cash, check, Visa, MasterCard, and American Express. CareCredit Healthcare Finance is also available for flexible payment plans. Payment is due at the time of service unless other arrangements have been made in advance by either yourself or your dental plan coverage provider.
			</p>
				<p>Our office accepts assignment from most insurance companies. We are contracted with several insurance companies but, for your convenience, we file out of network claims as well. In many situations, there is actually little to no difference in cost between your in-network vs. out-of-network options; this can also be the case with having insurance vs. not having insurance. It is usually best to check with our office first to go over your options.</p>
				<p>Our staff has years of experience working with children's dental insurance and will be happy to assist you with any questions or concerns you may have. Our <a href="pdfs/thiel_welcoming_packet.pdf" rel="internal" target="_blank">Financial Policy</a> also provides additional information.</p>
			</article>
			<?php include_once('includes/pluginGoogleMap.php'); ?>
			<?php include_once('includes/pluginOfficeInfo.php'); ?>
		</div>
		<br class="clear" />
		<?php include_once('includes/footer.php'); ?>
	</div>

	<!-- SCRIPTS FOR GOOGLE MAPS API -->
	<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyCJFFryEWgUE3I_MRktzhOWWdQV69qgF9A&libraries=places&sensor=false"></script>
	<script type="text/javascript" src="scripts/googleMapAPI.js"></script>

</body>

</html>