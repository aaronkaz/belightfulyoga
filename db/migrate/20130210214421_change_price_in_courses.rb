class ChangePriceInCourses < ActiveRecord::Migration
  def change
    change_column :courses, :price, :decimal, :precision => 8, :scale => 2, :default => 0
  end
end
