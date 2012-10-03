function removeFilters() {
	$('.remove-filter').unbind('click').click(function() {
		$(this).parents('.filter-row').remove()
		return false
	})
}

$(document).ready(function() {
	$('.show-tooltip').tooltip()
	$('.datepicker').datepicker({ dateFormat: "yy-mm-dd" })
	
	removeFilters()
	$('.filter_attr').click(function() {	
		time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
		$('#filter-break').show()
		$('#filter-area').append($(this).data('fields').replace(regexp, time))
		removeFilters()
    return false
	})
})