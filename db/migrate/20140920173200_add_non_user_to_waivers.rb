class AddNonUserToWaivers < ActiveRecord::Migration
  def change
    add_column :waivers, :non_user_id, :integer
    add_index :waivers, :non_user_id
  end
end
