namespace :pay_outs do
  
  desc "This task is called by the Heroku scheduler add-on"
  task :check_to_create => :environment do
    init_day = "4th monday"
    pay_day = "4th wednesday"
    this_month = Date.today.strftime('%B')
    this_init_day = Chronic.parse("#{init_day} in #{this_month}")
    this_pay_day = Chronic.parse("#{pay_day} in #{this_month}")
    
    if Date.today == this_init_day.to_date
      #CREATE PAY OUTS
      puts "creating payouts"
      start_pay_day = (Chronic.parse("#{pay_day} last month") + 1.day)
      teachers = Teacher.joins(:course_events).where('course_events.event_date >= ? AND course_events.event_date <= ? AND course_events.pay_out_id is NULL', start_pay_day.to_date.beginning_of_day, pay_day.to_date.end_of_day)
      .group('admins.id')
      teachers.each do |teacher|
        teacher.pay_outs.create(:start_date => start_pay_day, :end_date => pay_day)
      end
    end
  end
  
end