class Page < AbstractModel 
  acts_as_list
  has_ancestry
 
  has_many :page_part_placements, :dependent => :destroy
  has_many :page_parts, :through => :page_part_placements
    accepts_nested_attributes_for :page_part_placements
    
  attr_accessible :ancestry, :page_title, :link_title, :permalink, :show_in_menu, :skip_to_first_child, :page_parts_attributes, :draft, 
  :page_part_placements_attributes, :meta_description, :meta_keywords, :google_analytics, :add_css, :position, :parent_id
  #has_many :comments, as: :commentable
  
  extend FriendlyId
    friendly_id :page_title, use: :slugged
  
  def label_name
    self.link_title
  end  

  RailsAdmin.config do |config|
    config.model Page do    
      navigation_label 'CMS'
      weight -5
      object_label_method :page_title
      
      nestable_tree({
            position_field: :position,
            max_depth: 2
          })
      
      list do
        field :id
        field :parent do
          pretty_value do
            bindings[:object].parent.nil? ? nil : "#{bindings[:object].parent.page_title}"
          end
        end
        field :page_title
        field :show_in_menu
        field :skip_to_first_child
      end
      
      edit do
        group :navigation do
          label 'Page Navigation'         
          field :parent_id do
            partial 'parent'
          end
          field :page_title
          field :show_in_menu
          field :skip_to_first_child
          field :google_analytics
        end
        group :content do
          label 'Page Content'
          field :add_css do
            partial 'css'
          end
          field :page_part_placements do
            label ''
            partial 'page_parts'
          end
        end
        group :meta do
          label 'Meta Content'
          active false
          field :meta_description
          field :meta_keywords
        end
      end
      
    end
  end
    
end
