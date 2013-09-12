class AddContactFieldsToClientGroups < ActiveRecord::Migration
  def change
    add_column :client_groups, :contact_name, :string
    add_column :client_groups, :contact_email, :string
    add_column :client_groups, :contact_phone, :string
  end
end
