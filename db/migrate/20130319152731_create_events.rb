class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.text :description

      t.timestamps
    end
  end
end
