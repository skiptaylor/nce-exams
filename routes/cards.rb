get "/cards/?" do
	authorize!
	erb :'cards'
end

get "/cards/:exam/:chapter/?" do
	authorize!
	@cards = Glossary.all(exam: params[:exam], chapter: params[:chapter], order: :term)
	erb :'card'
end