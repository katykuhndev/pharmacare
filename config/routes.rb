Rails.application.routes.draw do
  resources :pacientexes
  resources :medicos
  resources :pacientes
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
