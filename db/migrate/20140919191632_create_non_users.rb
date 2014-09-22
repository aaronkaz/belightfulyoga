class CreateNonUsers < ActiveRecord::Migration
  def change
    create_table :non_users do |t|
      t.references :line_item
      t.string :name
      t.integer :age

      t.timestamps
    end
    add_index :non_users, :line_item_id
  end
end
