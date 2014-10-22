class ContactsController < ApplicationController
  before_filter :initialize_page
  
  def index
    @contact = Contact.new
  end
  
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash.now[:notice] = 'Thank you for your message. We will contact you soon!'
      redirect_to thanks_contacts_path
    else
      flash.now[:error] = 'Cannot send message.'
      render :new
    end
  end
  
  def thanks
  end
  
private

  def initialize_page
    @page = Page.find('contact')
    @page.page_parts.each do |pp|
      instance_variable_set "@#{pp.title.gsub(' ', '_').downcase}", @page.page_part_placements.find_by_page_part_id(pp.id)
    end
  end
    
end
