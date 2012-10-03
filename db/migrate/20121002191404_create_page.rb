class CreatePage < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :parent_id
      t.string :link_title
      t.string :page_title
      t.string :permalink
      t.boolean :show_in_menu, :default => true
      t.boolean :skip_to_first_child, :default => false
      t.integer :position
      t.timestamps
    end
  end
end
