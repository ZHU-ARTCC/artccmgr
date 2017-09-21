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

  resources :events do
    get 'signup' => 'events/signups#new'

    resources :signups, except: [:new], controller: 'events/signups'
    resources :pilots, only: [:create, :destroy], controller: 'events/pilots'
  end

  resources :feedback
  resources :positions
  resources :roster, as: :user
end
