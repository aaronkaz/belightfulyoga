class AddPayOutIdToCourseEvents < ActiveRecord::Migration
  def change
    add_column :course_events, :pay_out_id, :integer
    add_index :course_events, :pay_out_id
  end
end
