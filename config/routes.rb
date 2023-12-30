Nunes::Engine.routes.draw do
  resources :requests, only: [:index, :show]
  root "requests#index"
end
