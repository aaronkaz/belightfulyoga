class Users::PasswordsController < Devise::PasswordsController
  layout 'application'
  before_filter :initialize_page
  
  def initialize_page
    if params[:action] == "new"
      @page = Page.find_by_permalink('users/password/new')
      @page.page_parts.each do |pp|
        instance_variable_set "@#{pp.title.gsub(' ', '_').downcase}", @page.page_part_placements.find_by_page_part_id(pp.id)
      end
    elsif params[:action] == "edit"
      @page = Page.find_by_permalink('users/password/edit')
      @page.page_parts.each do |pp|
        instance_variable_set "@#{pp.title.gsub(' ', '_').downcase}", @page.page_part_placements.find_by_page_part_id(pp.id)
      end
    end  
  end
  
end