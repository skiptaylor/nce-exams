class Scenario
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

	property :title, Text, 		 lazy: false
	property :body,  Text,		 lazy: false
  
  property :references,  Text,		 lazy: false
	
	property :active,	  Boolean, default: true
	property :sample,   Boolean, default: false
	property :workshop, Boolean, default: false
  property :practice, Boolean, default: false


	has n, :questions, :constraint => :destroy
	has n, :averages,  :constraint => :destroy
	
	def group_average
		averages = self.averages
		avg = 0
		averages.each {|a| avg += a.score}
		avg = (avg/averages.count).to_i
	end

	def remove
		self.questions.each {|q| q.remove}
		self.averages.each  {|a| a.remove}
		Use.all(scenario_id: self.id).destroy
		self.destroy!
	end
  
  
end