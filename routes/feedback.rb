post '/feedback/?' do
  if params[:email_name] == ""
	
  Pony.mail(
		headers: { 'Content-Type' => 'text/html' },
		to: 'counselorexams@careertrain.com, tayloraid@gmail.com',
		from: 'feedback@counselorexams.com',
		subject: params[:subject],
		body: "#{markdown params[:msg]}<hr />#{params[:name]}<br />#{params[:email]}"
	)
	redirect '/thanks'
  
  end
end