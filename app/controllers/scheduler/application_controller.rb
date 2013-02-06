class Scheduler::ApplicationController < ApplicationController
  layout 'admin/scheduler'
  before_filter :authenticate_admin!
  
  def index
    
  end
  
  def events
    respond_to do |format|
      format.json {
        @teacher = Teacher.find(params[:teacher_id])
        @events = Array.new        
        @teacher.course_events.each do |event|
          @events << { :id => event.id, :title => "#{@teacher.full_name} @ #{event.course.client_group.title}", :start => "#{event.event_date.strftime('%Y-%m-%d')} #{event.course.start_time.strftime('%H:%M:%S')}", :end => "#{event.event_date.strftime('%Y-%m-%d')} #{event.course.end_time.strftime('%H:%M:%S')}", :allDay => false, :url => summary_scheduler_course_event_path(event.id) }
        end  
        render :json => @events
      }
    end
       
  end
  
end
