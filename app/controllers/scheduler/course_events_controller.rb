class Scheduler::CourseEventsController < Scheduler::ApplicationController
  layout proc {|controller| controller.request.xhr? ? false : 'admin/scheduler' }
  
  def summary
    @course_event = CourseEvent.find(params[:id])
    @course = @course_event.course
  end
  
end
