class CreatePayOuts < ActiveRecord::Migration
  def change
    create_table :pay_outs do |t|
      t.references :teacher
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :teacher_approved, :default => false
      t.boolean :admin_approved, :default => false
      t.decimal :calculated_pay_out, :precision => 8, :scale => 2
      t.decimal :adjustments, :precision => 8, :scale => 2
      t.decimal :total_pay_out, :precision => 8, :scale => 2
      t.datetime :paid_date

      t.timestamps
    end
    add_index :pay_outs, :teacher_id
  end
end
