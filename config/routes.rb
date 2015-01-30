Rails.application.routes.draw do
  root 'home#index'
  match 'comparar/*id' => 'compare#index', via: :get

end
