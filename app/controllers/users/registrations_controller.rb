class Users::RegistrationsController < Devise::RegistrationsController
  layout 'user', :only => [:edit]

  
end