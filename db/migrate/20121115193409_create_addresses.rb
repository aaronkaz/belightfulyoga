class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :postal_code
      t.references :user

      t.timestamps
    end
    add_index :addresses, :user_id
  end
end
