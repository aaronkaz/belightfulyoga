class Scheduler::CoursesController < Scheduler::ApplicationController
  layout proc {|controller| controller.request.xhr? ? false : 'admin/scheduler' }
  
  def summary
    @course = Course.find(params[:id])
  end
  
  def unscheduled
    @courses = Course.where(:active => true).where('courses.id NOT IN (SELECT DISTINCT(course_id) FROM course_events)').order(:start_date)
  end
  
  def edit
    @course = Course.find(params[:id])
  end
  
  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course])
      flash[:success] = "Course scheduled!"
      redirect_to edit_scheduler_course_path(@course)
    else
      render 'edit'
    end
  end
  
end
