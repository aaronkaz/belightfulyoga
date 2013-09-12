class CourseEvent < ActiveRecord::Base
  belongs_to :course
    accepts_nested_attributes_for :course
  belongs_to :teacher
  has_one :client_group, :through => :course
  has_many :course_registrations, :through => :course
    accepts_nested_attributes_for :course_registrations
  has_many :attendees, :class_name => "CourseAttendee", :dependent => :destroy
    accepts_nested_attributes_for :attendees
  has_many :walkins, :dependent => :destroy
    accepts_nested_attributes_for :walkins
    
  attr_accessible :event_date, :attendees_attributes, :walkins_attributes, :teacher_id, :teacher_pay_out, :course_attributes, :course_registrations_attributes
  
  def event_end_date
    self.event_date + self.course.length_minutes.minutes
  end
  
  def registrants
    registrants = Array.new
    self.course_registrations.each do |registration|
      registrants << { :id => registration.user.id, :type => "User", :name => "#{registration.user.full_name}", :email => "#{registration.user.email}", :parent_id => nil, :walk_in => false, :reg_type => registration.registration_type }
      if registration.cart.present? && registration.guests.any?
        registration.guests.each do |guest|
          registrants << { :id => guest.id, :type => "Guest", :name => "#{guest.name}", :email => nil, :parent_id => registration.user.id, :walk_in => false, :reg_type => "family" }
        end
      end
    end
    self.walkins.each do |walkin|
      registrants << { :id => walkin.attendable_id, :type => "User", :name => "#{walkin.attendable.full_name}", :email => "#{walkin.attendable.email}", :parent_id => nil, :walk_in => true, :reg_type => nil }
    end
    registrants
  end
  
  def amount_collected
    if course.paid_by_company.to_i != 0
      course.paid_by_company / course.course_events.length
    else
      course.course_registrations.sum(:paid) / course.course_events.length
    end
  end
  
  def walkin_amount_collected
    walkins.sum(:paid)
  end
  
  def total_collected
    amount_collected + walkin_amount_collected
  end
  
  def total_pay_out
    teacher_pay_out + (walkin_amount_collected * 0.5)
  end
  
  RailsAdmin.config do |config|
    config.model CourseEvent do    
      visible false 
    end
  end
  
end
