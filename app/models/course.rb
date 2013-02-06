class Course < AbstractModel
  belongs_to :client_group
  belongs_to :teacher
  
  has_many :course_registrations
  has_many :users, :through => :course_registrations
  has_many :course_events
  
  # CARTS
  has_many :line_items, as: :line_itemable
  
  attr_accessor :ics_file
  attr_accessible :client_group_id, :teacher_id, :title, :day, :end_date, :end_time, :hide_date, :is_family, :description, :location, :notes, :price, :start_date, :start_time, :image
  
  after_commit :create_or_update_events
  
  VIEW_COLUMNS = [ ['id', ''], ['client_group', 'association_select'], ['teacher', 'association_select'], ['start_date', 'datepicker'], ['end_date', 'datepicker'], 
    ['hide_date', 'datepicker'], ['day', ''], ['start_time', 'time'], ['end_time', 'time'], ['price', 'price'], ['ics_file', 'ics_file'] ]
  FORM_COLUMNS = [ ['client_group', 'association_select'], ['teacher', 'association_select'], ['title', 'string'], ['is_family', 'checkbox'], ['start_date', 'datepicker'], ['end_date', 'datepicker'], ['hide_date', 'datepicker'], ['day', 'select_day'], 
  ['start_time', 'time'], ['end_time', 'time'], ['price', 'price'], ['description', 'text'], ['location', 'text'], ['notes', 'text'], ['image', 'image'] ]
  
  FILTER_COLUMNS = ['client_group_id', 'teacher_id', 'start_date', 'end_date', 'day']
  SEARCH_COLUMNS = ['id', 'client_group_id', 'start_date', 'end_date', 'day']
  
  DAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
  
  mount_uploader :image, CourseImageUploader
  
  def line_item_title
    "#{self.title} Belightful Yoga Course -- #{self.start_date.strftime('%m/%d/%Y')} to #{self.end_date.strftime('%m/%d/%Y')}"
  end
  
protected

  def create_or_update_events
    unless self.start_date.blank? || self.end_date.blank?
      from = self.start_date
      to = self.end_date
      tmp_date = from
      tmp_index = 0        
      begin
        event = self.course_events.find_or_create_by_event_index(tmp_index)
        event.update_attributes(:event_date => "#{tmp_date} #{self.start_time}")
        tmp_date += 1.week
        tmp_index += 1
      end while tmp_date <= to
    end  
  end  
  
end
