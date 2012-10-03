class ClientGroup < AbstractModel
  
  has_many :users
  has_many :courses
  
  attr_accessible :code, :image, :title, :type
  validates_presence_of :code, :title
  
  VIEW_COLUMNS = [['id'], ['code'], ['title'], ['type']]
  FORM_COLUMNS = [ ['code', 'string'], ['title', 'string'], ['image', 'image'] ]
  
  ASS_SEL_VIEW = ['title', 'code']
  protected
  
  def self.attributes_protected_by_default
      # default is ["id","type"]
      ["id"]
  end
  
end
