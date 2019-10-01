Rails.application.routes.draw do
  root to: 'visitors#index'
  resources :recomendaciones do
    member do
      patch :cerrar
    end
    resources :tratamientos
    get :autocomplete_paciente_rut, :on => :collection
    get :autocomplete_prestador_nombre, :on => :collection
    get :autocomplete_farmacia_nombre, :on => :collection
  end
  get 'recomendaciones/show/:id' => 'recomendaciones#show', :format => 'pdf', :as => 'show'
  get 'recomendaciones/edit_cierre/:id' => 'recomendaciones#edit_cierre', :as => 'edit_cierre'
  #put 'recomendaciones/cerrar/:id' => 'recomendaciones#cerrar', :as => 'cerrar'
  post 'recomendaciones/encuentra_caso' => 'recomendaciones#encuentra_caso', :as => 'encuentra_caso'
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
