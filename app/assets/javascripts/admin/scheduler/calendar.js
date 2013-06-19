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
	

})