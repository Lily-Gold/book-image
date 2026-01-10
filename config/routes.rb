Rails.application.routes.draw do
  resources :books, only: [ :index, :show ]
  resource :profile, only: :show
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :reviews, param: :public_id do
    resource :like, only: [ :create, :destroy ]
    resource :bookmark, only: [ :create, :destroy ]
    resources :comments, only: [ :create, :destroy ]
  end

  namespace :api do
    namespace :google_books do
      get :search
    end
  end

  root "homes#index"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
end
