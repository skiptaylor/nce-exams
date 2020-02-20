class Use
	include DataMapper::Resource

	property   :id,        Serial
	property   :delete_at, ParanoidDateTime
	timestamps :at

	property :sample,   Boolean, default: false
    
  property :certificate, 	Boolean, default: false
  property :cert_date, 	  Date
  property :cert_name, 	  String,	 default: ""
   
	belongs_to :user
	belongs_to :scenario, required: false
	belongs_to :exam, 		required: false
  
end