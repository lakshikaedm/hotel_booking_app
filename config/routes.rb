Rails.application.routes.draw do
  get 'user_models/new'
  get 'user_models/create'
  get 'user_models/show'
  get 'user_models/edit'
  get 'user_models/update'
  root 'room_models#index'

  resources :user_models, only:  [:new, :create, :show, :edit, :update]

  resource :session, only: [:new, :create, :destroy]
end
