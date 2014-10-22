class Customer < User
  
  default_scope { includes(:course_registrations, :courses)}
  
  
  RailsAdmin.config do |config|
    config.model Customer do 
      object_label_method :full_name
      navigation_label 'Users'
      
      list do
        
        field :id
        field :full_name
        field :email
        field :client_group
        
        field :courses do
          searchable [:client_group_id, :created_at]
          filterable [:client_group_id, :created_at]
          queryable true
          pretty_value do
            bindings[:object].course_registrations.collect{|c| bindings[:view].link_to(bindings[:view].raw("<small>#{c.course.admin_title}</small>"), {:action => :show, :controller => 'rails_admin/main', :model_name => "Course", id: c.course.id})}.join('<br>').html_safe
          end
        end
        
  
        field :last_address do
          label 'Location'
          pretty_value do
            if bindings[:object].last_address.present?
              "#{bindings[:object].last_address.city}, #{bindings[:object].last_address.state}"
            else
              ""
            end
          end
        end
        
        field :course_registrations do
          label 'Registrations'
          searchable [:course_id, :created_at]
          filterable [:course_id, :created_at]
          queryable true
          pretty_value do
            if bindings[:object].course_registrations.any?
              bindings[:view].link_to(bindings[:object].course_registrations.length, {:action => :index, :controller => 'rails_admin/main', :model_name => "CourseRegistration", "f[registerable_type][51549][o]" => "is", "f[registerable_type][51549][v]" => "User", "f[registerable_id][51609][o]" => "default", "f[registerable_id][51609][v][]" => "#{bindings[:object].id}", :query => ""}, class: "btn btn-mini")
            else
              ""
            end
          end
        end

        #field :last_sign_in_at
        
      end
      
      edit do
        group :default do
          label "User Info"
          
          #field :become do
          #  read_only true
          #  visible do
          #    !bindings[:object].new_record?
          #  end
          #  pretty_value do
          #    bindings[:view].link_to("Sign In As User", bindings[:view].main_app.become_user_path(:user_id => bindings[:object].id), target: "_blank", class: "btn")
          #  end
          #end
                
          field :first_name
          field :middle_initial
          field :last_name
          field :email
          
          field :client_group
          field :home_phone
          field :work_phone
          field :work_phone_ext
          field :cell_phone
          field :occupation
          field :emergency_contact
          field :birthdate

          field :addresses
        end
        
        #group :history do
        #  label "Purchase History"
        #  field :carts do
        #    #read_only true
        #    partial "order_history"
        #  end
        #end
 
      end
      
     
      show do
        field :first_name
        field :middle_initial
        field :last_name
        field :email
        
        field :client_group
        field :home_phone
        field :work_phone
        field :work_phone_ext
        field :cell_phone
        field :occupation
        field :emergency_contact
        field :birthdate

        #field :addresses
        field :last_sign_in_at
        
        field :course_registrations do
          label 'Courses'
          searchable [:course_id, :created_at]
          filterable [:course_id, :created_at]
          queryable true
          pretty_value do
            bindings[:object].course_registrations.collect{|c| bindings[:view].link_to(c.course.admin_title, {:action => :show, :controller => 'rails_admin/main', :model_name => "Course", id: c.course.id})}.join('<br>').html_safe
          end
        end
        
      end
      
      export do
        field :first_name
        field :middle_initial
        field :last_name
        field :email
        
        field :client_group_id do
          label "Client Group"
          pretty_value do
            "#{bindings[:object].client_group.title}"
          end
          
        end
        
        field :home_phone
        field :work_phone
        field :work_phone_ext
        field :cell_phone
        field :occupation
        field :emergency_contact
      end
      
    end
  end
  
end