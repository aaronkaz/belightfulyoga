class PromoCode < AbstractModel
  
  has_many :cart_promo_codes, :dependent => :destroy
  has_many :carts, :through => :cart_promo_codes
  
  attr_accessible :amount, :code, :description, :discount_type, :expiration_date, :line_itemable_type, :must_have_qty, :start_date, :unique
  
  VIEW_COLUMNS = [ ['id', ''], ['code', ''], ['description', ''], ['discount_type', ''], ['amount', ''] ]
  #FORM_COLUMNS = [ ['code', 'association_select'], ['first_name', 'string'], ['last_name', 'string'], ['home_phone', 'string'], ['work_phone', 'string'], ['work_phone_ext', 'string'], ['cell_phone', 'string'], ['occupation', 'string'], ['emergency_contact', 'string'], ['birthdate', 'string'] ]
  
  FILTER_COLUMNS = ['id', 'code', 'discount_type']
  SEARCH_COLUMNS = ['id', 'code', 'description']
  
  
end
