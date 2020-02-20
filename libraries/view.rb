helpers do
	
	def active path
		path = Array[path] unless path.kind_of? Array
		match = false
		path.each {|p| match = true if request.path_info.include? p }
		'active' if match
	end
	
	def alert
		unless session[:alert].nil?
			session[:alert][:style]   ||= ''
			session[:alert][:heading] ||= ''
			session[:alert][:message] ||= ''
			msg =  ''
			msg << "<div class='alert #{session[:alert][:style]}'>"
			msg << "<a class='close' data-dismiss='alert'>x</a>"
			msg << "<h4 class='alert-heading'>#{session[:alert][:heading]}</h4>" unless session[:alert][:heading] == ''
			msg << "#{session[:alert][:message]}"
			msg << "</div>"
			session[:alert] = nil
			msg
		end
	end
	
	def hidden
		'display: none;'
	end
	
end