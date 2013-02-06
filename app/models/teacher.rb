class Teacher < AbstractModel
  has_many :courses
  has_many :course_events, :through => :courses
  
  attr_accessible :first_name, :last_name, :color
  validates_presence_of :first_name, :last_name
  
  def full_name
    return "#{self.first_name} #{self.last_name}"
  end
  
  
  VIEW_COLUMNS = [['id', ''], ['first_name', ''], ['last_name', '']]
  FORM_COLUMNS = [ ['first_name', 'string'], ['last_name', 'string'], ['color', 'color_picker'] ]
  
  FILTER_COLUMNS = ['first_name', 'last_name']
  SEARCH_COLUMNS = ['id', 'first_name', 'last_name']
  
  ASS_SEL_VIEW = ['first_name', 'last_name']
end
