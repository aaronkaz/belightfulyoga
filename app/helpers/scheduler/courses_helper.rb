module Scheduler::CoursesHelper
  
  def course_title_helper(course)
    "<span class='label'>ID: #{course.id}</span> #{course.start_date.strftime('%m/%d/%Y')} to #{course.end_date.strftime('%m/%d/%Y')}".html_safe
  end
  
  def link_to_add_course_event(name, f, association)
      new_object = f.object.send(association).klass.new
      id = new_object.object_id
      fields = f.fields_for(association, new_object, child_index: id) do |builder|
        render('/scheduler/courses/course_event', f: builder)
      end
      link_to(raw("<i class='icon-plus icon-white'></i> #{name}"), '#', style: "width:150px;", class: "btn btn-info add_course_event", data: {id: id, fields: fields.gsub("\n", "")})
  end
  
end
