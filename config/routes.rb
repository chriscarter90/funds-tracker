FundsTracker::Application.routes.draw do
  root to: 'home#show'

  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :tags, except: [:show]
  resources :accounts, except: [:show] do
    get '/tagged/:tag_id', to: 'accounts#tagged', as: :tagged, on: :collection
    resources :account_transactions, only: [:index] do
      # get '/tagged/:tag_id', to: 'transactions#tagged', as: :tagged, on: :collection
    end
    resources :payments, except: [:index, :show]
    resources :transfers, except: [:index, :show]
  end
  # resources :transfers, except: [:show]
end
