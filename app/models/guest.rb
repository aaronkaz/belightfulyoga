class Guest < ActiveRecord::Base
  belongs_to :waiver
  has_one :parent_user, :class_name => "User", :through => :waiver, :source => :user
  has_many :course_attendees, as: :attendable
  
  attr_accessible :age, :name
  validates_presence_of :age, :name
  
  def attended_course?(course_event_id)
    CourseEvent.find(course_event_id).attendees.find_by_attendable_type_and_attendable_id("Guest", self.id).present?
  end
  
  RailsAdmin.config do |config|
    config.model Guest do    
      visible false 
    end
  end
  
end
