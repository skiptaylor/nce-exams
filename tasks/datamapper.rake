# See the DataMapper docs for more info.

namespace :dm do

	desc 'Restores a local Postgres DB to the most recent backup'
	task :restore, :db do |t, args|
		system "pg_restore -d #{args.db} #{Dir['./data/backups/*'].last}"
	end

	# ~: rake dm:setup
	desc 'Creates a new seeded database'
	task setup: ['dm:migrate', 'dm:seed:all']
	
	# ~: rake dm:upgrade
	# Or for a single model:
	# ~: rake dm:upgrade[model_file_name]
	desc 'Auto upgrade the database based on models, non-destructive'
	task :upgrade, :model do |t, args|
		if args.count > 0
			args.model.constantize.auto_upgrade!
		else
			DataMapper.auto_upgrade!
		end
	end

	# ~: rake dm:migrate
	# Or for a single model:
	# ~: rake dm:migrate[model_file_name]
	desc 'Auto migrates the database based on models, destructive'
	task :migrate, :model do |t, args|
		if args.count > 0
			args.model.constantize.auto_migrate!
		else
			DataMapper.auto_migrate!
		end
	end
	
	namespace :migrate do
		
		# ~: rake dm:migrate:up
		# Or for a specific migration:
		# ~: rake dm:migrate:up[migration_number]
		desc 'Migrates the database up based on migrations'
		task :up, :number do |t, args|
			require 'dm-migrations/migration_runner'
			Dir["./data/migrations/*.rb"].each { |file| require file }
			if args.count > 0
				migrate_up! args.number
			else
				migrate_up!
			end
		end

		# ~: rake dm:migrate:down
		# Or for a specific migration:
		# ~: rake dm:migrate:down[migration_number]
		desc 'Migrates the database down based on migrations'
		task :down, :number do |t, args|
			require 'dm-migrations/migration_runner'
			Dir["./data/migrations/*.rb"].each { |file| require file }
			if args.count > 0
				migrate_down! args.number
			else
				migrate_down!
			end
		end
		
	end
	
	# ~: rake dm:seed[filename]
	desc 'Seeds the database from a single seed file'
	task :seed, :file do |t, args|
		if args.count > 0
			require "./data/seeds/#{args.file}"
		else
			require './data/seeds'
		end
	end
	
	namespace :seed do
	
		# ~: rake dm:seed
		desc 'Seeds that database from all the seed files'
		task :all do
			require './data/seeds'
			Dir["./data/seeds/**/*.rb"].each { |file| require file }
		end
	
	end

end