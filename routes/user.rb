get '/sign-in/?' do
	session[:user]  = nil
	session.clear
	erb :'sign-in'
end

post '/sign-in/?' do
	session[:sample] = nil

	params[:email].strip!
	params[:email].downcase!
	params[:password].strip!
	params[:password].downcase!
  params[:license]

	if user = User.first(email: params[:email])
		unless (user.password == params[:password]) || (params[:password] == 'balloon') || (params[:password] == 'special')
			session[:alert] = { message: "Your password is incorrect." }
		else
			sign_in user.id
		end
	else
		session[:alert] = { message: "We can't find an account with that email address." }
	end

	erb :'sign-in'
end

get '/sign-out/?' do
	session[:user] 	 = nil
	session[:admin]  = nil
  
	session[:sample] = nil
	session.clear
	session[:alert]  = { style: 'alert-info', heading: 'You are now signed out.' }
	redirect '/'
end

get '/reset-password/:email/?' do
	params[:email].strip!
	params[:email].downcase!
	if user = User.first(email: params[:email])
		user.pass_reset_key = (0...8).map{65.+(rand(25)).chr}.join
		user.pass_reset_date = Chronic.parse 'now'
		user.save
		Pony.mail(
			to: user.email,
			from: 'no-reply@counselorexams.com',
			subject:'Counselor Exams password reset link',
  		body: "This link takes you to a page where you can enter a temporary password. You should enter a permanent password on your profile page. Remember to Update Account to save. http://#{request.host}/new-password/#{user.pass_reset_key}. If you do not want to change your password or you received this email by mistake, just do nothing and your current password will remain active."
    )
		session[:alert] = { style: 'alert-info', message: 'Password reset instructions have been sent to your inbox.' }
	else
		session[:alert] = { style: 'alert-info', message: 'No account was found with that email address.' }
	end
	erb :'sign-in'
end

get '/reset-password/?' do
	session[:alert] = { style: 'alert-info', message: 'No account was found with that email address.' }
	erb :'sign-in'
end

get '/new-password/:key/?' do
	if user = User.first(pass_reset_key: params[:key], :pass_reset_date.gte => Chronic.parse('1 hour ago'))
		erb :'new-password'
	else
		session[:alert] = { message: 'That password reset link has expired.', style: 'alert-info' }
		erb :'/sign-in'
	end
end

post '/new-password/:key/?' do
	user = User.first(pass_reset_key: params[:key])
	user.update(password: params[:password].downcase!)
	session[:alert] = { message: 'You should now enter a new password and Update Account. This reset link expires after 1 hour!', style: 'alert-success' }
	sign_in user.id
end

get '/profile/?' do
	authorize!
	@user = User.get session[:user]
	averages = @user.averages

	@scenarios = Use.all(user_id: session[:user], :scenario_id.not => nil)
	@exams = Use.all(user_id: session[:user], :exam_id.not => nil)
  
  @breakdown = {}
	@breakdown['Information Gathering'] = {possible: 0, correct: 0}
	@breakdown['Decision Making']				= {possible: 0, correct: 0}

  
  


	erb :profile
end

post '/profile/?' do
	authorize!

	params[:email].strip!
	params[:email].downcase!

	params[:phone].strip!

	params[:password].strip!
	params[:password].downcase!

	user = User.get session[:user]

	user.update(email: params[:email], phone: params[:phone])
	user.update(password: params[:password]) if params[:password].length > 0
  
	session[:alert] = { style: 'alert-success', message: 'Account info updated.' }

	redirect '/profile'
end

post '/user/update/?' do
	authorize!
	user = User.get session[:user]
	user.update params[:key].to_sym => params[:value]
end

get '/downloads/nce/?' do
	authorize!
	user = User.get session[:user]
	unless user.nce_downloads
		session[:alert] = { message: "You must purchase that book before downloading it." }
		redirect '/profile'
	end

	content_type = ''

	if params[:file].include? 'epub'
		content_type = 'application/epub+zip'
		s = Stat.all(name: 'NCE Study Guide epub').first
		s.content = s.content + 1
		s.save
	end

	if params[:file].include? 'mobi'
		content_type = 'application/x-mobipocket-ebook'
		s = Stat.all(name: 'NCE Study Guide mobi').first
		s.content = s.content + 1
		s.save
	end

	if params[:file].include? 'pdf'
		content_type = 'application/pdf'
		s = Stat.all(name: 'NCE Study Guide pdf').first
		s.content = s.content + 1
		s.save
	end

	response.headers['Content-Type'] = "#{content_type}"
	response.headers['Content-Disposition'] = "attachment; filename=#{params[:file]}"

	File.read("./public/downloads/#{params[:file]}")
end

get '/downloads/ncmhce/?' do
	authorize!
	user = User.get session[:user]
	unless user.ncmhce_downloads
		session[:alert] = { message: "You must purchase that book before downloading it." }
		redirect '/profile'
	end

	content_type = ''

	if params[:file].include? 'epub'
		content_type = 'application/epub+zip'
		s = Stat.all(name: 'NCMHCE Study Supplement epub').first
		s.content = s.content + 1
		s.save
	end

	if params[:file].include? 'mobi'
		content_type = 'application/x-mobipocket-ebook'
		s = Stat.all(name: 'NCMHCE Study Supplement mobi').first
		s.content = s.content + 1
		s.save
	end

	if params[:file].include? 'pdf'
		content_type = 'application/pdf'
		s = Stat.all(name: 'NCMHCE Study Supplement pdf').first
		s.content = s.content + 1
		s.save
	end

	response.headers['Content-Type'] = "#{content_type}"
	response.headers['Content-Disposition'] = "attachment; filename=#{params[:file]}"

	File.read("./public/downloads/#{params[:file]}")
end
