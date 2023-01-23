Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout'
  }

  resources :money_transactions, except: [:edit, :update, :destroy]
  resources :stocks
  resources :stock_items, only: :index
  resources :wallets, only: [:index, :show]

  root 'dashboard#index'
end
