Rails.application.routes.draw do
  match '/(departamento/:departamento)' => 'home#index', via: :get
  get '/comparar' => 'compare#index', as: :compare
  get '/quienes_somos' => 'home#quienes_somos'
end
