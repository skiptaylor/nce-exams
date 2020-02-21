
["/home/?", "/account/?"].each do |path|
  get path do
    redirect '/'
  end
end

get('/?') { session[:user] ? redirect('/profile') : redirect('/welcome') }

get ('/how-it-works/?') { redirect '/how-it-works/intro' }