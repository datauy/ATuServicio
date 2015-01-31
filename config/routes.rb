Rails.application.routes.draw do
  match '/(departamento/:departamento)' => 'home#index', via: :get
  get '/comparar' => 'compare#index', as: :compare
  get '/sobre_el_proyecto' => 'home#sobre_el_proyecto'
end
