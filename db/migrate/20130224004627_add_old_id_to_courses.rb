class AddOldIdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :old_id, :integer
  end
end
