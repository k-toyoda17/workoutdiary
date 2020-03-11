Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  namespace :admin do
    resources :users do
      post :import, on: :collection
    end
  end
  
  root to: 'tasks#index'
  resources :tasks
  resources :workouts
end
