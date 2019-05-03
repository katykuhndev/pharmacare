Rails.application.routes.draw do
  resources :medicos
  resources :pacientes
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
