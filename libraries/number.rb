# Number extensions:
#
# n = 12.345
#
# n.dollarize => "$12.35"
# dollarize doesn't do any currency conversions, just string formatting.
#
# n.even? => false
# n.odd?  => true
#
# n.truncate_to_decimal(1) => 12.3

Numeric.class_eval do
	
	def dollarize
		"$%.2f" % self.to_f
	end
	
	def even?
		self%2 == 0
	end
	
	def odd?
		self%2 != 0
	end
	
	def truncate_to_decimal dec = 1
		rounded = "%.#{dec}f" % self.to_f
		rounded = rounded.to_s.split('.').first if rounded.to_s.end_with?('0')
		rounded.to_f
	end
	
end