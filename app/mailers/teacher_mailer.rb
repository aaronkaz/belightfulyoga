class TeacherMailer < ActionMailer::Base
  layout 'mailer'
  default from: "no-reply@belightfulyoga"
  
  def payout_notification(pay_out_id)
    @payout = PayOut.find(pay_out_id)
    @teacher = @payout.teacher
    mail(:to => @teacher.email, :subject => "Your Belightful Payout Notification")
  end
  
end
