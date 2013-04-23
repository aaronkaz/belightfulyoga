class ClientGroup < AbstractModel
  
  has_many :users
  has_many :courses
  belongs_to :contact_person, :class_name => "User"
  
  attr_accessible :code, :image, :title, :type, :image_cache, :address_1, :address_2, :city, :state, :postal_code, :phone, :contact_person_id, :contact_notes
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
      
      list do
        sort_by :title
        field :id
        field :code
        field :title
      end
      
      edit do
        field :code
        field :title
        field :address_1
        field :address_2
        field :city
        field :state
        field :postal_code
        field :phone
        #field :contact_person
        field :contact_person do
          nested_form false
          associated_collection_cache_all false  # REQUIRED if you want to SORT the list as below
          associated_collection_scope do
              # bindings[:object] & bindings[:controller] are available, but not in scope's block!
              client_group = bindings[:object]
              Proc.new { |scope|
                # scoping all Players currently, let's limit them to the team's league
                # Be sure to limit if there are a lot of Players and order them by position
                scope = scope.where(client_group_id: client_group.id)
                scope = scope.reorder('first_name ASC') # REorder, not ORDER
              }
          end
        end
        field :contact_notes
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
