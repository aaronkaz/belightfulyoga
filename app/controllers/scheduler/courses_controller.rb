class Scheduler::CoursesController < Scheduler::ApplicationController
  layout proc {|controller| controller.request.xhr? ? false : 'admin/scheduler' }
  
  def summary
    @course = Course.find(params[:id])
  end
  
end
