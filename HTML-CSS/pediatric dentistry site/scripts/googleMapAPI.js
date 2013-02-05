/* JavaScript - Google Map API */

var directionsDisplay;
var directionsService = new google.maps.DirectionsService();

function initialize() {

	var thielAddress = "3755 S. Capital of Texas Highway Suite 292 Austin, TX 78704"; // address of Thiel
	var thielLatLng = new google.maps.LatLng(30.243201, -97.800035); // coordinates of Thiel
    directionsDisplay = new google.maps.DirectionsRenderer();
    var thielIcon = "http://thielpediatricdentistry.riskdesigners.com/images/logoMainInner.png"; // icon displayed for Thiel
    // map options	
	var optionsMap = {
		zoom: 12,
		center: thielLatLng,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};
	// create map
    var map = new google.maps.Map(document.getElementById("map_canvas"), optionsMap);
    // designate where turn-by-turn directions are displayed
    directionsDisplay.setPanel(document.getElementById("directions"));
	// create marker for Thiel
	var marker = new google.maps.Marker({
		position: new google.maps.LatLng(30.243201, -97.800035),
		map: map
	});
	
	directionsDisplay.setMap(map);	

}

function overlayDirections() {
	// set beginning and end points for directions
	var fromAddress = document.getElementById("fromAddress").value;
	var thielAddress = "3755 S. Capital of Texas Highway Suite 292 Austin, TX 78704";
	// variables for directions request
	var request = {
		origin:fromAddress,
		destination:thielAddress,
		travelMode: google.maps.DirectionsTravelMode.DRIVING,
		region: "US"
	};
	// display directions
	directionsService.route(request, function(response, status) {
		if (status == google.maps.DirectionsStatus.OK) {
			directionsDisplay.setDirections(response);
			var timer;
			timer = setTimeout(function () {
				$('#directions').slideDown(); // show directions container
			}, 250);
		}
	});
	
}