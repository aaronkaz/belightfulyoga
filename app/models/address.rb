class Address < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :address_1, :address_2, :city, :postal_code, :state
end
