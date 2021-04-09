Rails.application.routes.draw do
  root "games#index"

  resources :sessions, only: [:new, :create] do
    post :delete, on: :collection
  end

  resources :games do
    resources :turns, only: [:update]
  end

  get :archive, to: 'games#archive'
  resources :games
  resources :users
  resources :tiles, only: [:update]
  resources :invitations
end
