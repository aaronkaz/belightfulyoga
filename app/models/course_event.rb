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
    
  belongs_to :pay_out  
    
  attr_accessible :event_date, :attendees_attributes, :walkins_attributes, :teacher_id, :teacher_pay_out, :course_attributes, 
  :course_registrations_attributes, :attended, :pay_out_id
  
  #around_update :pay_out_change
  #after_update :update_pay_outs
  
  def event_end_date
    self.event_date + self.course.length_minutes.minutes
  end
  
  def is_first?
    first_class = self.course.course_events.order(:event_date).first
    self.id == first_class.id
  end
  
  def registrants
    registrants = Array.new
    self.course_registrations.each do |registration|
      registrants << { :id => registration.registerable_id, :type => registration.registerable_type, :name => "#{registration.registerable.full_name}", :email => "#{registration.registerable.email}", :parent_id => nil, :walk_in => false, :reg_type => registration.registration_type }
      
      if registration.cart.present? && registration.guests.any?
        registration.guests.each do |guest|
          registrants << { :id => guest.id, :type => "Guest", :name => "#{guest.name}", :email => nil, :parent_id => registration.registerable.id, :walk_in => false, :reg_type => "family" }
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
  
  def walkin_pay_out
    checks = walkins.where('payment_type = ? OR payment_type = ?', "check", "paypal").sum(:paid)
    checks * 0.5
  end
  
  def total_collected
    amount_collected + walkin_amount_collected
  end
  
  def total_pay_out
    teacher_pay_out + (walkin_pay_out)
  end
  
  RailsAdmin.config do |config|
    config.model CourseEvent do    
      visible false 
    end
  end
  
private
  
  #def pay_out_change
  #  logger.info "\n\n\n\ CHECK PAYOUT CHANGED IN COURSE EVENT \n\n\n\  "
  #  changed = self.pay_out_id_changed?
  #  if changed
  #    logger.info "\n\n\n\ PAYOUT ID CHANGED!! \n\n\n\  "
  #    @flag = true
  #    @last_pay_out = PayOut.find(self.pay_out_id_was)
  #    @new_pay_out = PayOut.find(self.pay_out_id)
  #  end
  #  yield
  #end
  #
  #def update_pay_outs
  #  if @flag
  #    @last_pay_out.touch
  #    @new_pay_out.touch
  #  end
  #end
  
end
