class CreateClientGroups < ActiveRecord::Migration
  def change
    create_table :client_groups do |t|
      t.string :type
      t.string :code
      t.string :title
      t.string :image

      t.timestamps
    end
  end
end
