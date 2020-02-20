get '/checkout/:product/?' do
	@product_name = ''
	case params[:product]
	when 'nce'
		@product_name = "Dr. Arthur's NCE Study Program"
	when 'nce-upgrade'
		@product_name = "Dr. Arthur's NCE Study Program"
	when 'nce-hard-copy'
		@product_name = "Dr. Arthur's NCE Study Guide"
	when 'ncmhce'
		@product_name = "Arthur-Brende NCMHCE Study Program"
	when 'ncmhce-upgrade'
		@product_name = "Arthur-Brende NCMHCE Study Program"
	when 'ncmhce-hard-copy'
		@product_name = "Arthur-Brende NCMHCE Study Program"
	when 'ncmhce-exam-scenarios'
		@product_name = "Arthur-Brende NCMHCE Study Program"
  when 'second-chance-upgrade'
		@product_name = "Arthur-Brende NCMHCE Study Program"
	when 'account-extension'
		@product_name = "Extend Your Account"
	when 'account-expiration'
		@product_name = "Extend Your Account"
		unless @user = User.first(email: params[:account])
			session[:alert] = { message: "Your account has expired." }
			redirect('/sign-in')
		end
	end

	unless @user
		@user = User.get(session[:user]) if session[:user]
	end

	erb :'checkout/index'
end

post '/checkout/:product/?' do

  unless params[:user_id]
		params[:email].strip!
		params[:email].downcase!
		params[:password].strip!
		params[:password].downcase!
  end
	params[:name] = "#{params[:first_name]} #{params[:last_name]}"
	params[:address1].strip!
	params[:address2].strip!
	params[:city].strip!
	params[:state].strip!
	params[:zip].strip!
	
  if params[:user_id]
		user = User.get params[:user_id]
		params[:email] = user.email
  else
		user = User.new(email: params[:email],
		                password: params[:password],
                        name: params[:name],
                     license: params[:license],
               hear_about_us: params[:hear_about_us],
                   max_exams: 0,
               max_scenarios: 0,
               nce_downloads: false,
            ncmhce_downloads: false,
              nce_flashcards: false,
           ncmhce_flashcards: false) 
  end

  case params[:package]
  when 'Basic Package'
    user.nce_downloads = true
    user.nce_flashcards = true
    user.max_exams = (user.max_exams + 2)
    params[:package] = 'NCE: Basic Package'
               email = 'nce'
                 msg = true
    params[:optional] ? params[:optional] = '+ Hard Copy' : params[:optional] = '+ eBook'
    
  when 'Enhanced Package'
    user.nce_downloads = true
    user.nce_flashcards = true
    user.max_exams = (user.max_exams + 4)
    params[:package] = 'NCE: Enhanced Package'
               email = 'nce'
                 msg = true
    params[:optional] ? params[:optional] = '+ Hard Copy' : params[:optional] = '+ eBook'

  when 'Starter Package'
    user.ncmhce_downloads = true
    user.ncmhce_flashcards = true
    user.max_scenarios = (user.max_scenarios + 12)
    params[:package] = 'NCMHCE: Starter Package'
               email = 'ncmhce'
                 msg = true
    params[:optional] ? params[:optional] = '+ Hard Copy' : params[:optional] = '+ eBook'

  when 'Full Package'
    user.ncmhce_downloads = true
    user.ncmhce_flashcards = true
    user.max_scenarios = (user.max_scenarios + 36)
    user.max_practice_scenarios = (user.max_practice_scenarios + 10)
    params[:package] = 'NCMHCE: Full Package'
               email = 'ncmhce'
                 msg = true
    params[:optional] ? params[:optional] = '+ Hard Copy' : params[:optional] = '+ eBook'

  when 'Second Chance Upgrade'
    user.max_scenarios = (user.max_scenarios + 24)
    user.max_practice_scenarios = (user.max_practice_scenarios + 10)
      params[:package] = 'NCMHCE: Second Chance Upgrade'
                 email = 'ncmhce'
                   msg = false

  when 'NCE Upgrade'
    user.max_exams = (user.max_exams + 2)
    params[:package] = 'NCE: Upgrade'
                 msg = false

  when 'NCE Hard Copy'
    params[:package] = 'NCE: Hard Copy'
                 msg = false

  when 'NCMHCE Upgrade'
    user.max_scenarios = (user.max_scenarios + 12)
    params[:package] = 'NCMHCE: Upgrade'
                 msg = false

  when 'NCMHCE Hard Copy'
    params[:package] = 'NCMHCE: Hard Copy'
		             msg = false
                 
  when 'NCMHCE Exam Scenarios'
    user.max_practice_scenarios = (user.max_practice_scenarios + 10)
    params[:package] = 'NCMHCE: Exam Scenarios'
     		         msg = false
  
  when 'Account Extension'
    params[:package] = 'Account Extension'
                 msg = false
    
  when 'Account Expiration'
    params[:package] = 'Account Expiration'
                 msg = false
    
  end
    
  if params[:user_id]
		if (params[:package] == 'Account Extension')
			user.expiration_date = (user.expiration_date + 90)
    elsif (params[:package] == 'Account Expiration')
      user.expiration_date = (DateTime.now + 90)
  	elsif (params[:package] == 'NCMHCE: Hard Copy') || (params[:package] == 'NCE: Hard Copy') || (params[:package] == 'NCMHCE: Second Chance Upgrade')
  		user.expiration_date = (user.expiration_date + 0)
  	elsif (params[:package] == 'NCMHCE: Exam Scenarios')
  		user.expiration_date = (user.expiration_date + 90)
		else
			user.expiration_date = (DateTime.now + 365)
		end
    user.save
  end
  
  Stripe.api_key = STRIPE_PRIVATE_KEY
  
  if charge = Stripe::Charge.create(amount: (params[:amount].to_f * 100).to_i,
                               currency: "usd",
                                   card: params[:stripeToken],
                            description: "#{params[:name]} (#{params[:email]}) #{params[:package]} #{params[:optional]}")
    user.save
  	user.purchases.create(package: params[:package],
  		                    options: params[:optional],
                         options2: params[:optional2],
                        stripe_id: charge.id,
                           amount: params[:amount],
                         address1: params[:address1],
                         address2: params[:address2],
                             city: params[:city],
                            state: params[:state],
                              zip: params[:zip])
  
    
    if settings.environment == 'production'
      if (params[:package] == 'NCMHCE: Starter Package')
        Email.welcome(user.email, user.name, user.email, email, "#{params[:package]} #{params[:optional]}", params[:amount])
        Email.secondchance(user.email, user.name)
      else  
        Email.welcome(user.email, user.name, user.email, email, "#{params[:package]} #{params[:optional]}", params[:amount])
      end
    end
    
    sign_in user.id, msg: msg
  else
    session[:alert] = { style: 'alert-error',
                      message: "There was an error charging your card. Please call support at 888-326-9229, Monday - Friday, 9:00 AM - 5:00 PM EST." }
    redirect request.referrer
  end
end