FundsTracker::Application.routes.draw do
  root to: 'home#show'

  devise_for :users

  resources :accounts do
    resources :transactions, only: [:new, :create]
  end
end
