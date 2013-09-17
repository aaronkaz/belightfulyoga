class AddAttendedToCourseEvents < ActiveRecord::Migration
  def change
    add_column :course_events, :attended, :integer, :default => 0
  end
end
