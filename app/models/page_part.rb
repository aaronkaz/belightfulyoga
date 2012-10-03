class PagePart < AbstractModel
  
  has_many :page_part_placements, :dependent => :destroy
  has_many :pages, :through => :page_part_placements
  
  attr_accessible :title, :body, :wysiwyg, :required
  
  VIEW_COLUMNS = [['id'], ['title'], ['wysiwyg'], ['required']]
  FORM_COLUMNS = [ ['title', 'string'], ['wysiwyg', 'checkbox'], ['required', 'checkbox'] ]
  
  ASS_SEL_VIEW = ['title']
  
end
