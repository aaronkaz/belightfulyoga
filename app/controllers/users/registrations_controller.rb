class Users::RegistrationsController < Devise::RegistrationsController
  layout 'user', :only => [:edit]
  before_filter { initialize_page('edit-your-account') }
  
  #def initialize_page
  #  if params[:action] == "new"
  #    @page = Page.find_by_permalink('users/sign_up')
  #    @page.page_parts.each do |pp|
  #      instance_variable_set "@#{pp.title.gsub(' ', '_').downcase}", @page.page_part_placements.find_by_page_part_id(pp.id)
  #    end
  #  elsif params[:action] == "edit"
  #    @page = Page.find_by_permalink('users/edit')
  #    @page.page_parts.each do |pp|
  #      instance_variable_set "@#{pp.title.gsub(' ', '_').downcase}", @page.page_part_placements.find_by_page_part_id(pp.id)
  #    end      
  #    @sidebar_override = render_to_string(:partial => 'layouts/account')
  #  end  
  #end
  
end