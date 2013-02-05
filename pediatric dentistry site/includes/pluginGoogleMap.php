<aside id="googleMap" class="supporting">
	<div id="map_canvas" class="drop right" style="width:320px; height:336px"></div>
	<form action="office.php" id="formGoogleMaps" class="right" onsubmit="overlayDirections();return false;">
		<label>Enter your address for specific directions:</label>
		<input id="fromAddress" type="text" name="address" class="left" /><br />
		<button type="submit" id="submitDirections" class="btnSubmit right">go!</button>
	</form>
	<div id="directions" class="right"></div>
</aside>