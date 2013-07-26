SendMeHappy2::Application.routes.draw do
  get "users/(:id)" => 'users#show'
  post "users" => 'users#create'
  put "users/(:id)" => 'users#update'
  post "users/(:id)/validate_token" => 'users#validate_token'
  
  get "/" => 'static#index'
  match "*notaroute" => "application#routing_error", via: [:get, :post, :put, :delete]
end
