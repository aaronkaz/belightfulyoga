function removeFilters() {
	$('.remove-filter').unbind('click').click(function() {
		$(this).parents('.filter-row').remove()
		return false
	})
}

function setCommons(){
//START COMMON FUNCTIONS


//ASSOCIATION SELECTS
function associationSelect() {
	var $elm = $(".association-select");
	if ($elm.length) {
		$elm.unbind("change").change(function() {
			var $this = $(this)
			var $linkTo = $this.siblings('.edit-selected')
			if ( $this.val() != "" ) {	
				var newHref = $linkTo.attr('data-path-prefix')+'/'+$this.val()+'/edit'
				$linkTo.attr('href', newHref)
				$linkTo.show()
			} else {
				$linkTo.hide()
			}
		})
	}
}

//TOGGLE FORMS
function toggleForms() {
	var $elm = $("a.toggle-form");
	if ($elm.length) {
		$elm.unbind("click").click(function() {
			var target = $(this).attr("toggle-target");
			$("#"+target).toggle();
			return false;
		});
	}
}


//FORM DIALOG WINDOWS
function setFormCosms() {
var $elm = $('.dialog-form');
	if ($elm.length) {	
		$elm.unbind("click").click(function(e) {
			//make sure any open windows get closed
			$('#modal_window').remove();
			
	  	var url = $(this).attr('href');
			var title = $(this).attr('title')
			var dialog_form = $('<div id="modal_window" title="'+title+'">Loading form...</div>').dialog({
				autoOpen: false,
				//width: 520,
				height: 680,
				maxHeight: 580,
				minWidth: 450,
				position: ['center', 40],
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
					"Save": function() {
						var $recordForm = $(this).find('form').submit()
						},
					Cancel: function() { 
						$(this).dialog("close")
					}
				}			
			})
			dialog_form.dialog('open')
	  	e.preventDefault()
	  })
	}	
}


//GENERAL DIALOG FORMS
function setDialogForms() {
var $elm = $('#modal_window').find('form');	
if ($elm.length) {
	$elm.unbind("submit").submit(function(e) {
		var $this = $(this);
		var furl = $this.attr('action');
		var fdata = $this.serialize();
		$('#modal_window').html('Loading...');
		$.ajax({
							type	: "POST",
							cache	: false,
							url		: furl,
							data	: fdata,
							success: function(data) {
								$('#modal_window').html(data);
								setDialogForms();
								setCommons();
								$('#modal_window').dialog('option', 'height', 'auto');
								$('#modal_window').dialog('option', 'maxHeight', 600);
								$('#modal_window').dialog('option', 'width', 'auto');
								$('#modal_window').dialog('option', 'maxWidth', 800);
							}
						});
		
	e.preventDefault();
	});	
}	
}


//GENERAL DIALOGS
function setDialogs() {
var $elm = $('.dialog-open');
if ($elm.length) {	
	$elm.unbind("click").click(function(e) {
	//make sure any open windows get closed
	$('#modal_window').remove();
	
    var url = $(this).attr('href');
	var title = $(this).attr('title')
	var dialog_win = $('<div id="modal_window" title="'+title+'">Loading form...</div>').dialog({
		autoOpen: false,
		//width: 520,
		maxHeight: 580,
		width: 'auto',
		maxWidth: 800,
		position: ['center', 40],
		modal: true,
		open: function() {
			$(this).load(url, function() {
				specialInputs();
				setDialogForms();
				setCommons();
			});	
		},
		close: function() {
			$('#modal_window').remove();
		}		

	});
	dialog_win.dialog('open');
    e.preventDefault();
  });
}	
}

//CHECK ALL
function checkAll() {
	
	var $elm = $('#select_all')
	if ($elm.length) {
		
		$elm.change(function() {
			var $this = $(this)
			$(this).parents('table').find('tbody tr').each(function() {		
				if ( $this.is(':checked') ) {
					$(this).find('input[type=checkbox]').each(function () {
						$(this).attr('checked', true)
					})								
				} else {
					$(this).find('input[type=checkbox]').each(function () {
						$(this).attr('checked', false)
					})
				}
			})
		})
	}
}

//DO MULTIPLE
function doMultiple() {
	var $elm = $('.bulk_action')
	if ($elm.length) {
		$elm.click(function() {
			var $table = $('#bulk_action_form')
			$table.find('#bulk_action').val($(this).attr("id"))
			$table.submit()
			return false
		})
	}		
}


// END COMMONS FUNCTIONS

// CALL EACH FUNCTION TO SET

$('.dropdown-toggle').dropdown()
$('.show-tooltip').tooltip()
$('.datepicker').datepicker({ dateFormat: "yy-mm-dd" })
$('.color_picker').spectrum({
    preferredFormat: "hex6",
    showInput: true
})

$('.div-toggle').click(function() {
	var target = $(this).data('target')
	$('#' + target).toggle()
	return false
})

associationSelect()
toggleForms()
setFormCosms()
setDialogs()
checkAll()
doMultiple()
removeFilters()
}

$(document).ready(function() {
	
	setCommons()
	
	$('.filter_attr').click(function() {	
		time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
		$('#filter-break').show()
		$('#filter-area').append($(this).data('fields').replace(regexp, time))
		removeFilters()
    return false
	})
})