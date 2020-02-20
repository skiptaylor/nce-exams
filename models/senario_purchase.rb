class Senario_purchase
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

	property :purchase_date, Date

	belongs_to :user

	def remove_purchase_date
		self.destroy!
	end

end