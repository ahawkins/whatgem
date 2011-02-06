Whatgem::Application.routes.draw do
  root :to => 'home#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :ruby_gems, :only => :show do
    resources :comments, :only => :create
  end

  namespace :user do
    root :to => 'dashboards#show'
    resources :ruby_gems do
      collection do 
        get 'import'
      end
    end
  end
end
