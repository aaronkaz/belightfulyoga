class PublicCourse < Course
  default_scope { where(:registration_type => "public") }
  before_save { self.registration_type = "public" }
  
  RailsAdmin.config do |config|
    config.model PublicCourse do    

      object_label_method do
          :admin_title
      end
      
      list do
        sort_by :start_date
        sort_reverse true
        field :id
        field :start_date
        field :end_date
        field :teacher
        field :schedule do
          searchable [:first_name, :last_name, :id]
          pretty_value do
            if bindings[:object].active?
              bindings[:view].link_to(bindings[:view].raw("<i class='icon-pencil'></i> Schedule"), bindings[:view].main_app.edit_scheduler_course_path(bindings[:object]), :class => "btn btn-mini")
            end
          end
        end
        field :active
        field :course_registrations do
          pretty_value do
            bindings[:view].link_to("#{bindings[:object].course_registrations.count}", {:action => :index, :controller => 'rails_admin/main', :model_name => "CourseRegistration", "f[course][51422][o]" => "is", "f[course][51422][v]" => "#{bindings[:object].id}", :query => ""})
          end
        end
        #field :is_family
      end
      
      edit do
        group :course_data do
          label "Course Data"
          field :active
          field :course_type, :enum do
            enum do
              [['Individual', 'individual'], ['Family/Group (single price)', 'family'], ['Family/Group (incurrs fees)', 'multiple']]
            end
          end
          field :teacher
          field :teacher_rate
          field :paid_by_company do
            label 'Amount Paid by Company'
            help 'Use this field if registrations are pre-paid for users.  Leave price below at 0.'
          end
          field :location do
            label 'Location/Room'
          end
          #field :is_family do
          #  help 'Check this box to allow family registrations.'
          #end
          #field :reminder do
          #  help 'Check for reminder to schedule next series'
          #end
        end
        group :course_info do
          label "Registration Details"
          field :title do
            help "'Belightful Yoga' will be prepended to all class names.  Leave blank if no additional information is needed."
          end
          field :start_date
          field :end_date
          #field :hide_date do
          #  help 'set the date to close online registration'
          #end  
          #field :day, :enum do
          #  enum do
          #    ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
          #  end
          #end
          field :start_time do
            strftime_format "%I:%M %p"
          end
          field :length_minutes, :enum do
            label 'Class Length'
            help 'in hours'
            enum do
              (30..600).step(15).collect { |i| ["#{i.to_d/60}", i]}
            end
          end
          field :frequency, :enum do
            enum do
              ['weekly', 'daily', 'monthly']
            end
          end
          field :price
          field :notes, :ck_editor
          field :image, :carrierwave    
        end
      end
      
    end
  end
  
end