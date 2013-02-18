class AddLengthMinutesToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :length_minutes, :integer
  end
end
