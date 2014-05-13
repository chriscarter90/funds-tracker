FundsTracker::Application.routes.draw do
  root to: 'home#show'

  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :accounts do
    resources :transactions, except: [:show]
  end
end
