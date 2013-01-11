class Admin::BaseCrudController < Admin::BaseController
  
  before_filter { @model_class = model_name.camelize.constantize }
  before_filter :find_or_initialize, :only => [:show, :new, :edit, :update, :destroy]
  before_filter :initialize_create, :only => [:create]
  before_filter :check_ajax
  
  helper_method :sort_column, :sort_direction
  
  def index
    instance_variable_set "@#{@model_class.model_name.tableize}", @model_class.scoped
    instance_variable_set "@#{@model_class.model_name.tableize}", instance_variable_get("@#{@model_class.model_name.tableize}").filters(params[:filter]).search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 25, :page => params[:page])
  end
  
  def new
  end
  
  def create
    respond_to do |format|
      if instance_variable_get("@#{model_name}").save
        format.html { 
          flash[:success] = "#{model_class.model_name.human} created!"
          redirect_to eval("admin_#{model_name}_path(instance_variable_get('@#{model_name}'))")
        }
        format.js
      else
        format.html { render :action => "new", :notice => 'not successful' }
        format.js
      end
    end
  end
  
  def update
    respond_to do |format|
      if instance_variable_get("@#{model_name}").update_attributes(params[model_name.to_sym])
        format.html { 
          flash[:success] = "#{model_class.model_name.human} updated!"
          redirect_to eval("admin_#{model_name}_path(instance_variable_get('@#{model_name}'))")
        }
        format.js
      else
        format.html { render :action => "edit", :notice => 'not successful' }
        format.js
      end
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
  
  def bulk_actions
    if params[:bulk_action] == "delete_multiple"
      @model_class.destroy(params["#{model_name}_ids".to_sym])
      redirect_to eval("admin_#{model_name.pluralize}_path")
    end  
  end
  
private

  def find_or_initialize
    if params[:id].nil?
      instance_variable_set "@#{model_name}", model_class.new
    else
      instance_variable_set "@#{model_name}", model_class.find(params[:id])
    end
  end
  
  def initialize_create
    instance_variable_set "@#{model_name}", model_class.new(params[model_name.to_sym])
  end
  
  def check_ajax
    if request.xhr?
      @ajax = true
    end
  end
  
  def model_name
    params[:controller].gsub('admin/', '').singularize
  end
  
  def model_class
    model_name.camelize.constantize
  end
  
  def sort_column
    params[:sort] ||= 'id'
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
end