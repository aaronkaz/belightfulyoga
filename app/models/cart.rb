class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :billing_address, :class_name => 'Address', :foreign_key => :billing_address_id
    accepts_nested_attributes_for :billing_address
  belongs_to :shipping_address, :class_name => 'Address', :foreign_key => :shipping_address_id
    accepts_nested_attributes_for :shipping_address  
  
  has_many :line_items, :dependent => :destroy
    accepts_nested_attributes_for :line_items, :allow_destroy => true
  has_many :courses, :class_name => "LineItem", :conditions => { :line_itemable_type => "Course"}
  has_many :products, :class_name => "LineItem", :conditions => { :line_itemable_type => "Product"}
  
  has_many :cart_promo_codes, :dependent => :destroy
  has_many :promo_codes, :through => :cart_promo_codes
  
  has_one :waiver
    accepts_nested_attributes_for :waiver
     
  attr_accessor :ship_to_billing, :promo_code
  attr_accessible :line_items_attributes, :billing_address_id, :postal_code, :selected_shipping_array, :shipping_address_id, :shipping_confirm, :status, 
    :billing_address_attributes, :shipping_address_attributes, :ship_to_billing, :waiver_attributes, :promo_code
  
  before_create { self.status = "New" }
  before_update :link_shipping, :if => lambda { self.ship_to_billing == "1" }
  before_update :shipping_uncomfirm, :if => lambda { self.shipping_address_id_changed? || self.line_items_changed? }
  before_validation :do_promo, :if => lambda { self.promo_code.present? && self.promo_code != "" }
  
  def total_weight
    total_weight = 0
    self.line_items.each do |line_item|
      line_item_weight = line_item.line_itemable.weight || 0
      total_weight = (total_weight + (line_item_weight * line_item.qty))
    end
    total_weight
  end
  
  def subtotal
    subtotal = 0
    self.line_items.each do |line_item|
      subtotal = (subtotal + (line_item.line_itemable.price * line_item.qty))
    end
    subtotal
  end
  
  def sales_tax
    self.billing_address.state == "MI" ? (self.subtotal * 0.06) : "0"
  end
  
  def grand_total
    self.subtotal + self.sales_tax.to_d + self.selected_shipping_array.split(',')[1].to_d
  end
  
  def line_items_changed?
    line_items.any?(&:changed?)
  end
  
protected
  
  def link_shipping
    self.shipping_address = self.billing_address
  end
  
  def shipping_uncomfirm
    self.shipping_confirm = 0
  end
  
  def do_promo
    if promo = PromoCode.find_by_code(promo_code)
      # VALIDATE THE PROMO
      # PASS DATES IF AVAILABLE
      # PASS CONDITIONS IF AVAILABLE
      # REMOVE OTHER PROMOS IS PRESENT OR CONFINE TO HAS_ONE
      errors.add :promo_code, "found it"
    else
      errors.add :promo_code, "not found"
    end  
  end
  
end
