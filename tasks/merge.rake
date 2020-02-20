# To merge a git repo:
#   rake merge:git[repo_url]
#  or with a tag:
#   rake merge:git[repo_url,tag]

# Shorthand for a Github repo:
#   rake merge:github[username/repo]
#  or with a tag:
#   rake merge:github[username/repo,tag]

# Example:
#   rake merge:git[git@github.com:jarrodtaylor/my-template.git,v1.0]

namespace :merge do

	desc 'Merges a git repo into the application'
	task :git, :repo, :tag do |t, args|
		if args.count == 0
			puts 'You must specify a git reop: rake merge:git[repo_url]'
		else
			repo = (/[^\/]+$/.match args.repo).to_s.sub('.git', '')
			require 'fileutils'
			system "git clone #{args.repo} tmp/clone"
			system "cd tmp/clone && git checkout #{args.tag}" if args.tag
			FileUtils.rm_r 'tmp/clone/.git'
			FileUtils.chmod_R 0755, 'tmp/clone'
			["readme.*", "Gemfile", "Gemfile.lock"].each do |files|
				Dir["tmp/clone/#{files}"].each { |file| File.delete file }
			end
			Dir["tmp/clone/**/*"].each do |path|
				new_path = path.sub 'tmp/clone/', ''
				if File.directory? path
					FileUtils.mkdir(new_path) unless Dir.exists? new_path
				else
					puts "Moving #{new_path}"
					FileUtils.cp path, new_path
				end
			end
			puts 'Removing tmp/clone'
			FileUtils.rm_r 'tmp/clone'
		end
	end
	
	desc 'Shorthand for merging GitHub repos'
	task :github, :repo, :tag do |t, args|
		if args.count == 0
			puts 'You must specify a git reop: rake merge:github[username/repo]'
		else
			if args.tag
				Rake::Task['merge:git'].invoke  "https://github.com/#{args.repo}.git", args.tag
			else
				Rake::Task['merge:git'].invoke  "https://github.com/#{args.repo}.git"
			end
		end
	end

end