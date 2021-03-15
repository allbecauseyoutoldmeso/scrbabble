Rails.application.routes.draw do
  root "games#index"

  resources :games do
    get :tile_rack, on: :member
  end

  resources :sessions, only: [:new, :create] do
    post :delete, on: :collection
  end

  resources :users, only: [:new, :create]

  resources :tiles, only: [:update]
end
