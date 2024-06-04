# frozen_string_literal: true

Nunes::Engine.routes.draw do
  resources :requests, only: %i[index show]
  root "requests#index"
end

# How do I make this load and get caught before my application routes...
Rails.application.routes.draw do
  mount Nunes::Engine, at: "/nunes" if Rails.env.development?
end
