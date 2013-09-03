class AddReminderToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :reminder, :boolean, :default => false
  end
end
