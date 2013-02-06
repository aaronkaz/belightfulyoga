class AddEventIndexToCourseEvents < ActiveRecord::Migration
  def change
    add_column :course_events, :event_index, :integer
  end
end
