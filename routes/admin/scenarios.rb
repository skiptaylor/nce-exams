get '/admin/scenarios/?' do
	admin!
	@scenarios = Scenario.all
	erb :'admin/scenarios'
end

get '/admin/scenarios/:id/?' do
	admin!
	@scenario = Scenario.get params[:id]
	@questions = @scenario.questions(:order => :position)
	@answers = @questions.answers(:order => :body)
	erb :'admin/scenario'
end

post '/admin/scenarios/:id/?' do
	admin!
	scenario = Scenario.get params[:id]
	scenario.update(title: params[:title].strip, body: params[:body].strip, references: params[:references].strip, active: false, sample: false, workshop: false, practice: false)
	scenario.update(active: true) if params[:active]
	scenario.update(sample: true) if params[:sample]
	scenario.update(workshop: true) if params[:workshop]
  scenario.update(practice: true) if params[:practice]
	session[:alert] = { style: 'alert-success', message: 'Scenario updated.' }
	redirect "/admin/scenarios/#{params[:id]}"
end

post '/admin/scenarios/:id/questions/new/?' do
	admin!
	params[:position].strip.is_numeric? ? params[:position] = params[:position].strip : params[:position] = 1
 	params[:notes].strip.empty? ? params[:notes] = nil : params[:notes].strip!
	Question.create(
		scenario_id: params[:id],
		body:				 params[:body].strip,
		notes: 			 params[:notes],
		score_type:  params[:score_type],
		position: 	 params[:position]
	)
	session[:alert] = { style: 'alert-success', message: 'Question added.' }
	redirect "/admin/scenarios/#{params[:id]}"
end

post '/admin/scenarios/:id/questions/:question_id/?' do
	admin!
	question = Question.get params[:question_id]
	params[:position].strip.is_numeric? ? params[:position] = params[:position].strip : params[:position] = question.position
	params[:notes].strip.empty? ? params[:notes] = nil : params[:notes].strip!
	question.update(
		body:				params[:body].strip,
		notes: 			params[:notes],
		score_type: params[:score_type],
		position: 	params[:position]
	)	
	session[:alert] = { style: 'alert-success', message: 'Question updated.' }
	redirect "/admin/scenarios/#{params[:id]}"
end

get '/admin/scenarios/:id/questions/:question_id/delete/?' do
	admin!
	question = Question.get params[:question_id]
	question.destroy
	session[:alert] = { style: 'alert-success', message: 'Question removed.' }
	redirect "/admin/scenarios/#{params[:id]}"
end

post '/admin/scenarios/:id/questions/:question_id/answers/new/?' do
	admin!
	params[:value].strip.is_numeric? ? params[:value] = params[:value].strip : params[:value] = 0
	params[:response].strip.empty? ? params[:response] = "Empty" : params[:response].strip!
	answer = Answer.create(
		question_id: params[:question_id],
		body: 			 params[:body].strip,
		response: 	 params[:response],
		value: 			 params[:value],
		required: 	 false
	)
	answer.update(required: true) if params[:required]	
	session[:alert] = { style: 'alert-success', message: 'Answer added.' }
	redirect "/admin/scenarios/#{params[:id]}"
end

post '/admin/scenarios/:id/questions/:question_id/answers/:answer_id/?' do
	admin!
	answer = Answer.get params[:answer_id]
	params[:value].strip.is_numeric? ? params[:value] = params[:value].strip : params[:value] = answer.value
	params[:response].strip.empty? ? params[:response] = nil : params[:response].strip!
	answer.update(
		body: 		params[:body].strip,
		response: params[:response],
		value: 		params[:value],
		required: false
	)
	answer.update(required: true) if params[:required]		
	session[:alert] = { style: 'alert-success', message: 'Answer updated.' }
	redirect "/admin/scenarios/#{params[:id]}"
end

get '/admin/scenarios/:id/questions/:question_id/answers/:answer_id/delete/?' do
	admin!
	answer = Answer.get params[:answer_id]
	answer.destroy
	session[:alert] = { style: 'alert-success', message: 'Answer removed.' }
	redirect "/admin/scenarios/#{params[:id]}"
end