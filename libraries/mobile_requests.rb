# Requests from phones can show separate mobile views.
# Just add .mobile to the view filename:
# my_view.erb => my_view.mobile.erb
#
# The mobile_views will turn this on and off.
# See ./settings/mobile_views.rb for options, including a list of mobile user agents.

helpers do

	def mobile_request?
		MOBILE_USER_AGENTS.any? { |agent| request.env['HTTP_USER_AGENT'] =~ agent }
	end

	def find_template(views, name, engine, &block)
		name = "#{name}.mobile" if
			 (settings.mobile_views) &&
			 (mobile_request?) 			 &&
			 (File.exists?("#{views}/#{name}.mobile.#{@preferred_extension}"))
		super views, name, engine, &block
	end

end
