Belightfulyoga::Application.routes.draw do
  
  mount Ckeditor::Engine => '/ckeditor'

  devise_for :admins, :controllers => { :sessions => "admins/sessions", :registrations => "admins/registrations", :passwords => "admins/passwords" }, :path_prefix => 'd'

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
  
  root :to => 'pages#show', :permalink => 'index'
  match '/:permalink(.:format)', :controller => "pages", :action => "show"
  
end
