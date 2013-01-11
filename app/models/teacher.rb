class Teacher < AbstractModel
  has_many :courses
  attr_accessible :first_name, :last_name
  validates_presence_of :first_name, :last_name
  
  VIEW_COLUMNS = [['id', ''], ['first_name', ''], ['last_name', '']]
  FORM_COLUMNS = [ ['first_name', 'string'], ['last_name', 'string'] ]
  
  FILTER_COLUMNS = ['first_name', 'last_name']
  SEARCH_COLUMNS = ['id', 'first_name', 'last_name']
  
  ASS_SEL_VIEW = ['first_name', 'last_name']
end
