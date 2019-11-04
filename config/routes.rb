# frozen_string_literal: true

Rails.application.routes.draw do
  get :root, to: 'welcome#index'

  resources :merchants do
    resources :items, only: [:index]
  end

  resources :items, only: %i[index show] do
    resources :reviews, only: %i[new create]
  end

  resources :reviews, only: %i[edit update destroy]

  get '/cart', to: 'cart#show'
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart', to: 'cart#empty'
  patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  delete '/cart/:item_id', to: 'cart#remove_item'

  get '/registration', to: 'users#new', as: :registration
  resources :users, only: %i[create update]
  patch '/user/:id', to: 'users#update'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  get '/profile/edit_password', to: 'users#edit_password'
  post '/orders', to: 'user/orders#create'
  get '/profile/orders', to: 'user/orders#index'
  get '/profile/orders/:id', to: 'user/orders#show'
  delete '/profile/orders/:id', to: 'user/orders#cancel'
  post '/coupons/:coupon_id', to: 'coupons#create'
  get '/coupon/users', to: 'coupon_users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'

  namespace :merchant do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :orders, only: :show
    resources :items, only: %i[index new create edit update destroy]
    put '/items/:id/change_status', to: 'items#change_status'
    get '/orders/:id/fulfill/:order_item_id', to: 'orders#fulfill'

    resources :coupons, only: %i[index new create edit update]
    patch '/coupon/:id', to: 'coupons#disable_enable'
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :merchants, only: %i[show update]
    resources :users, only: %i[index show]
    patch '/orders/:id/ship', to: 'orders#ship'
  end
end
