Rails.application.routes.draw do
  devise_for :users,
      controllers: {
          omniauth_callbacks: 'omniauth_callbacks'
      }

  # Manually manage sign out path due to the lack of database authenticatable
  devise_scope :user do
    delete '/users/sign_out' => 'devise/sessions#destroy'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  resources :activity, only: [:index]

  resources :airports

  resources :certifications

  resources :events do
    get 'signup' => 'events/signups#new'

    resources :signups, except: [:new], controller: 'events/signups'
    resources :pilots, only: [:create, :destroy], controller: 'events/pilots'
    resources :positions, except: [:create, :destroy, :new, :show], controller: 'events/positions'
  end

  resources :feedback, except: [:edit, :show]
  resources :groups, except: [:show]
  resources :positions

  resources :roster, as: :users do
	  resources :endorsements, only: [:create, :edit, :new, :update, :destroy]
  end
end
