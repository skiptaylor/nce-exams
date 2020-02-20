class Stat
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

	property :name, String
	property :content, Integer, default: 0

end