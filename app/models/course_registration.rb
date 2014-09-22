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
    if registerable_type == "User"
      cart.user_waiver
    elsif registerable_type == "NonUser"
      registerable.waiver
    end
  end
  
  def guests
    self.cart.user_waiver.guests
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
        field :id
        field :course
        field :registerable do
          label 'User'
        end
        field :cart
        field :waiver do
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
        end
        
      end
      
    end
  end 

protected

  def send_confirmation_email
    UserMailer.registration_confirmation(self.id).deliver
  end  
  
end
