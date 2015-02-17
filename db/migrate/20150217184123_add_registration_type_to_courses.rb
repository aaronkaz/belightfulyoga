class AddRegistrationTypeToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :registration_type, :string
  end
end
