class CourseRegistration < ActiveRecord::Base
  belongs_to :cart
  has_one :waiver, :through => :cart
    has_many :guests, :through => :waiver
  belongs_to :course
  belongs_to :user
  attr_accessible :cart_id, :course_id, :user_id, :registration_type, :paid, :created_at, :updated_at
  
  after_create :send_confirmation_email
  
  RailsAdmin.config do |config|
    config.model CourseRegistration do    
      navigation_label 'Course Management'
      weight -9
      
      list do
        field :id
        field :course
        field :user
        field :cart
        field :waiver
      end
      
    end
  end 

protected

  def send_confirmation_email
    UserMailer.registration_confirmation(self.id).deliver
  end  
  
end
