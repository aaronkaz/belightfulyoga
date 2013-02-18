class ClientGroup < AbstractModel
  has_many :users
  has_many :courses
  
  attr_accessible :code, :image, :title, :type, :image_cache, :address_1, :address_2, :city, :state, :postal_code, :phone
  validates_presence_of :code, :title
  
  extend FriendlyId
    friendly_id :title, use: :slugged
  
  mount_uploader :image, ClientGroupImageUploader
  
  def full_address
    address = "#{address_1}<br>"
    address << "#{address_2}<br>" unless address_2.blank?
    address << "#{city}, #{state} #{postal_code}"
    address
  end
    
  RailsAdmin.config do |config|
    config.model ClientGroup do    
      navigation_label 'Course Management'
      weight -12
      
      edit do
        field :code
        field :title
        field :address_1
        field :address_2
        field :city
        field :state
        field :postal_code
        field :phone
        field :image, :carrierwave
      end
    end
  end  
  
protected
  
  def self.attributes_protected_by_default
      # default is ["id","type"]
      ["id"]
  end
  
end
