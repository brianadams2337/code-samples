/* SLIDESHOW */

jQuery(document).ready(function ($) {

	// editable variables
	var containersPerSlide = 3;
	var slideCurrent = 1;
	var slideItemWidth = 320; // pixels
	var slideSpeed = 500; // milliseconds

	/***** DO NOT EDIT BELOW THIS LINE *****/

	// element variables
	var shortcutSlide = $('#gallery-1');
	var shortcutButtonLeft = $('.btnSlideshow.btnLeft');
	var shortcutButtonRight = $('.btnSlideshow.btnRight');
	// calculated variables
	var slideTotal = shortcutSlide.children('dl').length;
	var slideLength = (slideTotal * slideItemWidth);
	var slideShowViewingContainerWidth = (containersPerSlide * slideItemWidth);

	// SET SLIDE AND VIEWING AREA WIDTH
	
	// set size of viewing container
	shortcutSlide.wrap('<div id="SlideshowWrapperContainerID" />');
	var shortcutSlideViewingArea = $('#SlideshowWrapperContainerID');
	shortcutSlideViewingArea.width(slideShowViewingContainerWidth + 'px');
	shortcutSlideViewingArea.css({'display' : 'block', 'float' : 'right', 'clear' : 'none', 'right' : '32px', 'position' : 'relative', 'overflow' : 'hidden'});
	// set width of full slide containing all phones
	shortcutSlide.css({'position' : 'relative', 'left' : (((slideCurrent - 1) * -1) * slideShowViewingContainerWidth)});
	shortcutSlide.width(slideLength + 'px');

	// CONTROL BUTTONS
	
	// set placement of control buttons
	var rightControlPosX = 0;
	var leftControlPosX = 0;
	shortcutButtonRight.css('right', rightControlPosX + 'px');
	shortcutButtonLeft.css('left', leftControlPosX + 'px');
	// determine if controls are needed - hide of not, show otherwise
	if (containersPerSlide >= slideTotal) {
		shortcutButtonRight.remove();
		shortcutButtonLeft.remove();
	}
	// slide right
	shortcutButtonRight.unbind('click').click( function() {
		if (!(shortcutSlide.is(':animated'))) {
			slideCurrent += 1;
			var pos = shortcutSlide.position();
			var posLeft = pos.left;
			// hide/show controls that are needed
			if (shortcutButtonRight.css('display') != 'none') {
				if ((((slideCurrent - 1) * -1) * slideShowViewingContainerWidth) <= ((slideLength * -1) + slideShowViewingContainerWidth)) {
					shortcutButtonRight.css({'cursor' : 'default'}).fadeOut();
					shortcutButtonLeft.css({'cursor' : 'pointer'}).fadeIn();
				} else {
					shortcutButtonRight.css({'cursor' : 'default'}).fadeIn();
					shortcutButtonLeft.css({'cursor' : 'pointer'}).fadeIn();
				}
			}
			// move the slide
			if (posLeft > ((slideLength * -1) + slideShowViewingContainerWidth)) {
				shortcutSlide.animate({left: (((slideCurrent - 1) * -1) * slideShowViewingContainerWidth)}, slideSpeed);
				return false;
			} else {
				return false;
			}
		}
	});
	// slide left
	shortcutButtonLeft.unbind('click').click( function() {
		if (!(shortcutSlide.is(':animated'))) {
			slideCurrent -= 1;
			var pos = shortcutSlide.position();
			var posLeft = pos.left;
			// hide/show controls that are needed
			if (shortcutButtonLeft.css('display') != 'none') {
				if ((((slideCurrent - 1) * -1) * slideShowViewingContainerWidth) >= 0) {
					shortcutButtonLeft.css({'cursor' : 'default'}).fadeOut();
					shortcutButtonRight.css({'cursor' : 'pointer'}).fadeIn();
				} else {
					shortcutButtonRight.css({'cursor' : 'default'}).fadeIn();
					shortcutButtonLeft.css({'cursor' : 'pointer'}).fadeIn();
				}
			}
			// move the slide
			if (posLeft < 0) {
				shortcutSlide.animate({left: (((slideCurrent - 1) * -1) * slideShowViewingContainerWidth)}, slideSpeed);
				return false;
			} else {
				return false;
			}
		}
	});
	
});

/* SLIDESHOW END */