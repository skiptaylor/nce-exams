namespace :app do
	
	# ~: rake app:irb
	desc 'Loads the application into an IRB session'
	task :irb do
		require 'irb'
		ARGV.clear
		IRB.start
	end
	
	# ~: rake app:server
	desc 'Loads the application into a development server'
	task(:server) { exec 'ruby chassis.rb' }
		
end