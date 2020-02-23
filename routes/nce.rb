get '/nce/?' do
	if session[:user]
		user = User.get session[:user]
		redirect '/nce/exams' if user.max_exams > 0
	end

	erb :nce
end

get '/nce/glossary/?' do
	@exam = 'NCE'
	@glossary = Glossary.all(exam: 'NCE').sort!{|a,b| a.chapter <=> b.chapter}
	erb :'cards'
end

get '/nce/exams/?' do
	authorize!

	user = User.get session[:user]
	redirect '/nce' unless user.max_exams > 0

	@max_exams = User.get(session[:user]).max_exams
	@exams = Exam.all order: :id
	erb :'nce/index'
end

get '/nce/guide/:id/:group/?' do
	authorize!

	max_exams = User.get(session[:user]).max_exams

	if (params[:id] == '1') || (params[:id] == '4')
		unless max_exams >= 2
			session[:alert] = { message: "You haven't purchased that exam." }
			redirect '/nce'
		end
	else
		unless max_exams >= 4
			session[:alert] = { message: "You haven't purchased that exam." }
			redirect '/nce'
		end
	end

	@exam = Exam.get params[:id]
	@questions = @exam.questions(:order => :position, score_type: params[:group])
	@answers = @questions.answers(:order => :body)
	erb :'nce/guide'
end

get '/nce/exams/:id/?' do
	authorize!
	expired?

	max_exams = User.get(session[:user]).max_exams

	if (params[:id] == '1') || (params[:id] == '4')
		unless max_exams >= 2
			session[:alert] = { message: "You haven't purchased that exam." }
			redirect '/nce'
		end
	else
		unless max_exams >= 4
			session[:alert] = { message: "You haven't purchased that exam." }
			redirect '/nce'
		end
	end

	if Average.all(exam_id: params[:id], user_id: session[:user]).count > 0
		redirect "/nce/exams/#{params[:id]}/score"
	end
	@scores = []
	Score.all(user_id: session[:user], exam_id: params[:id]).each {|s| @scores << s.answer_id }
	@exam = Exam.get params[:id]
	@questions = @exam.questions(:order => :position)
	if params[:group]
		@questions = @questions.all(score_type: params[:group])
	end
	@answers = @questions.answers(:order => :body)
	erb :'nce/exam'
end

get '/nce/exams/:id/score/?' do
	authorize!
	expired?

	@scores = []
	scores = Score.all(user_id: session[:user], exam_id: params[:id])
	scores.each {|s| @scores << s.answer_id }
	@exam = Exam.get params[:id]
	@questions = @exam.questions(:order => :position)
	@answers = @questions.answers(:order => :body)

	@average = ((scores.all(countable: true, required: true).count.to_f / @exam.questions(:countable => true).count.to_f)*100).to_i



	@average = 0 if @average < 0
	Average.first_or_create(exam_id: params[:id], user_id: session[:user], score: @average)
	Use.first_or_create(user_id: session[:user], exam_id: params[:id], sample: @exam.sample)

	@breakdown = {}
	@breakdown['Professional Orientation'] 				 = {possible: 0, correct: 0}
	@breakdown['Research and Program Evaluation']  = {possible: 0, correct: 0}
	@breakdown['Appraisal']	 											 = {possible: 0, correct: 0}
	@breakdown['Lifestyle and Career Development'] = {possible: 0, correct: 0}
	@breakdown['Helping Relationships'] 					 = {possible: 0, correct: 0}
	@breakdown['Group Counseling'] 								 = {possible: 0, correct: 0}
	@breakdown['Human Growth and Development'] 		 = {possible: 0, correct: 0}
	@breakdown['Social and Cultural Foundations']  = {possible: 0, correct: 0}
	@breakdown['Domain 1: Professional Practice and Ethics'] 				  = {possible: 0, correct: 0}
	@breakdown['Domain 2: Intake, Assessment, and Diagnosis']           = {possible: 0, correct: 0}
	@breakdown['Domain 3: Areas of Clinical Focus']	 										= {possible: 0, correct: 0}
	@breakdown['Domain 4: Treatment Planning']                          = {possible: 0, correct: 0}
	@breakdown['Domain 5: Counseling Skills and Interventions'] 				= {possible: 0, correct: 0}
	@breakdown['Domain 6: Core Counseling Attributes'] 								  = {possible: 0, correct: 0}
	@breakdown['Undefined']  											                      = {possible: 0, correct: 0}

	@questions.each do |q|
		@breakdown[q.score_type][:possible] += 1
	end

	scores.each do |s|
		@breakdown[s.score_type][:correct]  += 1 if s.required?
	end

	if params[:group]
		@questions = @questions.all(score_type: params[:group])
	end

	erb :'nce/exam'
end

get '/nce/exams/:id/restart/?' do
	authorize!
	expired?

	Score.all(user_id: session[:user], exam_id: params[:id]).destroy
	Average.all(exam_id: params[:id], user_id: session[:user]).destroy
	redirect "/nce/exams/#{params[:id]}"
end
