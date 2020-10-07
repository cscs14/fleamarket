Rails.application.routes.draw do

  devise_for :users, controllers: {
  sessions: "users/sessions",
  registrations: "users/registrations",
  passwords: "users/passwords",
  omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: "freemarkets#index"

  resources :freemarkets do
    member do
      get 'buy', to: 'freemarkets#buy'
      post 'pay', to: 'freemarkets#pay'
    end
  end

  scope :mypage do
    resources :users do
      member do
        get 'profile', to: 'users#profile'
      end
      collection do
        get 'purchased', to: 'users#purchased'
        get 'logout', to: 'users#logout'
        get 'list', to: 'users#list'
        get 'complete', to:'users#complete'
      end
    end
    resources :cards, only: [:show, :new] do
      collection do
        post 'show', to: 'cards#show'
        post 'pay', to: 'cards#pay'
        post 'delete', to: 'cards#delete'
      end
    end
  end

  devise_scope :user do
    get 'sign_in/registrstion'=>'users/registrations#registration'
    get "sign_in/phone" => "users/registrations#phone"
    get "sign_in/address" => "users/registrations#adress"
    get "sign_in/credit" => "users/registrations#credit"
    post "sign_in/complete" => "users/registrations#complete"
  end 

  resources 'categories', only: [:index, :show]
  get 'user/show' => "users#show"

end