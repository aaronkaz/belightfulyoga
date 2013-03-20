$(document).ready(function() {
	$('form').find('.add_course_event').click(function() {
		time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
		//$(this).before($(this).data('fields').replace(regexp, time))
		$('#course_events_table').find('tbody').append($(this).data('fields').replace(regexp, time))
    return false
	})
})