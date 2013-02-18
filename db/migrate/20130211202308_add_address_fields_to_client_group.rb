class AddAddressFieldsToClientGroup < ActiveRecord::Migration
  def change
    add_column :client_groups, :address_1, :string
    add_column :client_groups, :address_2, :string
    add_column :client_groups, :city, :string
    add_column :client_groups, :state, :string
    add_column :client_groups, :postal_code, :string
    add_column :client_groups, :phone, :string
  end
end
