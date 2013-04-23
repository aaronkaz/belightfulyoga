class AddPaymentTypeToCourseAttendees < ActiveRecord::Migration
  def change
    add_column :course_attendees, :payment_type, :string
  end
end
