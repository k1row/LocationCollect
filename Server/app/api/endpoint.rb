# -*- encoding: utf-8 -*-
require 'v1/locations.rb'

module Endpoint
	class API < Grape::API
		mount Locations::APIv1

		#route :any, '*path' do
	  #		error!({ message: "The requested item doesn't exist\n" }, 404)
		#end

		route :any, '*path' do
			error!({ error:  'Not Found',
				detail: "No such route '#{request.path}'",
				status: '404' },
				404)
		end
	end
end
