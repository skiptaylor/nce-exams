get '/admin/users/?' do
	admin!
	
	@users = User.all
	if params[:search] && !params[:search].nil?
		@users = User.all(conditions: ["email ILIKE ? or name ILIKE ? or license ILIKE ?", "%#{params[:search].strip}%", "%#{params[:search].strip}%", "%#{params[:search].strip}%"], limit: 50)
	else
		@users = User.all(:email.not => 'sample', order: [:updated_at.desc], limit: 50)
	end
	erb :'admin/users'
end

get '/admin/users/new/?' do
	admin!
	@user = User.new
	erb :'admin/user'
end

post '/admin/users/new/?' do
	admin!
	puts 'Formatting input'
	params[:email].strip!
	params[:email].downcase!
	
	params[:name].strip!

	params[:phone].strip!
	params[:phone].downcase!
	
	params[:password].strip!
	params[:password].downcase!
    
  params[:expiration_day] = '30' if params[:expiration_day] == '31'
	
	params[:max_exams].is_numeric? ? params[:max_exams] = params[:max_exams].to_i : params[:max_exams] = user.max_exams
	params[:max_scenarios].is_numeric? ? params[:max_scenarios] = params[:max_scenarios].to_i : params[:max_scenarios] = user.max_scenarios
  params[:max_practice_scenarios].is_numeric? ? params[:max_practice_scenarios] = params[:max_practice_scenarios].to_i : params[:max_practice_scenarios] = user.max_practice_scenarios
  
  puts 'Creating user'
	user = User.create(
		admin: 					 	false,
		email: 					 	        params[:email],
		password: 			 	        params[:password],
		name:  				 	 	        params[:name],
		phone: 				 	 	        params[:phone],
		notes:					 	        params[:notes],
    license:					        params[:license],
		max_exams: 		 	 	        params[:max_exams],
		max_scenarios: 	 	        params[:max_scenarios],
    max_practice_scenarios: 	params[:max_practice_scenarios],
		ncmhce_downloads: false,
		nce_downloads: 		false,
    nce_flashcards: 	 false,
    ncmhce_flashcards: false,
		expiration_date: Date.from_fields(
			params[:expiration_year],
			params[:expiration_month],
			params[:expiration_day]
		)
	)
	
  puts 'Updating admin'
	user.update(admin: true) if params[:admin]
  
  puts 'Updating practice'
  user.update(practice: true) if params[:practice]
	
  puts 'Updating downloads'
	user.update(ncmhce_downloads: true) if params[:ncmhce_downloads]
	user.update(nce_downloads: true) if params[:nce_downloads]
  
	user.update(ncmhce_flashcards: true) if params[:ncmhce_flashcards]
	user.update(nce_flashcards: true) if params[:nce_flashcards]

	user.update(workshop_scenarios: true) if params[:workshop_scenarios]
    
  user.update(practice_scenario: true) if params[:practice_scenario]
  
  user.update(practice_exams: true) if params[:practice_exams]
  
  puts 'Setting session and redirecting'
	session[:alert] = { style: 'alert-success', message: "#{user.name} has been created." }
	redirect "/admin/users/#{user.id}"
end

get '/admin/users/:id/?' do
	admin!
	
	@user = User.get params[:id]
  
	@scenarios = Use.all(user_id: @user.id, :scenario_id.not => nil)
	@exams = Use.all(user_id: @user.id, :exam_id.not => nil)
  
	erb :'admin/user'
end

post '/admin/users/:id/?' do
	admin!
	
	user = User.get params[:id]
	
	params[:email].strip!
	params[:email].downcase!

	params[:name].strip!

	params[:phone].strip!
	params[:phone].downcase!
    
  params[:expiration_day] = '30' if params[:expiration_day] == '31'
	
	params[:max_exams].is_numeric? ? params[:max_exams] = params[:max_exams].to_i : params[:max_exams] = user.max_exams
	params[:max_scenarios].is_numeric? ? params[:max_scenarios] = params[:max_scenarios].to_i : params[:max_scenarios] = user.max_scenarios
  params[:max_practice_scenarios].is_numeric? ? params[:max_practice_scenarios] = params[:max_practice_scenarios].to_i : params[:max_practice_scenarios] = user.max_practice_scenarios
  
  
  
	user.update(
		email: 				 	          params[:email],
		name:  				 	          params[:name],
		phone: 				 	          params[:phone],
		notes:					          params[:notes],
    license:				          params[:license],
		max_exams: 		 	          params[:max_exams],
		max_scenarios: 	          params[:max_scenarios],
    max_practice_scenarios: 	params[:max_practice_scenarios],
		expiration_date: Date.from_fields(
			params[:expiration_year],
			params[:expiration_month],
			params[:expiration_day]
		)
	)
	
	unless params[:refund_request_year] == '' || params[:refund_request_month] == '' || params[:refund_request_day] == ''
		user.update(refund_request_date: Date.from_fields(params[:refund_request_year], params[:refund_request_month], params[:refund_request_day]))
	else
		user.update(refund_request_date: nil)
	end

	unless params[:refund_check_year] == '' || params[:refund_check_month] == '' || params[:refund_check_date] == ''
		user.update(refund_check_date: Date.from_fields(params[:refund_check_year], params[:refund_check_month], params[:refund_check_day]))
	else
		user.update(refund_check_date: nil)
	end
	
	params[:password].strip!
	params[:password].downcase!
	user.update(password: params[:password]) unless params[:password].length == 0
		
	params[:admin] ? user.update(admin: true) : user.update(admin: false)
  
	params[:ncmhce_downloads] ? user.update(ncmhce_downloads: true) : user.update(ncmhce_downloads: false)
	params[:nce_downloads] ? user.update(nce_downloads: true) : user.update(nce_downloads: false)
  
	params[:ncmhce_flashcards] ? user.update(ncmhce_flashcards: true) : user.update(ncmhce_flashcards: false)
	params[:nce_flashcards] ? user.update(nce_flashcards: true) : user.update(nce_flashcards: false)
	
	params[:workshop_scenarios] ? user.update(workshop_scenarios: true) : user.update(workshop_scenarios: false)
  params[:practice_exams] ? user.update(practice_exams: true) : user.update(practice_exams: false)
	
	session[:alert] = { style: 'alert-success', message: "#{user.name} has been updated." }
	redirect "/admin/users/#{user.id}"
end

get '/admin/users/:id/delete/?' do
	admin!
	@user = User.get params[:id]
  @user.remove
	session[:alert] = { style: 'alert-success', message: "User has been removed." }
	redirect request.referrer
end

get '/admin/users/:id/remove/?' do
	admin!
	@user = User.get params[:id]
  @user.remove
	session[:alert] = { style: 'alert-success', message: "User has been removed." }
	redirect "/admin/users"
end

get '/admin/users/:id/remove_sample/?' do
	admin!
	@user = User.get params[:id]
  @user.remove
	session[:alert] = { style: 'alert-success', message: "Sample has been removed." }
	redirect request.referrer
end
