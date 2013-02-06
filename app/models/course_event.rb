class CourseEvent < ActiveRecord::Base
  belongs_to :course
  attr_accessible :event_date
end
