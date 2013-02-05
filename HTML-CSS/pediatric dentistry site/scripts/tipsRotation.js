/* JavaScript - Tips Rotation */

$(document).ready(function () {

	/* VARIABLES */
	
	var tips = $('.tip'); // get all tips
	var arrayTips = $.makeArray(tips); // create array of all tips
	var curTip = 0; // first tip to be displayed
	var totTips = arrayTips.length; // total number of tips
	
	/* INITIAL ACTIONS */
	
	// set variables in tip box
	$('#tipCurrent').text(curTip+1);
	$('#tipsTotal').text(totTips);
	
	// display current tip
	$(arrayTips[curTip]).addClass('current');
	
	/* FUNCTIONS */
	
	// function setting the next tip to be displayed
	function setNext(prev) {
		if (prev) {
			nextTip = curTip-1;
			if (nextTip<=0) {
				nextTip = 0;
			}
		} else {
			nextTip = curTip+1;
			if (nextTip>=totTips) {
				nextTip = totTips-1;
			}
		}
	}
	
	// function updating which tip is displayed
	function updateTip() {
		$(arrayTips[curTip]).removeClass('current');
		$(arrayTips[nextTip]).addClass('current');
	}
	
	// function setting the current tip variable
	function setCur (prev) {
		if (prev) {
			curTip--;
			if (curTip<=0) {
				curTip = 0;
			}
		} else {
			curTip++;
			if (curTip>=totTips) {
				curTip = totTips-1;
			}
		}
		$('#tipCurrent').text(curTip+1);
	}
	
	/* BUTTONS */
	
	// next tip
	$('.btnTip.right').click(function () {
		setNext();
		updateTip();
		setCur();
	});
	
	// previous tip
	$('.btnTip.left').click(function () {
		setNext(true);
		updateTip();
		setCur(true);
	});
}); 