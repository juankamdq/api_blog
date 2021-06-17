Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :posts, except: [:index]
  resources :categories 
  resources :users
  
  post '/auth/sign_up', to: 'users#sign_up'
  post '/auth/login', to: 'users#login'

  #get '/posts', to: 'posts#index'
end
