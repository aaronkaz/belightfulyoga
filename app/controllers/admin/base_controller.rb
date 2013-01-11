class Admin::BaseController < Admin::ApplicationController
  
  before_filter :authenticate_admin! 
  layout proc {|controller| controller.request.xhr? ? false: "admin/application" }
  
end
