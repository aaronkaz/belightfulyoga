class Admin::ApplicationController < ApplicationController
  
  layout proc {|controller| controller.request.xhr? || params[:clear_layout] == 'true' ? false: "admin/application" }
  before_filter :authenticate_admin!
  
  def index
  end  
    
end
