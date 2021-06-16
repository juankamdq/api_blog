Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :post
  resource :category 
  resource :user 

  post '/auth/sign_up', to: 'users#sign_up'
  post '/auth/login', to: 'users#login'
end
