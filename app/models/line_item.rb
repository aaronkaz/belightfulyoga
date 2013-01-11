class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :line_itemable, polymorphic: true
  attr_accessible :line_itemable_id, :line_itemable_type, :qty
  
  before_create { self.cart.update_attribute(:shipping_confirm, false) }
  before_destroy { self.cart.update_attribute(:shipping_confirm, false) }
end
