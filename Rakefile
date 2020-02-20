# Loads the app so it's available to all Rake tasks
require './chassis'

# Requires all .rake files in the ./tasks directory
#   You can see the available Rake tasks by running:
#   ~: rake -T
Dir["tasks/**/*"].each do |file|
	unless File.directory? file
		file.sub!('tasks', '').sub!('.rake', '')
		Rake.application.rake_require file, paths = ["./tasks"]
	end
end