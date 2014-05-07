FundsTracker::Application.routes.draw do
  root to: 'home#show'

  devise_for :users

  resources :accounts, except: [:show, :delete]
end
