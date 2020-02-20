# When running in a production environment, errors get routed to the error.erb view.

configure :production do
	error(400) { erb 'error', layout: false, locals: { code: '400', message: 'Bad Request'           } }
	error(401) { erb 'error', layout: false, locals: { code: '401', message: 'Unauthorized'          } }
	error(403) { erb 'error', layout: false, locals: { code: '403', message: 'Forbidden'             } }
	error(404) { erb 'error', layout: false, locals: { code: '404', message: 'Not Found'             } }
	error(408) { erb 'error', layout: false, locals: { code: '408', message: 'Request Timeout'       } }
	error(500) { erb 'error', layout: false, locals: { code: '500', message: 'Internal Server Error' } }
	error(502) { erb 'error', layout: false, locals: { code: '502', message: 'Bad Gateway'           } }
end