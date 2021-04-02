Rails.application.routes.draw do
  root "games#index"

  resources :games

  resources :sessions, only: [:new, :create] do
    post :delete, on: :collection
  end

  resources :games do
    resources :turns, only: [:update]
  end

  resources :users, only: [:new, :create]
  resources :tiles, only: [:update]
end
