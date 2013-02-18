class AddTeacherToCourseEvents < ActiveRecord::Migration
  def change
    add_column :course_events, :teacher_id, :integer
    add_index :course_events, :teacher_id
  end
end
