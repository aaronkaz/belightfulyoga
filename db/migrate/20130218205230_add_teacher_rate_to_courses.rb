class AddTeacherRateToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :teacher_rate, :decimal, :precision => 8, :scale => 2
  end
end
