class UserMailer < ActionMailer::Base
  layout 'mailer'
  default from: "postmaster@notifications.belightfulyoga.com"
  
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
    @user = @registration.registerable
    mail(:to => @user.email, :subject => "Belightful Yoga Registration Confirmation - #{@user.full_name}")
  end
  
  
end
