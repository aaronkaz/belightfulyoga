class TeachersController < ApplicationController
  before_filter :initialize_page
  
  def index
    @teachers = Teacher.where(:show_on_web => true).order(:first_name)
  end
  
  
  private

    def initialize_page
      @page = Page.find('teachers')
      @page.page_parts.each do |pp|
        instance_variable_set "@#{pp.title.gsub(' ', '_').downcase}", @page.page_part_placements.find_by_page_part_id(pp.id)
      end
    end
      
end
