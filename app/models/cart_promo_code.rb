class CartPromoCode < ActiveRecord::Base
  belongs_to :cart
  belongs_to :promo_code
  
  attr_accessor :add_promo
  attr_accessible :add_promo#, :cart_id, :promo_code_id
  
  before_validation :find_promo, :if => lambda { self.add_promo.present? && self.add_promo != "" }
  before_validation :check_promo
  
  RailsAdmin.config do |config|
    config.model CartPromoCode do    
      visible false 
    end
  end
  
protected

  def find_promo
    if promo = PromoCode.find_by_code(add_promo)
      self.promo_code_id = promo.id
    else
      errors.add :add_promo, "not found"
    end  
  end
  
  def check_promo
    if self.promo_code.present?
      if !self.promo_code.must_have_qty.blank? #check quantity
        if promo_code.unique? #check for unique items
          items = self.cart.line_items
          items = items.where(:line_itemable_type => promo_code.line_itemable_type) if promo_code.line_itemable_type.blank?
          if items.group('line_items.id').length < promo_code.must_have_qty
            errors.add "'#{promo_code.code}'", "must have #{promo_code.must_have_qty} line items"
          end  
        else #check total quantity
          items = self.cart.line_items
          items = items.where(:line_itemable_type => promo_code.line_itemable_type) if promo_code.line_itemable_type.blank?
          if items.sum(:qty) < promo_code.must_have_qty
            errors.add "'#{promo_code.code}'", "must have #{promo_code.must_have_qty}"
          end
        end
      end 
    end
    
    # get rid of other similar promos 
  end
  
end
