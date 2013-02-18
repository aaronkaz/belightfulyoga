function remove_waiver_guests() {
	$('.remove_waiver_guest').unbind("click").click(function() {
		$(this).prev('input[type=hidden]').val('1')
    $(this).closest('div').hide()
    return false
	})	
}

$(document).ready(function() {
	remove_waiver_guests()
	
	$('#add_waiver_guest').click(function() {
		time = new Date().getTime()
	  regexp = new RegExp($(this).data('id'), 'g')
		$('#waiver_guests').append($(this).data('fields').replace(regexp, time))
		remove_waiver_guests()
	  return false
	})
})