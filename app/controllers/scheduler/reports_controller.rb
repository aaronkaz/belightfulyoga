class Scheduler::ReportsController < Scheduler::ApplicationController
  
  helper_method :end_date
  
  def course_analysis
    @courses = Course.joins('INNER JOIN course_events ON course_events.course_id = courses.id INNER JOIN client_groups ON client_groups.id = courses.client_group_id INNER JOIN admins ON admins.id = courses.teacher_id')
    @courses = @courses.where(:active => true)#.where('courses.id IS IN (SELECT DISTINCT(course_id) FROM course_events)')
    @courses = @courses.where('admins.id = ?', params[:teacher]) unless params[:teacher].blank?
    @courses = @courses.where('client_groups.id = ?', params[:client]) unless params[:client].blank?
    @courses = @courses.where('start_date >= ?', params[:start_date]) unless params[:start_date].blank?
    @courses = @courses.where('end_date <= ?', end_date)
    @courses = @courses.order(sort_column + " " + sort_direction).group('courses.id')
  end
  
private

  def sort_column
    params[:sort] ||= 'start_date'
  end

  def end_date
    params[:end_date] ||= Date.today
  end
  
end
