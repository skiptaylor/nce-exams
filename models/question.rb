class Question
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

	property :body,       Text, lazy: false
	property :notes,      Text, lazy: false
	property :score_type, String
	property :countable,	Boolean, default: true
	property :position,   Integer

	belongs_to :scenario, required: false
	belongs_to :exam,     required: false
	has n,     :answers, :constraint => :destroy

	def passed? user
		if self.exam_id
			return true if self.answers.scores.first user_id: user
		elsif self.scenario_id
			required_answers = self.answers.all required: 't'
			if required_answers.count > 0
				answered = 0
				required_answers.each {|a| answered += 1 if a.scores.first user_id: user}
				return true if answered == required_answers.count
			else
				return true if self.answers.scores.first user_id: user
			end
		end

		return false
	end

	def stop?
		unless self.scenario_id
			return false
		else
			required_answers = self.answers.all required: 't'
			if required_answers.count > 0
				return true
			else
				return false
			end
		end
	end

	def remove
		self.answers.each {|a| a.remove}
		self.destroy!
	end
  
end