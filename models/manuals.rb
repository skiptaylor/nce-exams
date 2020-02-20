class Manual
  include DataMapper::Resource
  
  property   :id,         Serial
  property   :deleted_at, ParanoidDateTime
  timestamps :at
  
  property :name,       Text,    default: ''
  property :title_page, Text,    default: ''
  property :version,    Text,    default: ''
  property :isbn,       Text,    default: ''
  
  property :ncmhce,  Boolean, default: false
  property :nce,     Boolean, default: false
  property :ceu,     Boolean, default: false
  
  has n, :sections, :constraint => :destroy
  
end

class Section
  include DataMapper::Resource
  
  property   :id,         Serial
  property   :deleted_at, ParanoidDateTime
  timestamps :at

  property :section_number, Text,    default: ''
  property :section_title,  Text,    default: ''
  
  belongs_to :manual, required: false
  has n, :chapters, :constraint => :destroy
  
end

class Chapter
  include DataMapper::Resource
  
  property   :id,         Serial
  property   :deleted_at, ParanoidDateTime
  timestamps :at

  property :chapter_number,     Text, default: ''
  property :chapter_title,      Text, default: ''
  property :sub_chapter_title,  Text, default: ''
  property :body,               Text, default: ''
  
  belongs_to :section, required: false
  
end

