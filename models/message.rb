class Message
  include DataMapper::Resource
  
  property   :id,         Serial
  property   :deleted_at, ParanoidDateTime
  timestamps :at
  
  property :body,    Text,    default: ''
  property :ncmhce,  Boolean, default: false
  property :nce,     Boolean, default: false
  property :profile, Boolean, default: false
  property :exams,   Boolean, default: false
  
end
