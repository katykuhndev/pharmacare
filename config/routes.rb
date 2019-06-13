Rails.application.routes.draw do
  root to: 'visitors#index'
  resources :recomendaciones
  resources :bloques
  resources :casos
  resources :mediciones do
    resources :alarmas
  end
  resources :examenes
  resources :farmacias
  resources :prestadores
  resources :laboratorios do
    resources :programas
  end
  resources :medicos
  resources :pacientes
  devise_for :users
  resources :users
end
