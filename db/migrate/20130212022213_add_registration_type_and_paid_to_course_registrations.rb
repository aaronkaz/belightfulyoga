class AddRegistrationTypeAndPaidToCourseRegistrations < ActiveRecord::Migration
  def change
    add_column :course_registrations, :registration_type, :string
    add_column :course_registrations, :paid, :decimal, :precision => 8, :scale => 2
  end
end
