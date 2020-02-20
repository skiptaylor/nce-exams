# To create a simple json API for a model:
#   include Chassis::API
# The model will be accessible as a REST API at:
#   yoursite.com/api/model

namespace '/api' do

	helpers do
		def map_url_to_model
			@model = eval params[:dm_model].capitalize
			@model.respond_to?(:chassis_api) ? content_type(:json) : halt(404)
			['dm_model', 'splat', 'captures'].each { |p| params.delete p }
		end
	end

	get '/:dm_model/?' do
		map_url_to_model
		collection = []
		query = @model.all
		params.each { |p| query = query.all(p.first.to_sym => p.last) }
		query.each { |q| collection << q.attributes }
		collection.to_json
	end
	
	get '/:dm_model/:id/?' do
		map_url_to_model
		@model.get(params[:id]).attributes.to_json
	end
	
	put '/:dm_model/:id/?' do
		map_url_to_model
		attributes = {}
		params.each { |p| attributes[p.first.to_sym] = p.last }
		object = @model.get params[:id]
		object.update attributes
		object.attributes.to_json
	end
	
	post '/:dm_model/?' do
		map_url_to_model
		attributes = {}
		params.each { |p| attributes[p.first.to_sym] = p.last }
		@model.first_or_create(attributes).attributes.to_json
	end
	
	delete '/:dm_model/:id/?' do
		map_url_to_model
		@model.get(params[:id]).destroy.to_json
	end

end

module Chassis
	module API
		
		def self.included base
			base.extend ClassMethods
		end
		
		module ClassMethods
			attr_reader :chassis_api
		end
		
	end
end