$(window).load ->

	$('a.last').click ->
		card = $(this).parents('div.current-card')
		card.hide()
		card.prev().show()
		return false

	$('a.next').click ->
		card = $(this).parents('div.current-card')
		card.hide()
		card.next().show()
		return false
		
	$('div.flashcard, div.tap').click ->
		card = $(this).parents('div.current-card')
		card.find('div.flashcard').toggleClass('flipped')
		return false