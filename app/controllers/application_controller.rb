class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  def initialize_page(permalink)
    @page = Page.find_by_permalink(permalink)
    @page.page_parts.each do |pp|
      instance_variable_set "@#{pp.title.gsub(' ', '_').downcase}", @page.page_part_placements.find_by_page_part_id(pp.id)
    end 
  end
  
  def account_sidebar
    @sidebar_override = render_to_string(:partial => 'layouts/account')
  end
  
end
