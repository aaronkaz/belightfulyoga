class CoursesController < ApplicationController

  before_filter { @client_group = ClientGroup.find(params[:client_group_id]) rescue redirect_to(root_path) }
  before_filter { redirect_to(root_path) if @client_group.id != current_user.client_group.id }
  before_filter { initialize_page('courses') }
  before_filter { @cart = current_cart || Cart.new }
  
  layout 'user'
  
  def index
    @courses = @client_group.courses.where('hide_date >= ?', Date.today)
  end
  
end
