SendMeHappy2::Application.routes.draw do
  get "users/(:id)" => 'users#show'
  post "users" => 'users#create'
  put "users/(:id)" => 'users#update'
  post "users/(:id)/verify" => 'users#verify'
  post "users/(:id)/send_verification_code" => 'users#send_verification_code'
  
  get '/' => 'high_voltage/pages#show', id: 'index'
  # match "*notaroute" => "application#routing_error", via: [:get, :post, :put, :delete]
end
