/* JavaScript Document */

$(document).ready(function(){

	/* ADVANCED FILTER OPTIONS */
	
	/* creates the 'Advanced Filter' button. Not needed if JS is turned off. */
	$('#btnAdvancedFilter').css('display','inline');
	
	/* Slide advanced filter box up or down according to it's current status */
	$('#btnAdvancedFilter').click( function() {
		if ($('#advanced').is(':hidden')) {
			$('#advanced').slideDown();
		} else {
			$('#advanced').slideUp();
		}
	});
	
	/* ROW COLOR CHANGE */
	
	/* change row bg color if input box is checked - '.greenBG' class is located in 'css/default.css' */
	$('input').click( function() {
		if ($(this).is(':checked')) {
			$(this).parents('tr').addClass('greenBG');
		} else {
			$(this).parents('tr').removeClass('greenBG');
		}
	});
	
	/* SECOND SCROLLBAR ON TOP OF TABLE */

	var widthTable = $('table').width(); // width of table being used
	var widthScroll = $('#contentAreaMain').width(); // width of scrollbar being used

	$('#contentAreaMain').before('<div id="secondScrollBarContainer"><div id="secondScrollBar">&nbsp;</div></div>');
	
	$('#secondScrollBarContainer').css({'width':widthScroll,'height':'auto','overflow':'auto','overflow-y':'hidden'}); // dynamically create width of new scrollbar
	$('#secondScrollBar').css({'width':widthTable,'height':'0px'}); // dynamically create width of new scrollbar
	
	/* link to two scrollbars together */
	$("#contentAreaMain").scroll(function(){
		$("#secondScrollBarContainer").scrollLeft($("#contentAreaMain").scrollLeft());
	});
	$("#secondScrollBarContainer").scroll(function(){
		$("#contentAreaMain").scrollLeft($("#secondScrollBarContainer").scrollLeft());
	});
	
	/* NOTIFICATIONS */
	$('#notificationsContainer ul').append('<li>js test</li>');
	
	/* CHECK ALL CHECKBOX */
	$('table').find('th').first().prepend('<input type="checkbox" name="item[]" value="" class="action" />');
	$('table').find('input:checkbox').first().click(function() {
		var checkedStatus = this.checked;
		$('table').find('input:checkbox').each(function() {
			this.checked = checkedStatus;
			if ($(this).is(':checked')) {
				$(this).parents('tr').addClass('greenBG');
			} else {
				$(this).parents('tr').removeClass('greenBG');
			}
		});
	});
		
});