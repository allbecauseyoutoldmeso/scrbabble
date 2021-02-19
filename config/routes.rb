Rails.application.routes.draw do
  root "games#index"
  resources :games
  resources :session, only: [:new, :create], controller: :sessions
end
