class AddFrequencyToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :frequency, :string
  end
end
