configure :production do
	before do
		
    unless request.request_method == 'POST'
  		unless request.url.include? "https://www."
  			redirect "https://www.counselorexams.com#{request.path}"
  		end
    end
		
	end
end

["/home/?", "/account/?"].each do |path|
  get path do
    redirect '/'
  end
end

get('/?') { session[:user] ? redirect('/profile') : redirect('/welcome') }

get ('/how-it-works/?') { redirect '/how-it-works/intro' }