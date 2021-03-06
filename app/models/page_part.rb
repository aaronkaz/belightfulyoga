class PagePart < AbstractModel
  
  has_many :page_part_placements, :dependent => :destroy
  has_many :pages, :through => :page_part_placements
  
  attr_accessible :title, :body, :wysiwyg, :required
  
  RailsAdmin.config do |config|
    config.model PagePart do    
      parent Page
      weight -4
      
      list do 
        field :id
        field :title
        field :wysiwyg
        field :required
      end
    end
  end
  
end
