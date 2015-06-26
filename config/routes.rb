FundsTracker::Application.routes.draw do
  root to: 'home#show'

  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :accounts, except: [:show] do
    resources :account_transactions, only: [:index] do
    end
    resources :payments, except: [:index, :show]
    resources :transfers, except: [:index, :show]
  end
end
