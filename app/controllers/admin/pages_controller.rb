class Admin::PagesController < Admin::BaseCrudController
  

  def index
    @nav_pages = Page.where(:show_in_menu => true).roots.order(:position)
    @other_pages = Page.where(:show_in_menu => false).roots.order(:position)
  end
  
  def create
    @page = Page.new(params[:page])
    if @page.save
      flash[:success] = "created new page!"
      redirect_to admin_pages_path
    else
      render 'new'
    end
  end
  
  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      flash[:success] = "page updated"
      redirect_to admin_pages_path
    else
      render 'edit'
    end
  end
  
  def sort
    @pages = Page.update(params[:pages].keys, params[:pages].values).reject { |p| p.errors.empty? }
      if @pages.empty?
        flash[:success] = "pages updated"
        redirect_to admin_pages_path
      else
        render :action => "index"
      end
  end
  
end
