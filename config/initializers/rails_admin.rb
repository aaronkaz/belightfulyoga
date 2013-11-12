# RailsAdmin config file. Generated on February 06, 2013 00:32
# See github.com/sferik/rails_admin for more informations

require "rails_admin/duplicate"


RailsAdmin.config do |config|

  config.actions do
      # root actions
      dashboard                     # mandatory
      # collection actions
      index                         # mandatory
      new
      export
      # history_index
      bulk_delete
      # member actions
      show
      edit
      delete
      # history_show
      # show_in_app

      duplicate
      
      # Add the nestable action for each model
      nestable do
        visible do
          %w(Page).include? bindings[:abstract_model].model_name
        end
      end
    end
    
    
  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Belightfulyoga', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.authenticate_with do
    authenticate_admin!
    unless current_admin.try(:admin?)
      flash[:error] = "You are not an admin"
      redirect_to main_app.scheduler_root_path
    end
  end
  config.current_user_method { current_admin } # auto-generated

  # If you want to track changes on your models:
  # config.audit_with :history, 'Admin'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'Admin'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  # config.excluded_models = ['Address', 'Admin', 'Cart', 'CartPromoCode', 'Ckeditor::Asset', 'Ckeditor::AttachmentFile', 'Ckeditor::Picture', 'ClientGroup', 'Course', 'CourseEvent', 'CourseRegistration', 'LineItem', 'Page', 'PagePart', 'PagePartPlacement', 'PromoCode', 'Teacher', 'User', 'Waiver']

  config.excluded_models = ["Ckeditor::Asset", "Ckeditor::AttachmentFile", "Ckeditor::Picture", "PayOut"]

  # Include specific models (exclude the others):
  # config.included_models = ['Address', 'Admin', 'Cart', 'CartPromoCode', 'Ckeditor::Asset', 'Ckeditor::AttachmentFile', 'Ckeditor::Picture', 'ClientGroup', 'Course', 'CourseEvent', 'CourseRegistration', 'LineItem', 'Page', 'PagePart', 'PagePartPlacement', 'PromoCode', 'Teacher', 'User', 'Waiver']

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end

end
