class LineItem < ActiveRecord::Base
  
  belongs_to :cart
  belongs_to :line_itemable, polymorphic: true
  attr_accessible :line_itemable_id, :line_itemable_type, :qty, :unit_price, :id, :cart_id
  
  before_create { self.cart.update_attribute(:shipping_confirm, false) } #hide this in seeding
  before_destroy { self.cart.update_attribute(:shipping_confirm, false) }
  
  RailsAdmin.config do |config|
    config.model LineItem do    
      visible false 
    end
  end
  
end
