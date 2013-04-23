class AddContactPersonIdToClientGroups < ActiveRecord::Migration
  def change
    add_column :client_groups, :contact_person_id, :integer
    add_index :client_groups, :contact_person_id
    add_column :client_groups, :contact_notes, :text
  end
end
