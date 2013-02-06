class CreateCourseRegistrations < ActiveRecord::Migration
  def change
    create_table :course_registrations do |t|
      t.references :course
      t.references :user

      t.timestamps
    end
    add_index :course_registrations, :course_id
    add_index :course_registrations, :user_id
  end
end
