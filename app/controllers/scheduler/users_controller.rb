class Scheduler::UsersController < Scheduler::ApplicationController
  
  def index
    @users = User.joins('INNER JOIN course_registrations ON course_registrations.user_id = users.id')
  end
  
end
