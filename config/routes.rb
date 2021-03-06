Belightfulyoga::Application.routes.draw do
  
  # DEVISE ROUTES
  devise_for :admins, :controllers => { :sessions => "admins/sessions", :registrations => "admins/registrations", :passwords => "admins/passwords" }, :path => '/teacher/account'
  devise_for :users, :controllers => { :sessions => "users/sessions", :registrations => "users/registrations", :passwords => "users/passwords" }
  
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  mount Ckeditor::Engine => '/ckeditor'
  
  
  #SCHEDULER
  namespace :scheduler, :path => '/calendar' do
    resources :courses do
      collection do
        get :unscheduled
        get :remind
      end
      member do 
        get :summary
        post :set_dates
      end
    end
    resources :course_events do
      member do 
        get :summary
        get :registration
        put :create_registration
        get :registration_user
        post :create_registration_user
        get :walkin
        put :create_walkin
        get :walkin_user
        post :create_walkin_user
        get :accounting
        get :to_excel
      end
      collection do
        get :pay_outs
        post :bulk_actions
      end
    end
    resources :users do
      collection do
        post :bulk_actions
      end
    end
    resources :course_registrations do
      collection do
        post :bulk_actions
      end
    end
    resources :pay_outs do
      collection do
        get :unpaid
      end
    end
    
    get :course_analysis, :to => 'reports#course_analysis'
    post :events, :to => 'application#events'
    root :to => 'application#index'
  end
  
  # FRONT-END
  resources :teachers
  resources :events, :path => 'current-events'
  resources :client_groups, :path => 'clients' do
    resources :courses
  end
  
  resources :trainings
  resources :professional_developments, path: "/professional-development"
  
  resources :courses do
    member do
      get :ics
    end
  end
  get :registered_courses, :to => 'courses#registered_courses'
  
  
  resources :carts, :path => 'shopping-cart' do
    resources :waivers
    member do
      get :checkout
      put :update_checkout
      get :receipt
      post :receipt
    end
    collection do
      post :pp_callback
    end
  end
  
  resources :waivers
  resources "contacts", only: [:index, :new, :create], path: "contact" do
    collection do
      get :thanks
    end
  end
  
  get '/scheduler', to: redirect('/calendar')
  get '/scheduler/*path', :to => redirect{|params, req|
      "/calendar/#{params[:path]}?#{req.query_string}"
    }
  root :to => 'pages#show', :id => 'home'
  resources :pages, :path => '/'
  
end
