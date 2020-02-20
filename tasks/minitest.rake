# To run all test in ./tests:
# ~: rake minitest

# To run a single test:
# ~: rake minitest[widget_test]

desc 'Run MiniTest on /tests'
task :minitest, :file do |t, args|
	require 'minitest/autorun'

	if args.file
		if File.exists? "./tests/#{args.file}.rb"
			require "./tests/#{args.file}"
		else
			puts "\nI can't find that test. Maybe there's a typ0?\n\n"
		end
	else
    Dir["./tests/**/*"].each { |file| require file }
	end

end