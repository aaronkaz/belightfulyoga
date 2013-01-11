class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.string :status
      t.references :user
      t.string :postal_code
      t.string :selected_shipping_array
      t.integer :billing_address_id
      t.integer :shipping_address_id
      t.boolean :shipping_confirm, :default => false

      t.timestamps
    end
    add_index :carts, :user_id
    add_index :carts, :billing_address_id
    add_index :carts, :shipping_address_id
  end
end
