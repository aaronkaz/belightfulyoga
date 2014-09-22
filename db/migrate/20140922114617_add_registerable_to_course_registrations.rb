class AddRegisterableToCourseRegistrations < ActiveRecord::Migration
  def change
    add_column :course_registrations, :registerable_type, :string
    add_column :course_registrations, :registerable_id, :integer
    add_index :course_registrations, [:registerable_type, :registerable_id], name: "index_on_course_registrations_registerable"
  end
end
