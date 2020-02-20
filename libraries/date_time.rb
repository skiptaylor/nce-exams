# Date, Time, and DateTime extensions:
#
# t = Time.now => 2012-08-21 22:02:45 -0400
#
# t.display(:date) => "Tuesday Aug 21, 2012"
# Format options: :date, :day, :day_with_time, :american_day
#
# t.to_fields('my_date')
# Will output form select fields with the following IDs and name:
# my_date_year, my_date_month, and my_date_day
# Options: class_name, start_year, end_year
#
# The submitted to_fields form selects can be can be processed (and saved to a database):
# Date.from_fields(params[:my_date_year], params[:my_date_month], params[:my_date_day])

module Chassis
	module DateTime
	
		def self.included base
			base.extend ClassMethods
		end
		
		module ClassMethods
			def from_fields year, month, day
				Chronic.parse("#{year}-#{month}-#{day}")
			end
		end
		
		def display format = :date
			case format
			when :date
				string = "%A %b %d, %Y"
			when :day
				string = "%b %d, %Y"
			when :day_with_time
				string = "%b %d, %Y at %I:%M%P"
			when :american_day
				string = "%m/%d/%y"
			end
			self.strftime string
		end
    
		def display_short format = :day
			case format
			when :date
				string = "%A %b %d, %Y"
			when :day
				string = "%b %d, %Y"
			when :day_with_time
				string = "%b %d, %Y at %I:%M%P"
			when :american_day
				string = "%m/%d/%y"
			end
			self.strftime string
		end
		
		def to_fields field
			empty_date = true if self.strftime('%Y').to_i < 0
	
			date_field = ""
	
			date_field << "<select name='#{field}_month' id='#{field}_month' style='width: 60px;'>"
			date_field << "<option value=''></option>"
			(1..12).each do |m|
				date_field << "<option value='#{m}' #{'selected' if !empty_date && m == self.strftime('%m').to_i}>#{m}</option>"
			end
			date_field << "</select> &nbsp;"
	
			date_field << "<select name='#{field}_day' id='#{field}_day' style='width: 60px;'>"
			date_field << "<option value=''></option>"
			(1..31).each do |d|
				date_field << "<option value='#{d}' #{'selected' if !empty_date && d == self.strftime('%d').to_i}>#{d}</option>"
			end
			date_field << "</select> &nbsp;"
	
			date_field << "<select name='#{field}_year' id='#{field}_year' style='width: 74px;'>"
			date_field << "<option value=''></option>"
			(2007..Chronic.parse('3 years from now').strftime('%Y').to_i).each do |y|
				date_field << "<option value='#{y}' #{'selected' if !empty_date && y == self.strftime('%Y').to_i}>#{y}</option>"
			end
			date_field << "</select>"
	
			date_field
	end

	end
end

Date.class_eval			{ include Chassis::DateTime }
Time.class_eval			{ include Chassis::DateTime }
DateTime.class_eval	{ include Chassis::DateTime }