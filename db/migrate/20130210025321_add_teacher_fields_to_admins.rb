class AddTeacherFieldsToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :is_teacher, :boolean, :default => false
    add_column :admins, :color, :string
  end
end
