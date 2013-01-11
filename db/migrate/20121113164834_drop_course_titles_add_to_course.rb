class DropCourseTitlesAddToCourse < ActiveRecord::Migration
  def change
    drop_table :course_titles
    add_column :courses, :description, :text
    add_column :courses, :image, :string
  end
end
