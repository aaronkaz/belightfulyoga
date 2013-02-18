class AddPaidByCompanyToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :paid_by_company, :decimal, :precision => 8, :scale => 2, :default => 0
  end
end
