$(window).load ->

	$('input[type=radio]').click ->
		question = $("div#question-#{$(this).attr('name')}")
		question.find('input').attr("disabled", "disabled")
		question.find('blockquote.notes').show()
		question.find('i.icon-ok').show()