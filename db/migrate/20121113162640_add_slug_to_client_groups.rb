class AddSlugToClientGroups < ActiveRecord::Migration
  def change
    add_column :client_groups, :slug, :string
    add_index :client_groups, :slug, :unique => true
  end
end
