class Scheduler::CourseEventsController < Scheduler::ApplicationController
  layout proc {|controller| controller.request.xhr? ? false : 'admin/scheduler' }
  
  helper_method :start_date
  
  def index
    @course_events = CourseEvent.joins('INNER JOIN courses ON courses.id = course_events.course_id INNER JOIN client_groups ON client_groups.id = courses.client_group_id INNER JOIN admins ON admins.id = courses.teacher_id')
    @course_events = @course_events.where('admins.id = ?', params[:teacher]) unless params[:teacher].blank?
    @course_events = @course_events.where('client_groups.id = ?', params[:client]) unless params[:client].blank?
    @course_events = @course_events.where('event_date >= ?', start_date)
    @course_events = @course_events.where('event_date <= ?', params[:end_date]) unless params[:end_date].blank?
    @course_events = @course_events.order(sort_column + " " + sort_direction)
  end
  
  def pay_outs
    @course_events = CourseEvent.joins('INNER JOIN courses ON courses.id = course_events.course_id INNER JOIN client_groups ON client_groups.id = courses.client_group_id INNER JOIN admins ON admins.id = courses.teacher_id')
    @course_events = @course_events.where('event_date <= ?', Date.today).where(:paid => nil)    
    @course_events = @course_events.where('admins.id = ?', params[:teacher]) unless params[:teacher].blank?
    @course_events = @course_events.order(sort_column + " " + sort_direction)
  end
  
  def show
    @course_event = CourseEvent.find(params[:id])
  end
  
  def update
    @course_event = CourseEvent.find(params[:id])    
    section = params[:section] ||= 'show'
    
    red_to = section == "show" ? scheduler_course_event_path(@course_event) : eval("#{section}_scheduler_course_event_path(@course_event)")
    
    if @course_event.update_attributes(params[:course_event])
      flash[:success] = "Course Event Updated!"
      redirect_to red_to
    else
      render section
    end
  end
  
  def summary
    @course_event = CourseEvent.find(params[:id])
    @course = @course_event.course
  end
  
  def walkin
    @course_event = CourseEvent.find(params[:id])
  end
  
  def create_walkin
    @course_event = CourseEvent.find(params[:id])
    if @course_event.update_attributes(params[:course_event])
      flash[:success] = "Walkin added!"
      redirect_to [:scheduler, @course_event]
    else
      render 'walkin'
    end
  end
  
  def walkin_user
    @course_event = CourseEvent.find(params[:id])
    @user = User.new(:client_group_id => @course_event.client_group.id)
  end
  
  def create_walkin_user
    @course_event = CourseEvent.find(params[:id])
    if @user = User.invite!(params[:user])
      flash[:success] = "Walkin added!"
      redirect_to [:scheduler, @course_event]
    else
      render 'walkin_user'
    end  
  end
  
  def accounting
    @course_event = CourseEvent.find(params[:id])
  end
  
  def bulk_actions
    if params[:bulk_action] == "pay_out"
      params[:course_event_ids].each do |i|
        CourseEvent.find(i.to_i).update_attribute(:paid, Time.now)
      end  
      flash[:success] = "The selected classes were marked paid"
      redirect_to pay_outs_scheduler_course_events_path
    end
  end
  
private

  def sort_column
    params[:sort] ||= 'event_date'
  end
  
  def start_date
    params[:start_date] ||= Date.today
  end
  
end
