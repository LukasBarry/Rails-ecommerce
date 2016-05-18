Rails.application.routes.draw do
  resources :products

  devise_for :users

  resources :profiles, only: :show

  root 'products#index'

  resources :line_items, only: [:destroy, :create]

  resources :carts

  post 'order_complete' => 'carts#order_complete'

  get 'categorical' => 'products#items_by_category'
end
