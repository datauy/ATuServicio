Rails.application.routes.draw do
  match '/(departamento/:departamento)' => 'home#index', via: :get

  get '/comparar' => 'compare#index'
  get '/comparar/:selected_providers' => 'compare#index', as: :compare
  get '/agregar' => 'compare#add'

  resources :providers do
    get :autocomplete_provider_nombre_completo, on: :collection
  end

  get '/sobre_el_proyecto' => 'home#sobre_el_proyecto'

  get '/providers' => 'providers#show'
end
