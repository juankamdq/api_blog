Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :posts 
  resources :categories 
  resources :users
  
  #LOGIN
  post '/auth/sign_up', to: 'users#sign_up'
  post '/auth/login', to: 'users#login'


  #POSTS
  post '/posts/soft_delete/:id', to: 'posts#soft_delete'

  
end
