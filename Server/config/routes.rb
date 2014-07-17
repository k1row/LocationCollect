Rails.application.routes.draw do
	 mount Endpoint::API => '/api'
end
