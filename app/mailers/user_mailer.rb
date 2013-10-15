class UserMailer < ActionMailer::Base
  layout 'mailer'
  default from: "no-reply@belightfulyoga"
  
  def order_confirmation(cart_id)
    @cart = Cart.find(cart_id)
    mail(:to => @cart.user.email, :subject => "Your Order Confirmation")
    if ENV['order-reply-to-address'].present?
      UserMailer.admin_order_confirmation(cart_id).deliver
    end
  end
  
  def admin_order_confirmation(cart_id)
    @cart = Cart.find(cart_id)
    mail(:to => ENV['order-reply-to-address'], :subject => "Order Confirmation -- No. #{cart_id}")
  end
  
  def registration_confirmation(registration_id)
    @registration = CourseRegistration.find(registration_id)
    @course = @registration.course
    mail(:to => @registration.user.email, :subject => "Belightful Yoga Registration Confirmation")
  end
  
  
end
