get '/admin/exams/?' do
	admin!
	@exams = Exam.all
	erb :'admin/exams'
end

get '/admin/exams/:id/?' do
	admin!
	@exam = Exam.get params[:id]
	@questions = @exam.questions(:order => :position)
	@answers = @questions.answers(:order => :body)
	erb :'admin/exam'
end

post '/admin/exams/:exam_id/questions/:question_id' do
	admin!
	
	question = Question.get params[:question_id]
	params[:position].strip.is_numeric? ? params[:position] = params[:position].strip : params[:position] = question.position
	question.update(
		position: params[:position],
		body: params[:body].strip,
		score_type: params[:score_type],
		countable: false
	)
	question.update(countable: true) if params[:countable]
	
	question.answers.each do |a|
		params[:answers]["#{a.id}"]['response'].strip.empty? ? params[:answers]["#{a.id}"]['response'] = nil : params[:answers]["#{a.id}"]['response'].strip!
		a.update(
			required: false,
			body: params[:answers]["#{a.id}"]['body'].strip,
			response: params[:answers]["#{a.id}"]['response']
		)
	end
	
	required_answer = Answer.get params[:required_answer]
	required_answer.update(required: true)

	session[:alert] = { style: 'alert-success', message: "Question #{question.position} updated." }
	redirect "/admin/exams/#{params[:exam_id]}"
end