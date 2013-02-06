class CreateCourseEvents < ActiveRecord::Migration
  def change
    create_table :course_events do |t|
      t.references :course
      t.datetime :event_date

      t.timestamps
    end
    add_index :course_events, :course_id
  end
end
