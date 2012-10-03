class Course < AbstractModel
  belongs_to :client_group
  belongs_to :course_title
  attr_accessible :client_group_id, :course_title_id, :day, :end_date, :end_time, :hide_date, :is_family, :location, :notes, :price, :start_date, :start_time
  
  VIEW_COLUMNS = [ ['id', ''], ['client_group', 'association_select'], ['course_title', 'association_select'], ['start_date', 'datepicker'], ['end_date', 'datepicker'], ['hide_date', 'datepicker'], ['day', ''], ['start_time', 'time'], ['end_time', 'time'], ['price', 'price'] ]
  FORM_COLUMNS = [ ['client_group', 'association_select'], ['course_title', 'association_select'], ['is_family', 'checkbox'], ['start_date', 'datepicker'], ['end_date', 'datepicker'], ['hide_date', 'datepicker'], ['day', 'select_day'], 
  ['start_time', 'time'], ['end_time', 'time'], ['price', 'price'], ['location', 'text'], ['notes', 'text'] ]
  
  DAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
  
end
