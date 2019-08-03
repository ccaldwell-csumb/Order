Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Orders
  post '/orders', to: 'order#create'
  get '/orders/:id', to: 'order#show'
  get '/orders/:customerId', to: 'order#find'
  get '/orders/:email', to: 'order#find'
end
