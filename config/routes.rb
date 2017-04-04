require 'sidekiq/web'

Rails.application.routes.draw do
  root to: "questions#index"

  get 'search_results/index'
  get '/users/add_email', to: 'users#add_email'
  post '/users/finish_signup', to: 'users#finish_signup'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      delete :vote_reset
    end
  end

  resources :questions, concerns: :votable do
    resources :subscriptions, only: [:create, :destroy]
    resources :comments, shallow: true, only: [:create, :destroy]
    resources :answers, shallow: true, concerns: :votable do
      resources :comments, only: :create
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :users, except: [:new, :edit]
end
