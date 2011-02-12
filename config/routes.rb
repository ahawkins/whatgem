Whatgem::Application.routes.draw do
  root :to => 'home#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users, :only => [] do
    resources :ruby_gems, :only => :index
  end

  constraints :id => /[A-Za-z0-9\-\_\.]+/ do
    resources :ruby_gems, :path => 'gems', :except => [:new, :edit, :destroy] do
      resources :comments, :only => :create

      resources :votes, :only => [] do
        collection do
          post 'up'
          post 'down'
        end
      end
    end
  end
end
