# frozen_string_literal: true

Nunes::Engine.routes.draw do
  resources :requests, only: %i[index show]
  root "requests#index"
end
