class Admin::ClientGroupsController < Admin::BaseController
  
  def index
    instance_variable_set "@#{@model_class.model_name.tableize}", @model_class.scoped
    instance_variable_set "@#{@model_class.model_name.tableize}", instance_variable_get("@#{@model_class.model_name.tableize}").filters(params[:filter]).search(params[:search])
  end
  
  def new
  end
  
  def create
    if instance_variable_get("@#{model_name}").save
      flash[:success] = "#{model_class.model_name.human} created!"
      redirect_to eval("admin_#{model_name}_path(instance_variable_get('@#{model_name}'))")
    else
      render 'new'
    end
  end
  
  def update
    if instance_variable_get("@#{model_name}").update_attributes(params[model_name.to_sym])
      flash[:success] = "#{model_class.model_name.human} updated!"
      redirect_to eval("admin_#{model_name}_path(instance_variable_get('@#{model_name}'))")
    else
      render 'edit'
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def destroy
    instance_variable_get("@#{model_name}").destroy
    flash[:info] = "#{model_class.model_name.human} deleted!"
    redirect_to eval("admin_#{@model_class.model_name.tableize}_path")
  end
  
end
