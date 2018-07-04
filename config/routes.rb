Rails.application.routes.draw do
  devise_for :users,
             path: "",
             path_names: {
               sign_in: "login",
               sign_out: "logout",
               registration: "signup",
             },
             controllers: {
               sessions: "sessions",
               registrations: "registrations",
             }
  root "panels#menu"

  get "menu/:id" => "menus#index"
  get "menu/:id/data" => "menus#data"

  scope :controller => "panels", :path => "/panels" do
    get "menu" => :menu
  end

  scope :path => "api/v1" do
    resources :menus, controller: "api/v1/menus" do
      resources :sections, controller: "api/v1/sections" do
        post :add_items
        delete 'remove_item/:item_id' => :remove_item
      end
    end
    resources :tags, controller: "api/v1/tags"
    resources :matches, controller: "api/v1/matches"
    resources :categories, controller: "api/v1/categories" do
      resources :items, controller: "api/v1/items" do
        post :image
        delete 'del_image/:id' => :del_image
      end
    end
    resources :root_categories, controller: "api/v1/root_categories"
  end
end
