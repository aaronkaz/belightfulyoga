Belightfulyoga::Application.routes.draw do
  
  mount Ckeditor::Engine => '/ckeditor'
  
  # DEVISE ROUTES
  devise_for :users, :controllers => { :sessions => "users/sessions", :registrations => "users/registrations", :passwords => "users/passwords" }
  devise_for :admins, :controllers => { :sessions => "admins/sessions", :registrations => "admins/registrations", :passwords => "admins/passwords" }, :path_prefix => 'd'

  # ADMIN
  namespace :admin do
      
    resources :pages do
      collection do
        put :sort
      end
    end
    
    resources :courses do
      collection do
        post :bulk_actions
      end
      member do
        get :generate_ics
      end
    end
    
    resources :page_parts, :admins, :client_groups, :teachers, :users, :promo_codes do
      collection do
        post :bulk_actions
      end
    end
    root :to => "pages#index"
      
  end
  
  # FRONT-END
  resources :client_groups, :path => 'groups' do
    resources :courses
  end
  
  
  resources :carts, :path=> 'shopping-cart' do
    member do
      get :checkout
      put :update_checkout
    end
  end
  
  root :to => 'pages#show', :id => 'home'
  resources :pages, :path => '/'
  
end
