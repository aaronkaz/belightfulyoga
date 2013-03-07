class Cart < ActiveRecord::Base

  belongs_to :user
  belongs_to :billing_address, :class_name => 'Address', :foreign_key => :billing_address_id
    accepts_nested_attributes_for :billing_address
  belongs_to :shipping_address, :class_name => 'Address', :foreign_key => :shipping_address_id
    accepts_nested_attributes_for :shipping_address  
  
  has_many :line_items, :dependent => :destroy
    accepts_nested_attributes_for :line_items, :allow_destroy => true
    
  has_many :courses, :class_name => "LineItem", :conditions => { :line_itemable_type => "Course"}
  has_many :course_registrations
  
  has_many :products, :class_name => "LineItem", :conditions => { :line_itemable_type => "Product"}
  
  has_many :cart_promo_codes, :dependent => :destroy
    accepts_nested_attributes_for :cart_promo_codes
  has_many :promo_codes, :through => :cart_promo_codes
    accepts_nested_attributes_for :promo_codes, :allow_destroy => true
  
  has_one :waiver
    accepts_nested_attributes_for :waiver
     
  attr_accessor :ship_to_billing, :promo_code
  attr_accessible :line_items_attributes, :billing_address_id, :postal_code, :selected_shipping_array, :shipping_address_id, :shipping_confirm, :status, 
    :billing_address_attributes, :shipping_address_attributes, :ship_to_billing, :waiver_attributes, :promo_code, :promo_codes_attributes, :cart_promo_codes_attributes,
    :id, :user_id, :session_id#, :created_at, :updated_at
  
  before_create { self.status = "New" }
  before_update :link_shipping, :if => lambda { self.ship_to_billing == "1" }
  before_update :shipping_uncomfirm, :if => lambda { self.shipping_address_id_changed? || self.line_items_changed? }
  
  after_update :check_promos
  after_commit :find_or_create_registrations, :if => lambda { self.status == "Completed" }
  
  def total_weight
    total_weight = 0
    self.line_items.each do |line_item|
      line_item_weight = line_item.line_itemable.weight || 0
      total_weight = (total_weight + (line_item_weight * line_item.qty))
    end
    total_weight
  end
  
  def subtotal
    subtotal = self.line_items.sum('unit_price * qty')
    discounts = self.promo_codes.where(:discount_type => "dollar").sum(:amount)
    return (subtotal.to_d - discounts.to_d)
  end
  
  def sales_tax
    #self.billing_address.present? && self.billing_address.state == "MI" ? (self.subtotal * 0.06) : "0"
    return "0"
  end
  
  def grand_total
    self.subtotal + self.sales_tax.to_d
  end
  
  def billable?
    self.subtotal.to_i == 0 ? false : true
  end
  
  def shippable?
    self.products.empty? ? false : true
  end
  
  def require_waiver?
    self.courses.empty? ? false : true
  end
  
  def family_courses
    courses.joins('INNER JOIN courses ON courses.id = line_items.line_itemable_id').where('courses.is_family is true')
  end
  
  def has_family_course?
    family_courses.length > 0 ? true : false
  end
  
  def line_items_changed?
    line_items.any?(&:changed?)
  end
  
  RailsAdmin.config do |config|
    config.model Cart do    
      navigation_label 'Orders'
      weight -7
      
      list do
        field :id
        field :status
        field :user
        field :line_items do
          pretty_value do
            bindings[:view].link_to("#{bindings[:object].line_items.count}", {:action => :index, :controller => 'rails_admin/main', :model_name => "LineItem", "f[course][51422][o]" => "is", "f[cart][51422][v]" => "#{bindings[:object].id}", :query => ""})
          end
        end
      end
      
    end
  end
  
protected
  
  def link_shipping
    self.shipping_address = self.billing_address
  end
  
  def shipping_uncomfirm
    self.shipping_confirm = 0
  end
  
  def check_promos
    cart_promo_codes.each do |promo|
      promo.destroy if !promo.valid?
    end  
  end
  
  def find_or_create_registrations
    logger.info "CHECK REGISTRATIONS!!"
    self.courses.each do |course|
      class_price = course.unit_price
      course_promos = self.promo_codes.where(:line_itemable_type => "Course").where(:discount_type => "dollar").sum(:amount)
      class_paid = ( class_price - (course_promos / self.courses.length) )
      registration = self.course_registrations.find_or_create_by_course_id_and_user_id(course.line_itemable_id, self.user_id)
      registration.update_attributes(:registration_type => "online", :paid => class_paid)
    end  
  end
  
end
