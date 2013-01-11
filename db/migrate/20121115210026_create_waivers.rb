class CreateWaivers < ActiveRecord::Migration
  def change
    create_table :waivers do |t|
      t.references :cart
      t.references :user
      t.string :first_name
      t.string :middle_initial
      t.string :last_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :home_phone
      t.string :work_phone
      t.string :work_phone_ext
      t.string :cell_phone
      t.date :birth_date
      t.string :email_address
      t.string :occupation
      t.string :emergency_contact
      t.string :referral
      t.string :signature
      t.string :guardian_of
      t.string :guardian_signature
      t.string :family_members

      t.timestamps
    end
    add_index :waivers, :cart_id
    add_index :waivers, :user_id
  end
end
