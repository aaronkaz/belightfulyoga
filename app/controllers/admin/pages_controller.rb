class Admin::PagesController < Admin::ApplicationController
  
  before_filter { @model_class = Page }
  
  def index
    @pages = Page.order("position").roots
  end
  
  def new
    @page = Page.new
  end
  
  def create
    @page = Page.new(params[:page])
    if @page.save
      flash[:success] = "New Page Created"
      redirect_to admin_pages_path
    else  
      render :action => 'new'
    end
  end
  
  def edit
    @page = Page.find(params[:id])
  end
  
  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      flash[:success] = "Page updated!"
      redirect_to edit_admin_page_path(@page)
    else
      render 'edit'
    end
  end
  
  def destroy
    @page = Page.find(params[:id])
    if @page.destroy
      flash[:success] = "Page deleted!"
      redirect_to admin_pages_path
    end
  end
  
  def sort
    params[:page].each_with_index do |id, index|
      Page.update_all({:position => index+1}, {:id => id})
    end
    render :nothing => true
  end
  
end
