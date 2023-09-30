Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    # サインアップ機能・ログイン機能を実装するコントローラ
    registrations: 'auth/registrations'
  }

  resources :messages, only: [:index] do
    member do
      resources :likes, only: [:create]
    end
  end

  resources :likes, only: [:destroy]
end
