class PayOut < ActiveRecord::Base
  belongs_to :teacher
  
  attr_accessor :mark_paid
  attr_accessible :adjustments, :admin_approved, :calculated_pay_out, :end_date, :paid_date, :start_date, :teacher_approved, :total_pay_out, :mark_paid
  
  before_save :update_total
  before_save :pay_it, :if => :mark_paid
  
  
  def events
    self.teacher.course_events.where('event_date >= ? AND event_date <= ? AND (paid is null OR paid = ?)', self.start_date, self.end_date, self.paid_date)
  end
  
protected

  def update_total
    self.total_pay_out = self.adjustments.nil? ? self.calculated_pay_out : (self.calculated_pay_out + self.adjustments)
  end
  
  def pay_it
    if self.mark_paid == "1"
      the_date = Time.now
      self.events.update_all(:paid => the_date)
      self.paid_date = the_date  
    end
  end
  
end
