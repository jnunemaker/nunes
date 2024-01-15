Rails.application.routes.draw do
  mount Nunes::Engine => "/nunes" if Rails.env.development? || Rails.env.test?

  resources :users
  get "/boom" => "kitchen_sink#boom"
  get "/boom-job" => "kitchen_sink#boom_job"
  get "/enqueue-job" => "kitchen_sink#enqueue_job"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
