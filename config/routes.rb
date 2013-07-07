SendMeHappy2::Application.routes.draw do
  get "users/(:id)" => 'users#show'
  post "users" => 'users#create'
  put "users/(:id)" => 'users#update'
  post "users/register_and_send_code" => 'users#register_and_send_code'
  
  match "*notaroute" => "application#routing_error", via: [:get, :post, :put, :delete]
end
