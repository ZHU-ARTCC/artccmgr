Rails.application.routes.draw do
  devise_for :users,
      controllers: {
          omniauth_callbacks: 'omniauth_callbacks'
      },
      skip: [:sessions]

  # Manually manage sign out path due to the lack of database authenticatable
  devise_scope :user do
	  post   '/users/auth/2fa' => 'omniauth_callbacks#authenticate_with_two_factor' # Handle 2FA callbacks
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

  resource :profile, only: [:show, :update] do
    resource :gpg_key, only: [:create, :destroy, :show], controller: 'profiles/gpg_key'
	  resource :two_factor_auth, only: [:create, :destroy, :show], controller: 'profiles/two_factor_auths' do
		  resources :u2f, only: [:create, :destroy], controller: 'profiles/two_factor_auths/u2f'
	  end
  end

  resources :roster, as: :users do
	  get    'user_info'   => 'roster#user_info'
	  delete 'disable_2fa' => 'roster#disable_2fa'
	  resources :endorsements, only: [:create, :edit, :new, :update, :destroy]
  end
end
