FundsTracker::Application.routes.draw do
  root to: 'home#show'

  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :tags, except: [:show]
  resources :accounts do
    resources :transactions, except: [:show] do
      get '/tagged/:tag_id', to: 'transactions#tagged', as: :tagged, on: :collection
    end
  end
end
