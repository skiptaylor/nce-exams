# String extensions:
#
# s = 'hello world'
#
# s.is_numeric? => false
#
# s.titleize => "Hello World"
#
# s.truncate(1) => "hello..."
# Option: end_string (defaults to '...')

String.class_eval do
	
	def is_numeric?
		true if Float(self) rescue false
	end
		
	def titleize
		title = ''
		self.split(' ').each {|s| title << s.capitalize + ' ' }
		title
	end
	
	def truncate word_count = 100, end_string = '...'
		return if self == nil
		words = self.split()
		words[0..(word_count-1)].join(' ') + (words.length > word_count ? end_string : '')
	end
	
end