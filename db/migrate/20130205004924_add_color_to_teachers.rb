class AddColorToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :color, :string
  end
end
