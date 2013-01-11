class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :cart
      t.string :line_itemable_type
      t.integer :line_itemable_id
      t.integer :qty

      t.timestamps
    end
    add_index :line_items, :cart_id
    add_index :line_items, [:line_itemable_type, :line_itemable_id]
  end
end
