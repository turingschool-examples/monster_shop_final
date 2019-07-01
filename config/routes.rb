Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end
  resources :items, only: [:index, :show, :edit, :update, :destroy]
end
