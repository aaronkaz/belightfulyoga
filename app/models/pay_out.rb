class PayOut < ActiveRecord::Base
  belongs_to :teacher
  has_many :course_events
    accepts_nested_attributes_for :course_events
  
  attr_accessor :mark_paid
  attr_accessible :adjustments, :admin_approved, :calculated_pay_out, :end_date, :paid_date, :start_date, :teacher_approved, :total_pay_out, 
  :mark_paid, :course_events_attributes, :comment
  
  before_create :get_events
  after_create :notify_teacher
  after_commit :update_total
  before_update :pay_it, :if => :mark_paid
  before_destroy :detach_events
  
  
  def find_events
    self.teacher.course_events.where('event_date >= ? AND event_date <= ? AND pay_out_id is NULL', self.start_date.beginning_of_day, self.end_date.end_of_day)
  end
  
private

  def get_events
    self.find_events.each do |event|
      self.course_events << event
    end
  end

  def update_total
    #logger.info "\n\n\n\ UPDATING PAYOUT TOTAL \n\n\n\  "
    
    calculated_pay_out = 0
    course_events.each do |event|
      calculated_pay_out += event.total_pay_out
    end  
    total_pay_out = self.adjustments.nil? ? calculated_pay_out : (calculated_pay_out + self.adjustments)
    self.update_column(:calculated_pay_out, calculated_pay_out)
    self.update_column(:total_pay_out, total_pay_out)
    #self.update_attributes(:calculated_pay_out => calculated_pay_out, :total_pay_out => total_pay_out )
  end
  
  def pay_it
    if self.mark_paid == "1"
      the_date = Time.now
      self.course_events.update_all(:paid => the_date)
      self.paid_date = the_date  
    end
  end
  
  def detach_events
    self.course_events.each do |ce|
      ce.update_column(:pay_out_id, nil)
    end
  end
  
  def notify_teacher
    TeacherMailer.payout_notification(self.id).deliver
  end
  
end
