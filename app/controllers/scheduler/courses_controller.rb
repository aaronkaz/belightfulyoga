class Scheduler::CoursesController < Scheduler::ApplicationController
  layout proc {|controller| controller.request.xhr? ? false : 'admin/scheduler' }
  
  helper_method :end_date
  
  def index
    @courses = Course.joins('INNER JOIN course_events ON course_events.course_id = courses.id INNER JOIN client_groups ON client_groups.id = courses.client_group_id INNER JOIN admins ON admins.id = courses.teacher_id')
    @courses = @courses.where(:active => true)#.where('courses.id IS IN (SELECT DISTINCT(course_id) FROM course_events)')
    @courses = @courses.where('admins.id = ?', params[:teacher]) unless params[:teacher].blank?
    @courses = @courses.where('client_groups.id = ?', params[:client]) unless params[:client].blank?
    @courses = @courses.where('start_date >= ?', params[:start_date]) unless params[:start_date].blank?
    @courses = @courses.where('end_date <= ?', end_date)
    @courses = @courses.order(sort_column + " " + sort_direction).group('courses.id')
  end
  
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

  
  private

    def sort_column
      params[:sort] ||= 'start_date'
    end

    def end_date
      params[:end_date] ||= Date.today
    end  
  
end
