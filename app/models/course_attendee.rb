class CourseAttendee < ActiveRecord::Base
  belongs_to :course_event
  belongs_to :attendable, polymorphic: true
  attr_accessible :attendable_id, :attendable_type, :attended, :course_event_id, :paid
end
