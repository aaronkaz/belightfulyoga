class Tempfile
  def make_tmpname(prefix_suffix, n)
        case prefix_suffix
        when String
          prefix = prefix_suffix
          suffix = ""
        when Array
          prefix = prefix_suffix[0]
          suffix = prefix_suffix[1]
        else
          raise ArgumentError, "unexpected prefix_suffix: #{prefix_suffix.inspect}"
        end
        t = Time.now.strftime("%Y%m%d")
        path = "#{prefix}#{t}-#{$$}-#{rand(0x100000000).to_s(36)}"
        path << "-#{n}" if n
        path << suffix
      end
end


class CoursesController < ApplicationController
  layout 'user'
  
  before_filter :client_group_sanity, :only => [:index]
  
  def index
    initialize_page('courses')
    @cart = current_cart || Cart.new
    @courses = @client_group.courses.where('hide_date >= ?', Date.today)
  end
  
  def registered_courses
    @courses = current_user.courses.where('end_date >= ?', Date.today).order(:start_date)
  end
  
  def ics
    @course = Course.find(params[:id])    
    ics = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\n"   
    @course.course_events.each do |event|
      ics << "BEGIN:VEVENT\r\nDTSTART:#{event.event_date.strftime('%Y%m%d')}T#{@course.start_time.strftime('%H%M%S')}\r\nDTEND:#{event.event_date.strftime('%Y%m%d')}T#{@course.end_time.strftime('%H%M%S')}\r\n"
      ics << "DTSTAMP:#{Time.now.strftime('%Y%m%dT%H%M%S')}\r\nDESCRIPTION:#{@course.title} Belightful Yoga #{@course.description}\r\nSUMMARY:#{@course.title} Belightful Yoga #{@course.description}\r\nEND:VEVENT\r\n"
    end   
    ics << "END:VCALENDAR"
    file = make_tmpname(["belightful_yoga_course_#{@course.id}_", ".ics"], "#{Rails.root}/tmp/")    
    File.open(file, 'w') {|f| f.write(ics) }      
    send_file file   
  end
  
private

  def client_group_sanity
    @client_group = ClientGroup.find(params[:client_group_id]) rescue redirect_to(root_path)
    redirect_to(root_path) if @client_group.id != current_user.client_group.id
  end
  
end
