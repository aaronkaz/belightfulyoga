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

class Admin::CoursesController < Admin::BaseCrudController
  
  def generate_ics
    
    #require 'tempfile'
    
    @course = Course.find(params[:id])
    
    ics = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\n"
    from = @course.start_date
    to = @course.end_date
    tmp = from
    
    begin
      ics << "BEGIN:VEVENT\r\nDTSTART:#{tmp.strftime('%Y%m%d')}T#{@course.start_time.strftime('%H%M%S')}\r\nDTEND:#{tmp.strftime('%Y%m%d')}T#{@course.end_time.strftime('%H%M%S')}\r\n"
      ics << "DTSTAMP:#{Time.now.strftime('%Y%m%dT%H%M%S')}\r\nDESCRIPTION:#{@course.title} Belightful Yoga #{@course.description}\r\nSUMMARY:#{@course.title} Belightful Yoga #{@course.description}\r\nEND:VEVENT\r\n"
      tmp += 1.week
      
    end while tmp <= to
    
    ics << "END:VCALENDAR"
    
    #file = Tempfile.new('hola')
    file = make_tmpname(["belightful_yoga_course_#{@course.id}_", ".ics"], "#{Rails.root}/tmp/")
    
    File.open(file, 'w') {|f| f.write(ics) }
      
    send_file file
    
    #render :text => ics
    
  end
  
end

