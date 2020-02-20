class Issue
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

	property :name,     Text, default: ''
  property :problem,  Text, default: ''
	property :solution, Text, default: ''
  
end