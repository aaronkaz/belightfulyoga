class CreateCourseAttendees < ActiveRecord::Migration
  def change
    create_table :course_attendees do |t|
      t.references :course_event
      t.string :attendable_type
      t.integer :attendable_id
      t.boolean :attended, :default => false
      t.timestamps
    end
    add_index :course_attendees, :course_event_id
    add_index :course_attendees, [:attendable_type, :attendable_id]
  end
end
