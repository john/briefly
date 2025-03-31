Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "home#index"
  
  # Auth0 routes
  get 'auth/auth0/callback', to: 'auth0#callback'
  get 'auth/failure', to: 'auth0#failure'
  get 'auth/logout', to: 'auth0#logout'
  get 'auth/login', to: 'auth0#login'

  # Report configurations
  resources :report_configs do
    member do
      post :generate
      get :history
      post :publish
      post :unpublish
      get :preview
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

end
