class Address < ActiveRecord::Base

  belongs_to :user
  attr_accessible :user_id, :address_1, :address_2, :city, :postal_code, :state, :id
  
  RailsAdmin.config do |config|
    config.model Address do    
      visible false 
      
      edit do
        field :address_1
        field :address_2
        field :city
        field :state
        field :postal_code
      end
      
    end
  end
  
end
