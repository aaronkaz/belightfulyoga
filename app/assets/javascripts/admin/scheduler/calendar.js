function openEventModal(title, url) {
	$('#event_modal_window').remove();
	
	var url = url
	var title = title
	var dialog_form = $('<div id="event_modal_window" title="'+title+'">Loading form...</div>').dialog({
		autoOpen: false,
		//width: 520,
		height: 500,
		maxHeight: 580,
		minWidth: 450,
		position: ['center', 80],
		modal: true,
		open: function() {
			$(this).load(url, function() {
				
				if ( $('form').attr('data-remote') !== 'undefined' ) {
					$('form').attr('data-remote', true)
				}
				$('#modal_window').find('.page-header').remove()
				$('#modal_window').find('.form-actions').remove()
				specialInputs()
				setDialogs()
			})	
		},
		close: function() {
			$('#modal_window').remove()
		},
		buttons: {
			"Close": function() { 
				$(this).dialog("close")
			}
		}		
	})
	dialog_form.dialog('open')
}


$(document).ready(function() {
	
	$eventBox = $("<div id='event-hover-box' style='position:absolute;width:300px;height:100px;border:1px solid #000;z-index:1000;'></div>")
	$('body').append($eventBox)
	$eventBox.hide()
	
	$('#calendar').fullCalendar({
		header: {
						left: 'prev,next today',
						center: 'title',
						right: 'month,agendaWeek,agendaDay'
		},
		/*eventMouseover: function(calEvent, jsEvent, view) {
			$eventBox.css('left', jsEvent.pageX)
			$eventBox.css('top', jsEvent.pageY)
			$eventBox.show()
		},*/
		eventClick: function(calEvent, jsEvent, view) {
						//alert('Coordinates: ' + jsEvent.pageX + ',' + jsEvent.pageY);
		        //alert('Event: ' + calEvent.id);
						openEventModal(calEvent.title, calEvent.url)
						jsEvent.preventDefault()
		    }		
	})
})