Rails.application.routes.draw do

  root 'panels#menu'

  scope :controller => "panels", :path => "/panels" do
    get 'menu' => :menu
  end

  scope :path => "/api/v1" do
    resources :sections
    resources :menus
    resources :tags
    resources :matches
    resources :items
    resources :categories
    resources :root_categories
  end

end
