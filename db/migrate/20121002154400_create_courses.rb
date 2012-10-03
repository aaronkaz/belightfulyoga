class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.references :client_group
      t.references :course_title
      t.boolean :is_family, :default => false
      t.date :start_date
      t.date :end_date
      t.date :hide_date
      t.time :start_time
      t.time :end_time
      t.string :day
      t.text :location
      t.decimal :price, :precision => 8, :scale => 2
      t.text :notes

      t.timestamps
    end
    add_index :courses, :client_group_id
    add_index :courses, :course_title_id
  end
end
