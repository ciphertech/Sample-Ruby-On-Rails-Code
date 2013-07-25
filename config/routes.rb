CipherTech::Application.routes.draw do

  root :to => 'pages#home'

  devise_for :users, 
    :path_prefix => 'auth',
    :skip => [:registrations]
  as :user do
      get "/auth/users/sign_up" => "registrations#new", :as => :new_user_registration
      post "/auth/users" => "registrations#create", :as => :user_registration
  end
  # match  "/auth/users/sign_up" => "registrations#temp", :as => :temp_user_registration

  namespace :api do
    namespace :v1 do
      resources :tokens, :only => [:create, :destroy]
      resources :restaurants, :only => [:index] do
        get :switch, :on => :member
      end
      resources :inventories, :only => [:index, :show, :update] do
        get :duplicate, :on => :member
      end
      resources :categories, :only => [:index]
      resources :units, :only => [:index]
      resources :products, :only => [:index, :show] do
        get :autocomplete_product_name, :on => :collection
        get :index_restaurant, :on => :collection
        member do
          get :restaurant_products
          get :similar_products
          get :related_products
        end
      end
      resources :inventory_items, :only => [] do
        get :price_list, :on => :collection
      end
    end
  end

  # Load all the pages in the PageController
  PagesController::Pages.each do |page|
    match page, :to => "pages##{page}"
  end

  resources :support, :only => [:index, :create]

  namespace :admin do
    match "/" => "system#index", :as => :system
    get "users/contact_list" => "users#contact_list", :as => :contact_list
    resources :categories, :except => [:destroy]
    resources :system
    resources :accounts, :only => [:index]
    resources :users, :only => [:index, :edit, :update, :destroy, :contact_list]
    resources :restaurants, :only => [:index, :edit, :update]
    resources :products, :except => [:show]
    resources :unapproved_items, :only => [:index, :edit, :update]
    resources :unapproved_restaurants, :only => [:index, :update]
    resources :archive_items, :only => [:update]

    resources :vendors do
      member do
        post :approve 
        post :merge
      end
      resources :vendor_inventory do
        collection do
          post :update_attribute
          post :copy_inventory
        end
      end
      resources :import_inventory, :only => [:new, :create]
    end

    resources :inventory_products do
      get :pull_items, :on => :collection
    end
  end

  namespace :manager do
    #match "/" => "dashboard#show", :as => :dashboard
    match "/" => "restaurants#index", :as => :dashboard
    resources :account, :controller => "account"
    resources :units
    resources :users
    resources :categories, :except => [:destroy]
    match "inventories/:id/rooms/", :to => "inventories#rooms", :as => "rooms"
    match "inventories/:id/rooms/:location_id", :to => "inventories#rooms", :as => "rooms"

    resources :inventories do
      get :duplicate
      get :sums
      get :cat_sums
      get :pars
      get :order
      get :blank
      resources :inventory_items, :only => [:create, :update, :destroy] do
        post :sort, :on => :collection
      end
      resources :import_attachments, :only => [:show, :index, :new, :create]
    end

    resources :invoices
    resources :locations

    resources :inventory_items do
      get :inventoryfromlocation, :on => :collection
      get :price_list, :on => :collection
    end
    resources :products, :only => [:index, :show] do
      get :autocomplete_product_name, :on => :collection
      get :location, :on => :collection
      get :index_restaurant, :on => :collection
      
      resources :locations do
        resources :inventories
      end
    end
    get '/products/compare/:item_id', :to => 'products#show', :as => "product_by_name"

    resources :comments

    resources :restaurants do
      member do
        get :switch
        get :restaurant_users
        put :add_user 
      end
      resources :inventories
    end
    resources :sessions
    resources :skus
    resources :vendors do
      get :detail, :on => :collection
    end

    post "notifications/clear_notifications", :to => "notifications#clear_notifications", :as => :clear_notifications
  end

end
