class CourseRegistration < ActiveRecord::Base
  belongs_to :cart
  has_one :waiver, :through => :cart
    has_many :guests, :through => :waiver
  belongs_to :course
  belongs_to :user
  attr_accessible :cart_id, :course_id, :user_id, :registration_type, :paid#, :created_at, :updated_at
  
  after_create :send_confirmation_email
  
  
  def waiver_file
    self.cart.present? ? "/waivers/#{self.cart.session_id}.waiver.#{self.course.old_id}.html" : nil
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
        field :user
        field :cart
        field :waiver do
          pretty_value do
            if bindings[:object].waiver.present?
              bindings[:view].link_to("Waiver", {:action => :edit, :controller => 'rails_admin/main', :model_name => "Waiver", :id => bindings[:object].waiver.id} )
            else
              bindings[:object].has_waiver_file? ? bindings[:view].link_to("Waiver", "#{bindings[:object].waiver_file}") : nil
            end  
          end
        end
      end
      
    end
  end 

protected

  def send_confirmation_email
    UserMailer.registration_confirmation(self.id).deliver
  end  
  
end
