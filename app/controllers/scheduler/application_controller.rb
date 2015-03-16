class Scheduler::ApplicationController < ApplicationController
  layout proc { |controller| params[:print] == 'true' ? 'admin/iframe' : 'admin/scheduler'}
  before_filter :authenticate_admin!
  before_filter :initialize_teachers
  before_filter :teacher_payouts
  
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
        @teacher.course_events.where('course_events.event_date >= ? AND course_events.event_date <= ?', Time.at(params[:start].to_i).to_datetime, Time.at(params[:end].to_i).to_datetime).each do |event|
          title = params[:print] == "true" ? "#{@teacher.first_name}" : event.schedule_title
          title = "<i class='fa fa-star'></i> #{title}" if event.is_first?
          url = params[:print] == "true" ? nil : summary_scheduler_course_event_path(event.id)
          @events << { :id => event.id, :title => title.html_safe, :start => "#{event.event_date.strftime('%Y-%m-%d')} #{event.event_date.strftime('%H:%M:%S')}", :end => "#{event.event_end_date.strftime('%Y-%m-%d')} #{event.event_end_date.strftime('%H:%M:%S')}", :allDay => false, :url => url }
        end  
        render :json => @events
      }
    end
       
  end
  
private

  def initialize_teachers
    @teachers = Teacher.all
    @teachers = @teachers.where('admins.id = ?', current_admin.id) if !current_admin.admin?
    @teachers.order(:first_name)
  end
  
  def teacher
    params[:teacher] ||= current_admin.admin? ? "" : current_admin.id
  end
  
  def teacher_payouts
    pay_outs = PayOut.where(:teacher_id => current_admin.id).where(:teacher_approved => false)
    if pay_outs.any? && params[:controller] == "scheduler/application"
      flash[:info] = "Please approve your pending payout(s)"
      redirect_to unpaid_scheduler_pay_outs_path
    end
  end

  def sort_column
    params[:sort] ||= 'id'
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
end
