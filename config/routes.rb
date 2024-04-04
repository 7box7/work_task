Rails.application.routes.draw do

  namespace :api do
    resources :users, only: [:create, :show, :update, :delete]
    resources :courses, only: [:create, :show, :update, :delete]
    resources :participants, only: [:create, :show, :update, :delete]
    resources :reg, only: [:create]
    resources :auth, only: [:create, :destroy]
  end

end
