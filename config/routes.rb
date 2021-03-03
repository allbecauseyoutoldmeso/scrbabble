Rails.application.routes.draw do
  root "games#index"

  resources :games do
    get :update_shared, on: :member
    get :update_tile_rack, on: :member
  end

  resources :sessions, only: [:new, :create] do
    post :delete, on: :collection
  end

  resources :users, only: [:new, :create]
end
