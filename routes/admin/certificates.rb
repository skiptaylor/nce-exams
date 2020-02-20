get '/admin/certificates/?' do
	admin!
	
	@uses = Use.all(:cert_date.not => nil)
  # if params[:search] && !params[:search].nil?
#     @uses = Use.all(conditions: ["cert_date ILIKE ?", "%#{params[:search].strip}%"])
#   else
#     @uses = Use.all(:cert_date.not => nil, limit: 30)
#   end

	erb :'admin/certificates'
end

