class CreatePromoCodes < ActiveRecord::Migration
  def change
    create_table :promo_codes do |t|
      t.string :code
      t.string :description
      t.date :start_date
      t.date :expiration_date
      t.string :discount_type
      t.decimal :amount, :precision => 6, :scale => 2
      t.integer :must_have_qty
      t.boolean :unique, :default => false
      t.string :line_itemable_type

      t.timestamps
    end
  end
end
