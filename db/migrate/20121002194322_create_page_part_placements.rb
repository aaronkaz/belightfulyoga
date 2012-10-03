class CreatePagePartPlacements < ActiveRecord::Migration
  def change
    create_table :page_part_placements do |t|
      t.references :page
      t.references :page_part
      t.text :text

      t.timestamps
    end
    add_index :page_part_placements, :page_id
    add_index :page_part_placements, :page_part_id
  end
end
