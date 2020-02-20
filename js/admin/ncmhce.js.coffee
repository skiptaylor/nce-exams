$(window).load ->

	$('a#save-scenario-btn').click ->
		$('#edit-scenario-form').submit()
		return false
	
	$('a#save-new-question-btn').click ->
		$('#new-question-form').submit()
		return false
	
	$('a.save-question-btn').click ->
		$("#edit-question-#{$(this).attr 'id'}-form").submit()
		return false
	
	$('a.new-answer-btn').click ->
		$("#new-answer-#{$(this).attr 'id'}-form").submit();
		return false
	
	$('a.save-answer-btn').click ->
		$("#edit-answer-#{$(this).attr 'id'}-form").submit();
		return false