get '/admin/stats/?' do
	admin!
	@stats = Stat.all
	erb :'admin/stats'
end