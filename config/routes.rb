Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations'
             }
  root "panels#menu"

  scope :controller => "panels", :path => "/panels" do
    get "menu" => :menu
  end

  scope :path => "api/v1" do
    resources :sections, controller: "api/v1/sections"
    resources :menus, controller: "api/v1/menus"
    resources :tags, controller: "api/v1/tags"
    resources :matches, controller: "api/v1/matches"
    resources :items, controller: "api/v1/items"
    resources :categories, controller: "api/v1/categories"
    resources :root_categories, controller: "api/v1/root_categories"
  end
end
