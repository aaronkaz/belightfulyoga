class ClientGroup < AbstractModel
  
  has_many :users
  has_many :courses
  belongs_to :contact_person, :class_name => "User"
  
  attr_accessible :code, :image, :title, :type, :image_cache, :address_1, :address_2, :city, :state, :postal_code, :phone, 
  :contact_person_id, :contact_notes, :contact_name, :contact_email, :contact_phone
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
  
  
  def participating_users
    self.users.joins(:course_registrations).group('users.id')
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
        field :users do
          label 'Reg. Users'
          pretty_value do
            if bindings[:object].users.any?
              bindings[:view].link_to(bindings[:object].users.length, {:action => :index, :controller => 'rails_admin/main', :model_name => "Customer", "f[client_group][21814][o]" => "is", "f[client_group][21814][v]" => "#{bindings[:object].id}", :query => ""}, class: "btn btn-mini")
            else
              ""
            end     
          end  
        end
        
        field :participating_users do
          label 'Participants'
          pretty_value do
            if bindings[:object].participating_users.any?
              bindings[:view].link_to(bindings[:object].participating_users.length, {:action => :index, :controller => 'rails_admin/main', :model_name => "Customer", "f[courses][21814][v]" => "#{bindings[:object].id}", :query => ""}, class: "btn btn-mini")
            else
              ""
            end     
          end  
        end
        
      end
      
      edit do
        group :general do
          label "General Info"
          field :code
          field :title
          field :address_1
          field :address_2
          field :city
          field :state
          field :postal_code
          field :phone
        end
        group :contact do
          label "Contact Info" 
          field :contact_name
          field :contact_email
          field :contact_phone 
          field :contact_notes
        end  
        #field :contact_person
        #field :contact_person do
        #  nested_form false
        #  associated_collection_cache_all false  # REQUIRED if you want to SORT the list as below
        #  associated_collection_scope do
        #      # bindings[:object] & bindings[:controller] are available, but not in scope's block!
        #      client_group = bindings[:object]
        #      Proc.new { |scope|
        #        # scoping all Players currently, let's limit them to the team's league
        #        # Be sure to limit if there are a lot of Players and order them by position
        #        scope = scope.where(client_group_id: client_group.id) if 
        #        scope = scope.reorder('first_name ASC') # REorder, not ORDER
        #      }
        #  end
        #end
        group :other do
          label "Other"
          field :image, :carrierwave
        end
      end
    end
  end  
  
protected
  
  def self.attributes_protected_by_default
      # default is ["id","type"]
      ["id"]
  end
  
end
