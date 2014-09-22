class LineItem < ActiveRecord::Base
  
  belongs_to :cart
  belongs_to :line_itemable, polymorphic: true
  
  has_many :non_users
    accepts_nested_attributes_for :non_users
  
  attr_accessible :line_itemable_id, :line_itemable_type, :qty, :unit_price, :id, :cart_id, :non_users_attributes
  
  before_create { self.cart.update_attribute(:shipping_confirm, false) } #hide this in seeding
  before_destroy { self.cart.update_attribute(:shipping_confirm, false) }
  
  def registrants_complete?
    non_users.length == (qty - 1)
  end
  
  RailsAdmin.config do |config|
    config.model LineItem do    
      visible false 
    end
  end
  
end
