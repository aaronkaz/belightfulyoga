class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.references :waiver
      t.string :name
      t.string :age

      t.timestamps
    end
    add_index :guests, :waiver_id
  end
end
