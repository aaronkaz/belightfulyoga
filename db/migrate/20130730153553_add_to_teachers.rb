class AddToTeachers < ActiveRecord::Migration
  def change
    add_column :admins, :show_on_web, :boolean, :default => false
    add_column :admins, :bio, :text
    add_column :admins, :photo, :string
  end

end
