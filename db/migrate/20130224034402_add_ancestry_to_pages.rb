class AddAncestryToPages < ActiveRecord::Migration
  def change
    remove_column :pages, :parent_id
    add_column :pages, :ancestry, :string
    add_index :pages, :ancestry
  end
end
