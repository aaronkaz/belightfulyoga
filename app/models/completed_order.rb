class CompletedOrder < Cart
  default_scope { where('status iLIKE ?', "%Completed%").readonly(false) }
  
  
  RailsAdmin.config do |config|
    config.model CompletedOrder do    
      navigation_label 'Orders'
      #object_label_method :id
      
      list do
        field :id
        field :status
        field :user
        field :courses do
          pretty_value do
            if bindings[:object].courses.any?
              bindings[:object].courses.collect{|c| c.line_itemable.nil? ? "<span class='label'>##{c.line_itemable_id} course deleted</span>" : "<small>##{c.line_itemable.id} -- #{c.line_itemable.admin_title}</small>" }.join('<br>').html_safe
            else
              ""
            end
          end
        end
        field :updated_at
        field :course_registrations do
          label 'Registrations'
          pretty_value do
            if bindings[:object].course_registrations.any?
              bindings[:view].link_to("Registrations", {:action => :index, :controller => 'rails_admin/main', :model_name => "CourseRegistration", "f[cart][91648][o]" => "is", "f[cart][91648][v]" => "#{bindings[:object].id}", :query => ""}, class: "btn btn-mini")
            else
              ""
            end     
          end
          
        end
        
        #field :waiver
      end
      
      edit do
        field :status, :enum do
          enum do
            ['New', 'Completed', 'Fulfilled', 'Refunded']
          end
        end
        field :user  
        field :line_items do
          def render
            bindings[:view].render :partial => 'line_items'
          end
        end      
      end
        
      
    end
  end
  
  
end