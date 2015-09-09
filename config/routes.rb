Rails.application.routes.draw do
  
  root to: 'pages#index'

  #get '/auth/:name/callback', to: 'pages#auth'
  get '/auth/:name/callback', to: 'sessions#create'
  
  get '/dashboard', to: 'pages#dashboard'
  
  get '/projects', to: 'pages#projects'

end
