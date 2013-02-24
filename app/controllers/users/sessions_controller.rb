class Users::SessionsController < Devise::SessionsController
  layout 'application' 
  before_filter :initialize_page
  
  def initialize_page
    @page = Page.find_by_slug('login')
    @page.page_parts.each do |pp|
      instance_variable_set "@#{pp.title.gsub(' ', '_').downcase}", @page.page_part_placements.find_by_page_part_id(pp.id)
    end
  rescue
  end
    
end