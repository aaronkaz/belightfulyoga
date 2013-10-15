require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdminDuplicate
end
 
module RailsAdmin
  module Config
    module Actions
      class Duplicate < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

 
        register_instance_option :visible? do
          authorized? && bindings[:abstract_model].model == Course
        end
        
        register_instance_option :member? do
          true
        end
        
        register_instance_option :link_icon do
          'icon-copy'
        end
        
        register_instance_option :http_methods do
          [:get]
        end
 
        register_instance_option :controller do
          Proc.new do
            @object = @abstract_model.model_name.constantize.new(@object.attributes.except('created_at','updated_at','id'))
            render 'new'
          end
        end
      end
    end
  end
end