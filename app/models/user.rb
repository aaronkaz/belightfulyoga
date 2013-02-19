class User < ActiveRecord::Base
  
  def self.attributes_protected_by_default
      # default is ["id","type"]
      []
  end
  
  belongs_to :client_group
  has_many :addresses
  has_many :carts
  has_many :course_registrations
    has_many :courses, :through => :course_registrations
  has_many :course_attendees, as: :attendable
  has_many :walkins, :source => :course_attendees, :foreign_key => :attendable_id, :conditions => { :walk_in => true }
    accepts_nested_attributes_for :walkins
  has_many :waivers
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :code
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :client_group_id, :synced_to_mailchimp, :first_name, :middle_initial, :last_name, :address_1, :address_2, 
  :city, :state, :zip, :home_phone, :work_phone, :work_phone_ext, :cell_phone, :occupation, :emergency_contact, :birthdate, :guardian, :code,
  :walkins_attributes
  
  validates_presence_of :first_name, :last_name, :email
  
  with_options :if => :code do |user|
    user.validates_presence_of :code  
    user.before_validation :check_code
  end
  
  def full_name
    return "#{first_name} #{last_name}"
  end
  
  def attended_course?(course_event_id)
    CourseEvent.find(course_event_id).attendees.find_by_attendable_type_and_attendable_id("User", self.id).present?
  end
  
  RailsAdmin.config do |config|
    config.model User do    
      label 'Site User'
      navigation_label 'Users'
      weight -2
      
      object_label_method do
          :full_name
      end
    end
  end
  
  
protected
  
  def check_code
    client_group = ClientGroup.find_by_code(self.code)
    if client_group
      self.client_group_id = client_group.id
    else  
      self.errors.add :code, "does not match any registered groups"
    end  
  end
end
