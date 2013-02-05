/*
 * Copyright 2011 Invenio Media - http://www.inveniomedia.com
 *
 * THIS SCRIPT IS CREATED AND OWNED BY INVENIO MEDIA.
 *
*/

/* JavaScript Document */

/* SLIDESHOW */

$(document).ready(function(){

	/* EDITABLE VARIABLES */

	var speedFadeIn = 500; // speed at which each slide fades in
	var speedFadeOut = 500; // speed at which each slide fades out
	var readingTime = 5000; // time given to read each slide

	/* DO NOT EDIT BELOW THIS LINE */

	/* get array of slides */
	var slide = $('.slide');
	var slideArray = $.makeArray(slide);

	/* get total amount of slides */
	var slideTotal = slide.length;

	/* set variables */
	var startSlide = 0; // slide which the show starts on - for editing purposes when skipping to specific slide is needed
	var curSlide = startSlide;
	var newSlide = curSlide+1;
	var isBusy = false; // used to block the 'goToSlide' function when set to true;
	
	/* hide all slides except first slide */
	for (var i=1;i<=slideTotal;i++) {
		$(slideArray[i]).hide();
		console.log(i);
	}
	/* display the first slide */
	$(slideArray[startSlide]).show();

	/* create the buttons for each slide */
	var i = 1;
	$.each(slideArray, function () {
		$('#containerSlideShowBtns').append('<div id="'+i+'" class="btnSlide hidden">'+i+'</div>');
		i++;
	});
	/* highlight first button */
	adjustBtn (startSlide);
	
	/* SLIDESHOW */
	
	/* timer for the slideshow */
	var automateSlideShow = setInterval(function () {
		changeSlide(curSlide,newSlide);
	}, readingTime);

	/* transitions between the slides of given variables */
	function changeSlide (current,next) {
		adjustBtn (next);
		isBusy = true;
		$(slideArray[next]).fadeIn(speedFadeIn, function () {
			curSlide = next;
			if ((next+1)>=slideTotal) {
				newSlide = startSlide;
			} else {
				newSlide = curSlide+1;
			}
			$(slideArray[current]).fadeOut(speedFadeOut, function () {
				isBusy = false;
			});
		});
	}
	
	/* go to a specific slide */	
	function goToSlide (s) {
		clearInterval(automateSlideShow);
		/* check to make the changeSlide function is not already running */
		if (isBusy) {
			/* if changeSlide is running, recheck vor variable every 50ms */
			setTimeout(function () {
				goToSlide(s);
			}, 50);
		} else {
			/* if changeSlide is finished, run function */
			changeSlide(curSlide,s);
			automateSlideShow = setInterval(function () {changeSlide(curSlide,newSlide);}, readingTime);
		}
	}
	
	/* restarts the slideshow timer if stopped/paused - also functions as a "next" button */
	function restartTimer () {
		clearInterval(automateSlideShow);
		changeSlide(curSlide,newSlide);
		automateSlideShow = setInterval(function () {changeSlide(curSlide,newSlide);}, readingTime);
	}
	
	/* BUTTONS */
	
	/* highlight button of current slide */
	function adjustBtn (s) {
		$('.btnSlide').css('background-position','');
		$('.btnSlide').eq(s).css('background-position','0px -12px');
	}
			
	/* get id of button clicked and go to that slide - subtract 1 so the id corresponds with the 0-based array */
	$(".btnSlide").click(function () {
		goToSlide ((event.target.id-1));
		$(this).css('background-position','0px -12px');
	});
	
});