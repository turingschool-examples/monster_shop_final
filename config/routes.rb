Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :merchants do
    resources :items, only: [:index]
  end

  resources :items, only: [:index, :show] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  resources :cart, only: [:index, :create, :destroy, :update]

  resources :users, only: [:new, :create, :update]

  resources :orders, only: [:create]

  namespace :profile do
    get "/", to: 'dashboard#index', as: :dashboard
    get "/edit", to: 'dashboard#edit'
    resources :orders, only: [:index, :show, :destroy ]
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'

  namespace :merchant do
    get root 'dashboard#index', as: :dashboard
    resources :orders, only: [:show, :update]
    resources :items, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :discounts
  end

  namespace :admin do
    get root 'dashboard#index', as: :dashboard
    resources :merchants, only: [:show, :update]
    resources :users, only: [:index, :show]
    resources :orders, only: [:update]
  end
end
