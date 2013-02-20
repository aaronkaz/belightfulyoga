class PromoCode < AbstractModel
  
  #def self.attributes_protected_by_default
  #    # default is ["id","type"]
  #    []
  #end
  
  has_many :cart_promo_codes, :dependent => :destroy
  has_many :carts, :through => :cart_promo_codes
  
  attr_accessible :amount, :code, :description, :discount_type, :expiration_date, :line_itemable_type, :must_have_qty, :start_date, :unique, :id
  validates_presence_of :amount, :code, :discount_type
  
  RailsAdmin.config do |config|
    config.model PromoCode do    
      navigation_label 'Course Management'
      weight -8
      
      edit do
        group :general do
          label 'Basic Info'
          field :code
          field :description
          field :start_date
          field :expiration_date
          field :discount_type, :enum do
            enum do
              ['dollar']
            end
          end
          field :amount
        end
        group :conditions do
          label 'Conditions'
          field :must_have_qty
          field :unique do
            label 'Check if Qty must be unique items.'
          end 
          field :line_itemable_type, :enum do
            enum do
              ['Course']
            end
          end 
        end
      end
      
    end
  end
  
end
