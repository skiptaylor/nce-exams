class Average
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

	property :score, Integer

	belongs_to :scenario, required: false
	belongs_to :exam,     required: false
	belongs_to :user

	def remove
		self.destroy!
	end

end