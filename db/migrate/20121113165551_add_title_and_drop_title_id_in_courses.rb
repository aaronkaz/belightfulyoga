class AddTitleAndDropTitleIdInCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :course_title_id
    add_column :courses, :title, :string
  end
end
