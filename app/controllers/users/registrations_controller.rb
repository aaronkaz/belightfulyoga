class Users::RegistrationsController < Devise::RegistrationsController
  layout 'user', :only => [:edit]
  before_filter :configure_permitted_parameters

  protected
 
  # my custom fields are :name, :heard_how
  def configure_permitted_parameters
   devise_parameter_sanitizer.for(:sign_up) do |u|
     u.permit!
   end
   devise_parameter_sanitizer.for(:account_update) do |u|
     u.permit!
   end
  end
  
  
end