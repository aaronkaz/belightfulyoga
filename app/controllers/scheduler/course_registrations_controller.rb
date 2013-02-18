class Scheduler::CourseRegistrationsController < Scheduler::ApplicationController
  
  def index
    @registrations = CourseRegistration.joins('INNER JOIN courses ON courses.id = course_registrations.course_id INNER JOIN users ON users.id = course_registrations.user_id INNER JOIN client_groups ON client_groups.id = courses.client_group_id')
  end
  
end
