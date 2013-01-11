$(document).ready(function() {

		$('ul.siteTree').nestedSortable({
			disableNesting: 'no-nest',
			forcePlaceholderSize: true,
			handle: 'div',
			helper:	'clone',
			items: 'li',
			maxLevels: 1,
			opacity: .6,
			placeholder: 'placeholder',
			//revert: 250,
			//tabSize: 25,
			tolerance: 'pointer',
			toleranceElement: '> div',
			stop: function(event, ui) {
				var $dropElement = $(ui.item)
				var $dropTarget = $dropElement.closest("ul")
				$dropElement.parents("form").find('input[type=submit]').show()
				//update parent id
				var newParent = $dropTarget.attr('data-parent-id')
				$dropElement.find('input.parent').first().val(newParent)
				//update indexes
				$('ul.siteTree li').each(function(index){
					$(this).find("input.position").val(index + 1)
				})
				
			}
		})




})