Rails.application.routes.draw do

  namespace :api do
    resources :students, only: [:create, :show, :update, :delete]
    resources :teachers, only: [:create, :show, :update, :delete]
    resources :courses, only: [:create, :show, :update, :delete]
    resources :participants, only: [:create, :show, :update, :delete]
  end

end
