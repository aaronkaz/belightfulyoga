class CreateCourseTitles < ActiveRecord::Migration
  def change
    create_table :course_titles do |t|
      t.string :title
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
