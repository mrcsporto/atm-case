Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  resources :account_transactions
  resources :bank_accounts
  resources :clients
  resources :sessions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
