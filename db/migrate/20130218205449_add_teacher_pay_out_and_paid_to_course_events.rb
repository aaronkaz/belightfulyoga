class AddTeacherPayOutAndPaidToCourseEvents < ActiveRecord::Migration
  def change
    add_column :course_events, :teacher_pay_out, :decimal, :precision => 8, :scale => 2
    add_column :course_events, :paid, :datetime
  end
end
