class Scoretype
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

	property :type, String,	 default: 'Undefined'
  property :possible, Integer,	 default: 0
  property :correct, Integer,	 default: 0

	belongs_to :scenario
	belongs_to :user

	def remove
		self.destroy!
	end

end