Rails.application.routes.draw do
  match '/(departamento/:departamento)' => 'home#index', via: :get
  match 'comparar/*id' => 'compare#index', via: :get, as: :compare
end
