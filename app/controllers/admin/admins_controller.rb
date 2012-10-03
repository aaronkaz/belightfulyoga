class Admin::AdminsController < Admin::BaseController

  def index
    @admins = Admin.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @admin_users }
    end
  end
  
  def new
    @admin = Admin.new
  end
  
  def create
    @admin = Admin.new(params[:admin])
    if @admin.save
      flash[:success] = 'Admin User was successfully created.'
      redirect_to admin_admins_path
    else
      render :action => "new"
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to admin_admins_path }
      format.json { head :ok }
    end
  end
  
  def edit
    @admin = Admin.find(params[:id])
  end
  
  def update
    @admin = Admin.find(params[:id])
    if params[:admin][:password].blank?
      params[:admin].delete(:password)
      params[:admin].delete(:password_confirmation)
    end
    if @admin.update_attributes(params[:admin])
      flash[:success] = 'Admin User was successfully updated.'
      redirect_to admin_admins_path
    else
      render :action => "edit"
    end
  end
  
end
