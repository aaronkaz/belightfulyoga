class Walkin < CourseAttendee
  default_scope {where(:walk_in => true)}
  before_create { self.attended = true }
  
  RailsAdmin.config do |config|
    config.model Walkin do 
      visible false
    end
  end
  
end