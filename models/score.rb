class Score
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

	property :value,    	  Integer, default: 0
	property :score_type,   String,	 default: 'Undefined'
	property :countable,	  Boolean, default: true
	property :required, 	  Boolean, default: false

	belongs_to :user
	belongs_to :answer
	belongs_to :question
	belongs_to :scenario, required: false
	belongs_to :exam,     required: false

	def remove
		self.destroy!
	end

end

post '/add-score/?' do

	answer = Answer.get params[:answer]

	Score.all(user_id: session[:user], question_id: answer.question_id).destroy if answer.question.exam_id

	Score.all(user_id: session[:user], answer_id: answer.id).destroy if answer.question.scenario_id

	Score.create(
		user_id: 		 session[:user],
		answer_id: 	 answer.id,
		question_id: answer.question_id,
		exam_id: 		 answer.question.exam_id,
		scenario_id: answer.question.scenario_id,
		value: 			 answer.value,
		required:		 answer.required,
		score_type:  answer.question.score_type,
		countable: 	 answer.question.countable
	)
	
	sample = false
	
	if answer.question.scenario_id
		sample = true if answer.question.scenario.sample
	elsif answer.question.exam_id
		sample = true if answer.question.exam.sample
	end
	
	Use.first_or_create(
		user_id: session[:user],
		scenario_id: answer.question.scenario_id,
		exam_id: answer.question.exam_id,
		sample: sample
	)
end