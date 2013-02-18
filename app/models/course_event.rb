class CourseEvent < ActiveRecord::Base
  belongs_to :course
  belongs_to :teacher
  has_one :client_group, :through => :course
  has_many :course_registrations, :through => :course
  has_many :attendees, :class_name => "CourseAttendee"
    accepts_nested_attributes_for :attendees
  has_many :walkins
    accepts_nested_attributes_for :walkins
    
  attr_accessible :event_date, :attendees_attributes, :walkins_attributes, :teacher_id
  
  def event_end_date
    self.event_date + self.course.length_minutes.minutes
  end
  
  def registrants
    registrants = Array.new
    self.course_registrations.each do |registration|
      registrants << { :id => registration.user.id, :type => "User", :name => "#{registration.user.full_name}", :parent_id => nil, :walk_in => false, :reg_type => registration.registration_type }
      if !registration.guests.empty?
        registration.guests.each do |guest|
          registrants << { :id => guest.id, :type => "Guest", :name => "#{guest.name}", :parent_id => registration.user.id, :walk_in => false, :reg_type => "family" }
        end
      end
    end
    self.walkins.each do |walkin|
      registrants << { :id => walkin.attendable_id, :type => "User", :name => "#{walkin.attendable.full_name}", :parent_id => nil, :walk_in => true, :reg_type => nil }
    end
    registrants
  end
  
  RailsAdmin.config do |config|
    config.model CourseEvent do    
      visible false 
    end
  end
  
end
