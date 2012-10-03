class CourseTitle < AbstractModel
  attr_accessible :description, :image, :title
  validates_presence_of :title
  
  VIEW_COLUMNS = [['id'], ['title'], ['description']]
  FORM_COLUMNS = [ ['title', 'string'], ['description', 'text'], ['image', 'image'] ]
  
  ASS_SEL_VIEW = ['title']
  
end
