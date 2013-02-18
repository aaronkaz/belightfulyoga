module Scheduler::CoursesHelper
  
  def course_title_helper(course)
    "<span class='label'>ID: #{course.id}</span> #{course.start_date.strftime('%m/%d/%Y')} to #{course.end_date.strftime('%m/%d/%Y')}".html_safe
  end
  
end
