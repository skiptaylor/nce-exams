settings.asset_types.each do |asset|
	get "/#{asset[:path]}/?" do
		content_type asset[:content_type]
		settings.sprockets["#{params[:splat].first}.#{asset[:extension]}"]
	end
end