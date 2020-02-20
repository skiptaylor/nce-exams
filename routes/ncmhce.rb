get '/ncmhce/?' do
	if session[:user]
		user = User.get session[:user]
		redirect '/ncmhce/scenarios' if user.max_scenarios > 0
	end

	erb :ncmhce
end

get '/ncmhce/glossary/?' do
	@exam = 'NCMHCE'
	@glossary = Glossary.all(exam: 'NCMHCE').sort!{|a,b| a.chapter <=> b.chapter}
	erb :'cards'
end

get '/ncmhce/sample/?' do
	unless session[:user]
		user = User.create(email: 'sample', password: 'sample')
		session[:user] = user.id
		session[:sample] = true
	end
	redirect '/ncmhce/scenarios/1'
end

get '/ncmhce/scenarios/?' do
  authorize!

  user = User.get session[:user]
  redirect '/ncmhce' unless user.max_scenarios > 0

  @max_scenarios = User.get(session[:user]).max_scenarios
  @scenarios = Scenario.all(order: :id, active: true)
  @scenarios = @scenarios.all(workshop: false) unless user.workshop_scenarios == true

  @max_practice_scenarios = User.get(session[:user]).max_practice_scenarios

  @scenarios = @scenarios.all(practice: false) unless user.practice_exams == true
  @averages = Average.all(:user_id => session[:user], :scenario_id.not => nil)
  @remaining_scenarios = User.get(session[:user]).remaining_scenarios
  @uses = []
  Use.all(user_id: session[:user]).each { |u| @uses << u.scenario_id }
  erb :'ncmhce/index'
end


get '/ncmhce/practice-scenarios/?' do
  authorize!

  user = User.get session[:user]
  redirect '/ncmhce' unless user.max_practice_scenarios > 0

  @max_practice_scenarios = User.get(session[:user]).max_practice_scenarios
  @scenarios = Scenario.all(order: :id, active: true)
  @scenarios = @scenarios.all(workshop: false) unless user.workshop_scenarios == true


  @scenarios = @scenarios.all(practice: true) unless user.practice_exams == false
  @averages = Average.all(:user_id => session[:user], :scenario_id.not => nil)
  @remaining_practice_scenarios = User.get(session[:user]).remaining_practice_scenarios
  @uses = []
  Use.all(user_id: session[:user]).each { |u| @uses << u.scenario_id }
  erb :'ncmhce/index-practice'
end


get '/ncmhce/scenarios/:id/?' do
	expired?

	@scenario = Scenario.get params[:id]

	if @scenario.sample?
		authorize! sample = true
	else
		authorize!
	end

	unless @scenario.sample? || @scenario.workshop? || @scenario.practice?
		if User.get(session[:user]).remaining_scenarios == 0
			unless Use.all(user_id: session[:user], scenario_id: params[:id]).count > 0
				session[:alert] = { message: "Please purchase more scenarios to continue." }
				redirect '/ncmhce'
			end
		end
	end

	if Average.all(scenario_id: params[:id], user_id: session[:user]).count > 0
		redirect "/ncmhce/scenarios/#{params[:id]}/score"
	end
	@scores = []
	Score.all(user_id: session[:user], scenario_id: params[:id]).each {|s| @scores << s.answer_id }
	@questions = @scenario.questions order: :position
	@answers = @questions.answers order: :body
	erb :'ncmhce/scenario'
end

get '/ncmhce/scenarios/:id/score/?' do
	expired?

	@scenario = Scenario.get params[:id]

	if @scenario.sample?
		authorize! sample = true
	else
		authorize!
	end

	@scores = []
	scores = Score.all(user_id: session[:user], scenario_id: params[:id])
	scores.each {|s| @scores << s.answer_id }

	@questions = @scenario.questions order: :position
	@answers = @questions.answers order: :body

	actual_total = 0
	scores.each {|s| actual_total = actual_total + s.value}
	possible_total = 0
	@answers.each {|a| possible_total = possible_total + a.value if a.value > 0}

	@average = ((actual_total.to_f/possible_total.to_f)*100).to_i
	@average = 0 if @average < 0
	a = Average.first_or_create(scenario_id: params[:id], user_id: session[:user], score: @average)
	Use.first_or_create(user_id: session[:user], scenario_id: params[:id], sample: @scenario.sample)

	@breakdown = {}
	@breakdown['Information Gathering'] = {possible: 0, correct: 0}
	@breakdown['Decision Making']				= {possible: 0, correct: 0}
    
	@answers.each do |a|
		@breakdown[a.question.score_type][:possible] += a.value if a.value > 0
	end

	scores.each do |s|
		@breakdown[s.score_type][:correct]  += s.value
	end

  info_gathering = Scoretype.first_or_create(
    type: "Information Gathering",
    scenario_id: @scenario.id,
    user_id: session[:user]
  )
    
  info_gathering.update(
    possible: @breakdown["Information Gathering"][:possible],
    correct: @breakdown["Information Gathering"][:correct]
  )

  decision_making = Scoretype.first_or_create(
    type: "Decision Making",
    scenario_id: @scenario.id,
    user_id: session[:user]
  )
  
  decision_making.update(
    possible: @breakdown["Decision Making"][:possible],
    correct: @breakdown["Decision Making"][:correct]
  )
  
	erb :'ncmhce/scenario'
end

get '/ncmhce/scenarios/:id/restart/?' do
	authorize!
	expired?

	Score.all(user_id: session[:user], scenario_id: params[:id]).destroy
	Average.all(scenario_id: params[:id], user_id: session[:user]).destroy
	redirect "/ncmhce/scenarios/#{params[:id]}"
end
