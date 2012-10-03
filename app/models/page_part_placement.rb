class PagePartPlacement < ActiveRecord::Base
  belongs_to :page
  belongs_to :page_part
  attr_accessible :text, :page_part_id
end
