Rails.application.routes.draw do
  get "pages/index"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#index"

  #Static pages
  get "sobre-el-proyecto", to: "pages#about", as: "about"
  get "denuncias", to: "pages#inqueries", as: "inqueries"
  get "afiliaciones", to: "pages#affiliations", as: "affiliations"
  #Providers
  get "comparar", to: "provider#compare", as: "compare"
  get "comparar/:id1", to: redirect("proveedor/%{id1}")
  get "proveedor/:id1", to: "provider#compare"
  get "comparar/:id1/:id2", to: "provider#compare"
  get "comparar/:id1/:id2/:id3", to: "provider#compare"
  #API
  get "proveedor", to: "provider#search", as: "provider_search" 
  get "proveedor/resumen/:id", to: "provider#get_summary", as: "provider_summary"
  #Sites
  get "site-data/:id", to: "site#site_data"

end
