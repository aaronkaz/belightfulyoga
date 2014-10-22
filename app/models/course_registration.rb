class CourseRegistration < ActiveRecord::Base
  belongs_to :cart
  
  #has_one :waiver, :through => :cart
  #  has_many :guests, :through => :waiver
  
  belongs_to :course
  
  
  #belongs_to :user
  belongs_to :registerable, polymorphic: true
  
  attr_accessible :cart_id, :course_id, :user_id, :registration_type, :paid, :registerable_type, :registerable_id #, :created_at, :updated_at
  
  after_create :send_confirmation_email
  
  def waiver
    if registerable_type == "User" && cart.present?
      cart.user_waiver
    elsif registerable_type == "NonUser"
      registerable.waiver
    end
  end
  
  def guests
    if cart.present? && cart.user_waiver.present?
      self.cart.user_waiver.guests
    else
      Array.new
    end
  end
  
  def waiver_file
    self.cart.present? && !self.cart.session_id.blank? ? "/waivers/#{self.cart.session_id}.waiver.#{self.course.old_id}.html" : nil
  end
  
  def has_waiver_file?
    !self.waiver_file.nil? && File.exists?("#{Rails.root}/public#{self.waiver_file}") ? true : false
  end
  
  RailsAdmin.config do |config|
    config.model CourseRegistration do    
      navigation_label 'Course Management'
      weight -9
      
      list do
        #field :id
        field :cart do
          column_width 80
        end
        field :course do
          column_width 200
        end
        field :registerable_type do
          label 'User Type'
          column_width 80
          filterable true
        end
        field :registerable_id do
          label 'User'
          column_width 200
          filterable true
          
          pretty_value do
            if bindings[:object].registerable_type == "User"
              bindings[:view].link_to("#{bindings[:object].registerable.full_name}", {:action => :edit, :controller => 'rails_admin/main', :model_name => "Customer", :id => "#{bindings[:object].registerable_id}"})
            elsif bindings[:object].registerable_type == "NonUser"
              bindings[:view].link_to("#{bindings[:object].registerable.full_name}", {:action => :edit, :controller => 'rails_admin/main', :model_name => "NonUser", id: bindings[:object].registerable_id})
            else
              ""
            end
          end
        end
        
        
        field :waiver do
          column_width 80
          pretty_value do
            if bindings[:object].waiver.present?
              bindings[:view].link_to("Waiver", bindings[:view].main_app.cart_waiver_path(bindings[:object].cart, bindings[:object].waiver), target: "_blank")
            elsif bindings[:object].has_waiver_file?
              bindings[:view].link_to("Waiver", "#{bindings[:object].waiver_file}", target: "_blank")
            else
              ""
            end 
          end
        end
        field :updated_at do
          label 'Registered'
          column_width 200
        end
        field :paid
        field :registration_type
        
      end
      
    end
  end 

protected

  def send_confirmation_email
    UserMailer.registration_confirmation(self.id).deliver
  end  
  
end
