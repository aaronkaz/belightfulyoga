class CreateCartPromoCodes < ActiveRecord::Migration
  def change
    create_table :cart_promo_codes do |t|
      t.references :cart
      t.references :promo_code

      t.timestamps
    end
    add_index :cart_promo_codes, [:cart_id, :promo_code_id]
  end
end
