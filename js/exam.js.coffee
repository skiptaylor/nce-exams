$(window).load ->
	
	$('input[type=radio]').click ->
		self = $(this)
		id = self.attr 'value'
		$.post(
			'/add-score',
			{ answer: id },
			(data) ->
				self.parent('label').parent('div').parent('div').parent('form').prev('p').removeClass('unread')
				#show_submit()
		)
	
	$('a.restart').click -> return false unless confirm 'This will reset your score! Continue?'
	
	$('a#score-link').click -> return false if $(this).parent('li').hasClass('disabled')
	
	$('a.set-link').click ->
		set = $(this).html()
		
		$('.pagination ul li').removeClass 'active'
		$(this).parent('li').addClass 'active'
		
		$('.set').hide()
		$("#set-#{set}").show()
		
		$('#set-label').html set
		$('html, body').scrollTop 0
		
		return false