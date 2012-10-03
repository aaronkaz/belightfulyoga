$(document).ready(function() {
	
	
	$('#page_list').sortable({
		handle: '.handle',
		axis: 'y',
		update: function() {
			$.post($(this).attr('data-path'), $(this).sortable('serialize'))
		}
	})
	
})