class AddWalkInToCourseAttendees < ActiveRecord::Migration
  def change
    add_column :course_attendees, :walk_in, :boolean, :default => false
  end
end
