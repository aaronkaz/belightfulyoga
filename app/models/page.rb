class Page < ActiveRecord::Base
  
  acts_as_list
  acts_as_tree
  
  has_many :page_part_placements, :dependent => :destroy
  has_many :page_parts, :through => :page_part_placements
    accepts_nested_attributes_for :page_part_placements
    
  attr_accessible :parent_id, :page_title, :link_title, :permalink, :show_in_menu, :skip_to_first_child, :page_parts_attributes, :draft, 
  :page_part_placements_attributes, :meta_description, :meta_keywords, :google_analytics, :add_css
  #has_many :comments, as: :commentable

end
