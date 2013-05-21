class Scheduler::ApplicationController < ApplicationController
  layout 'admin/scheduler'
  before_filter :authenticate_admin!
  before_filter :initialize_teachers
  
  helper_method :sort_column, :sort_direction, :teacher
  
  def index
    @teachers = Teacher.joins(:course_events).group('admins.id')
    @teachers = @teachers.where('admins.id = ?', current_admin.id) if !current_admin.admin?

  end
  
  def events
    respond_to do |format|
      format.json {
        @teacher = Teacher.find(params[:teacher_id])
        @events = Array.new        
        @teacher.course_events.where('course_events.event_date >= ?', (Time.now - 30.days).beginning_of_day).each do |event|
          @events << { :id => event.id, :title => "#{@teacher.full_name} @ #{event.course.client_group.title}", :start => "#{event.event_date.strftime('%Y-%m-%d')} #{event.event_date.strftime('%H:%M:%S')}", :end => "#{event.event_end_date.strftime('%Y-%m-%d')} #{event.event_end_date.strftime('%H:%M:%S')}", :allDay => false, :url => summary_scheduler_course_event_path(event.id) }
        end  
        render :json => @events
      }
    end
       
  end
  
private

  def initialize_teachers
    @teachers = Teacher.scoped
    @teachers = @teachers.where('admins.id = ?', current_admin.id) if !current_admin.admin?
    @teachers.order(:first_name)
  end
  
  def teacher
    params[:teacher] ||= current_admin.admin? ? "" : current_admin.id
  end

  def sort_column
    params[:sort] ||= 'id'
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
end
