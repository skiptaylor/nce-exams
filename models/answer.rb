class Answer
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

	property :body,     Text,		 lazy: false
	property :response, Text,		 lazy: false
	property :value,    Integer, default: 0
	property :required, Boolean, default: false

	belongs_to :question
	has n,     :scores, :constraint => :destroy

  
  def remove
    self.scores.each {|s| s.delete}
    self.destroy!
  end

end

