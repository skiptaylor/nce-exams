# You can run DataMapper migrations with the Rake task:
#   ~: rake dm:migrate:up[1]
# Migrating down works the same:
#   ~: rake dm:migrate:down
# If you don't reference a migration number, all migrations will be run.
# See the DataMapper docs for more info.

# migration 1, :create_widgets do
# 
# 	up do
# 		create_table :widgets do
# 			column :id, Integer, serial: true
# 			column :name, String
# 		end
# 	end
# 	
# 	down do
# 		drop_table :widgets
# 	end
# 
# end