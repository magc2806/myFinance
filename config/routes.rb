require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  resources :bank_accounts, except: [:show] do 
    resources :transactions, except: [:show] do 
      collection do 
        get 'download_excel'
        get 'send_excel'
      end
    end
  end

  resources :categories, except: [:show]
end
