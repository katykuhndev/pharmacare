Rails.application.routes.draw do
  resources :mediciones do
    resources :alarmas
  end
  resources :examenes
  resources :farmacias
  resources :prestadores
  resources :laboratorios do
    resources :programas
  end
  resources :laboratorios do
    end
  resources :laboratorios do
    end
  resources :pacientexes
  resources :medicos
  resources :pacientes
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
