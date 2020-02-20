class State
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

  property  :name,        String, :required => false
  property  :abbr,        String, :required => false
  
end