class Admin::BaseController < Admin::ApplicationController
  
  before_filter { @model_class = params[:controller].gsub('admin/', '').singularize.camelize.constantize }
  before_filter :find_or_initialize, :only => [:show, :new, :edit, :update, :destroy]
  before_filter :initialize_create, :only => [:create]
  
private  
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
    
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
  
  def model_name
    params[:controller].gsub('admin/', '').singularize
  end
  
  def model_class
    model_name.camelize.constantize
  end
  
end
