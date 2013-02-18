class AddPaidToCourseAttendees < ActiveRecord::Migration
  def change
    add_column :course_attendees, :paid, :decimal, :precision => 8, :scale => 2
  end
end
