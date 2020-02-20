set :sprockets, Sprockets::Environment.new

settings.sprockets.append_path 'css'
settings.sprockets.append_path 'img'
settings.sprockets.append_path 'js'

set :asset_types, [
	{ path: 'css/*.css',  content_type: 'text/css', 								extension: 'css'  },
	{ path: 'img/*.gif',  content_type: 'image/gif', 								extension: 'gif'  },
	{ path: 'img/*.jpeg', content_type: 'image/jpeg', 							extension: 'jpeg' },
	{ path: 'img/*.jpg', 	content_type: 'image/jpeg', 							extension: 'jpg'  },
	{ path: 'img/*.png', 	content_type: 'image/png', 								extension: 'png'  },
	{ path: 'img/*.svg', 	content_type: 'image/svg+xml', 						extension: 'svg'  },
	{ path: 'img/*.tiff', content_type: 'image/tiff', 							extension: 'tiff' },
	{ path: 'img/*.ico', 	content_type: 'image/vnd.microsoft.icon', extension: 'ico'  },
	{ path: 'js/*.js', 		content_type: 'application/javascript', 	extension: 'js'   },
	{ path: 'js/*.json', 	content_type: 'application/json', 				extension: 'json' }
]