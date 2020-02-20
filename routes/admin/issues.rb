get '/admin/issues/?' do
	admin!
	@issues = Issue.all
  
	erb :'admin/issues'
end


get '/admin/issues/new/?' do
	admin!
	@issue = Issue.new
  
	erb :'admin/issue_edit'
end

post '/admin/issues/new/?' do
	admin!
	issue = Issue.create(
		name: params[:name],
    problem: params[:problem],
		solution: params[:solution]
	)
  
	redirect "/admin/issues"
end

get '/admin/issues/:id/edit/?' do
  admin!
  @issue = Issue.get(params[:id])
  
  erb :'admin/issue_edit'
end

post '/admin/issues/:id/edit/?' do
  admin!
  issue = Issue.get(params[:id])
	issue.update(
		name: params[:name],
    problem: params[:problem],
		solution: params[:solution]
	)
  
  redirect "/admin/issues/"
end

get '/admin/issues/:id/delete/?' do
	admin!
	issue = Issue.get(params[:id])
  issue.destroy
	
	redirect "/admin/issues/"
end