Rails.application.routes.draw do
  resources :users
  resources :tags
  resources :matches
  resources :items
  resources :sections
  resources :menus
  resources :categories
  resources :root_categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
