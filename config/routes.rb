Rails.application.routes.draw do
  root 'welcome#index'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'signup', to: 'clients#new', as: 'signup'
  get 'profile', to: 'clients#show', as: 'profile'
  get "active",  to: "sessions#active"
  get "timeout", to: "sessions#timeout"
  
  resources :clients
  resources :account_transactions
  resources :bank_accounts
  resources :sessions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
