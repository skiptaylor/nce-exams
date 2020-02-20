# Seed files in the ./data/seeds directory can be run one at a time, or all at once:
#  ~: rake dm:seed[users]
# or
#  ~: rake db:seed:all

User.create email: 'skip@tayloraid.com', password: 'balloon'
User.create email: 'tayloraid@gmail.com', password: 'revolver', admin: 'true'