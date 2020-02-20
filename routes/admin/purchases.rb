get '/admin/purchases/?' do
	admin!
	
	if params[:start_month] && params[:start_day] && params[:start_year]
    @start = Chronic.parse("#{params[:start_year]}-#{params[:start_month]}-#{params[:start_day]}")
  else
    @start = Chronic.parse('June 1, 2012')
  end

  if params[:end_month] && params[:end_day] && params[:end_year]
    @end = Chronic.parse("#{params[:end_year]}-#{params[:end_month]}-#{params[:end_day]}")
  else
    @end = Time.now
  end

	
	@purchases = Purchase.all(:created_at.gte => (@start - (12*60*60)), :created_at.lt => (@end + (12*60*60)), :order => :created_at.desc, limit: 180)
	
	if params[:export]
  	response.headers['Content-Type'] = 'text/csv; charset=utf-8' 
  	response.headers['Content-Disposition'] = "attachment; filename=purchases.csv"
  	
  	file = ''
  	file = CSV.generate do |csv|
  		csv << ['Date', 'Amount', 'Item', 'Stripe ID', 'Name', 'Email', 'User ID', 'Address']
  		@purchases.each do |purchase|
  			csv << [
  				purchase.created_at.display(:american_day),
  				purchase.amount,
  				"#{purchase.package} / #{purchase.options}  #{purchase.options2}",
  				purchase.stripe_id,
  				purchase.user.name,
  				purchase.user.email,
  				purchase.user.id,
  				"#{purchase.address1}, #{purchase.address2}, #{purchase.city}, #{purchase.state}, #{purchase.zip}"
  			]
  		end
  	end
  	
  	return file
	else
		erb :'admin/purchases'
	end
end

get '/admin/purchases/:id/?' do
  admin!
  @purchase = Purchase.get params[:id]
  erb :'admin/purchase'
end

post '/admin/purchases/:id/?' do
  admin!

  purchase = Purchase.get params[:id]
  purchase.update(
    shipped_on: Date.from_fields(
      params[:shipped_on_year],
      params[:shipped_on_month],
      params[:shipped_on_day]
    ),
    received_on: Date.from_fields(
      params[:received_on_year],
      params[:received_on_month],
      params[:received_on_day]
    ),
    tracking_number: params[:tracking_number].strip
  )

  session[:alert] = { message: 'Shipping info updated.' }
  redirect request.referrer
end