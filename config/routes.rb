Rails.application.routes.draw do
  root "games#index"

  resources :games do
    get :tile_rack, on: :member
  end

  resources :sessions, only: [:new, :create] do
    post :delete, on: :collection
  end
end
