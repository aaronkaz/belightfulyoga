class Scheduler::CourseEventsController < Scheduler::ApplicationController
  layout proc {|controller| controller.request.xhr? ? false : 'admin/scheduler' }
  
  helper_method :start_date, :end_date
  
  def index
    #@course_events = CourseEvent.joins('INNER JOIN courses ON courses.id = course_events.course_id INNER JOIN admins ON admins.id = courses.teacher_id').includes(:client_group)
    @course_events = CourseEvent.includes(:client_group).joins(:course).joins('INNER JOIN admins ON admins.id = courses.teacher_id')
    @course_events = @course_events.where('course_events.teacher_id = ?', teacher) unless teacher.blank?
    @course_events = @course_events.where('client_groups.id = ?', params[:client]) unless params[:client].blank?
    @course_events = @course_events.where('event_date >= ?', start_date)
    @course_events = @course_events.where('event_date <= ?', end_date)
    @course_events = @course_events.order(sort_column + " " + sort_direction)
  end
  
  def pay_outs
    @course_events = CourseEvent.joins('INNER JOIN courses ON courses.id = course_events.course_id INNER JOIN client_groups ON client_groups.id = courses.client_group_id INNER JOIN admins ON admins.id = courses.teacher_id')
    @course_events = @course_events.where('event_date <= ?', Date.today).where(:paid => nil)    
    @course_events = @course_events.where('course_events.teacher_id = ?', teacher) unless teacher.blank?
    @course_events = @course_events.order(sort_column + " " + sort_direction)
    
    @total_pay_out = "0".to_d
      @course_events.each do |c|
        @total_pay_out += c.total_pay_out
      end
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
  
  def registration
    @course_event = CourseEvent.find(params[:id])
  end
  
  def create_registration
    @course_event = CourseEvent.find(params[:id])
    if @course_event.update_attributes(params[:course_event])
      flash[:success] = "Registration added!"
      redirect_to [:scheduler, @course_event]
    else
      render 'registration'
    end
  end
  
  def registration_user
    @course_event = CourseEvent.find(params[:id])
    @user = User.new(:client_group_id => @course_event.client_group.id)
  end
  
  def create_registration_user
    @course_event = CourseEvent.find(params[:id])
    if @user = User.invite!(params[:user])
      flash[:success] = "Registration added!"
      redirect_to [:scheduler, @course_event]
    else
      render 'registration_user'
    end  
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
  
  def to_excel
    @course_event = CourseEvent.find(params[:id])
    
    # Create a new Excel Workbook
    @filename = "#{Rails.root}/tmp/course_event_#{@course_event.event_date.strftime("%d_%b_%Y")}.xls"
    workbook = WriteExcel.new(@filename)

    # Add worksheet(s)
    worksheet  = workbook.add_worksheet
    worksheet.set_portrait
    worksheet.set_paper(1)

    # Add and define formats
    format_big = workbook.add_format(:font => 'Arial', :size => 20)
    format_med = workbook.add_format(:font => 'Arial', :size => 16)
    format_th = workbook.add_format(:font => 'Cambria', :size => 14)
    format_th.set_bold
    format_center = workbook.add_format()
    format_center.set_align('center')
    format_right = workbook.add_format()
    format_right.set_align('right')
    
    # SET COLUMN WIDTHS
    worksheet.set_column('A:A', 32) # name
    worksheet.set_column('B:B', 32) # name
    worksheet.set_column('C:C', 14) # reg type
    worksheet.set_column('D:D', 22.3) # paid
    worksheet.set_column('E:E', 14) # attended

  
    # TABLE HEADERS
    worksheet.write('A1', 'Name', format_th)
    worksheet.write('B1', 'Email', format_th)
    worksheet.write('C1', 'Registration', format_th)
    worksheet.write('D1', 'Paid', format_th)
    worksheet.write('E1', 'Attended', format_th)
    
    # WRITE VALUES
    $row_offset = 1
    @course_event.registrants.each do |registrant|
      attend = @course_event.attendees.find_by_attendable_type_and_attendable_id(registrant[:type], registrant[:id])
      
      $row_offset = $row_offset + 1
      worksheet.write('A' + $row_offset.to_s, registrant[:name])
      worksheet.write('B' + $row_offset.to_s, registrant[:email])
      worksheet.write('C' + $row_offset.to_s, !registrant[:reg_type].nil? ? registrant[:reg_type] : "walkin")
      if registrant[:type] == "User"
        if registrant[:walk_in] == true
          worksheet.write('D' + $row_offset.to_s, attend.paid)
        else
          registration = @course_event.course_registrations.find_by_user_id(registrant[:id])
          worksheet.write('D' + $row_offset.to_s, (registration.paid / @course_event.course.course_events.length)) if !registration.nil?
        end
      end
      worksheet.write('E' + $row_offset.to_s, attend.present?)
    end   

    # write to file
    workbook.close 
    send_file @filename
    
    
  end
  
private

  def sort_column
    params[:sort] ||= 'event_date'
  end
  
  def start_date
    params[:start_date] ||= Date.today
  end
  
  def end_date
    params[:end_date] ||= 30.days.from_now.to_date
  end
  
end
