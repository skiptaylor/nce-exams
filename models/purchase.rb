class Purchase
	include DataMapper::Resource

	property   :id,        Serial
	property   :delete_at, ParanoidDateTime
	timestamps :at

	property :package,   String
	property :options,   String
  property :options2,   String
	property :stripe_id, String
	property :amount,	   Float
	property :address1,  String
	property :address2,  String
	property :city, 		 String
	property :state, 		 String
	property :zip, 			 String

	property :shipped_on,  Date
	property :received_on, Date
	property :tracking_number, String

	belongs_to :user
	
	def shipping_status
		color = 'warning'		
		color = 'important' if shipped_on
		color = 'success' if received_on
		color
	end

	def remove
		self.destroy!
	end

end