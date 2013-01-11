class Admin::ApplicationController < ApplicationController
  
  #layout proc {|controller| controller.request.xhr? || params[:clear_layout] == 'true' ? false: "admin/application" }
    
end
