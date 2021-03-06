Rails.application.routes.draw do
  root to: 'visitors#index'
  resources :recomendaciones do
    member do
      patch :cerrar
      get :enmendar
    end
    resources :tratamientos
    get :autocomplete_paciente_rut, :on => :collection
    get :autocomplete_prestador_nombre, :on => :collection
    get :autocomplete_farmacia_nombre, :on => :collection
  end
  get 'recomendaciones/show/:id' => 'recomendaciones#show', :format => 'pdf', :as => 'show'
  get 'recomendaciones/index' => 'recomendaciones#index', :format => 'pdf', :as => 'index'
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
  resources :pacientes do
    member do
      patch :guardar_archivos
    end
  end
  get 'pacientes/edit_caso_paciente/:id' => 'pacientes#edit_caso_paciente', :as => 'edit_caso_paciente'
  get 'informes/index', :as => 'informes'
  patch 'informes/mostrar_listado' => 'informes#mostrar_listado', :as => 'mostrar_listado'
  devise_for :users
  resources :users

end
