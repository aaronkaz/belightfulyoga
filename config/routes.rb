Belightfulyoga::Application.routes.draw do
  
  mount Ckeditor::Engine => '/ckeditor'
  
  # DEVISE ROUTES
  devise_for :users, :controllers => { :sessions => "users/sessions", :registrations => "users/registrations", :passwords => "users/passwords" }
  devise_for :admins, :controllers => { :sessions => "admins/sessions", :registrations => "admins/registrations", :passwords => "admins/passwords" }, :path_prefix => 'd'

  # ADMIN
  constraints(:subdomain => /admin/) do
    namespace :admin, :path => '/' do
      
      resources :pages do
        collection do
          post :sort
        end
      end
      
      resources :page_parts, :admins, :course_titles, :client_groups, :courses
      root :to => "application#index"
      
    end
  end
  
  # FRONT-END
  resources :client_groups do
    resources :courses
  end
  
  root :to => 'pages#show', :permalink => 'index'
  match '/:permalink(.:format)', :controller => "pages", :action => "show"
  
end
