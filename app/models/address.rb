class Address < ActiveRecord::Base
  
  def self.attributes_protected_by_default
      # default is ["id","type"]
      []
  end
  
  
  belongs_to :user
  attr_accessible :user_id, :address_1, :address_2, :city, :postal_code, :state, :id
  
  RailsAdmin.config do |config|
    config.model Address do    
      visible false 
    end
  end
  
end
