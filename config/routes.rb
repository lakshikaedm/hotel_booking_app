Rails.application.routes.draw do
  resources :room_models do
    resources :reservation_models, only: [:new, :create]
    collection do
      get :catalog
    end
  end

  # Home
  root 'room_models#index'

  # Users (note: UserModel, not User)
  resources :user_models, only: [:new, :create, :show, :edit, :update, :destroy]

  # Sessions
  resource :session, only: [:new, :create, :destroy]
  get    'login',  to: 'sessions#new',     as: :login
  post   'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout

  # Profile (singular resource)
  resource :profile, only: [:edit, :update,]

  # Search page
  get '/search', to: 'search#index'

  resources :reservation_models, only: [:index, :show, :edit, :update, :destroy]
end
