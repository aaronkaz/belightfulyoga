class User < ActiveRecord::Base
  
  belongs_to :client_group
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :code
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :client_group_id, :synced_to_mailchimp, :first_name, :middle_initial, :last_name, :address_1, :address_2, 
  :city, :state, :zip, :home_phone, :work_phone, :work_phone_ext, :cell_phone, :occupation, :emergency_contact, :birthdate, :guardian, :code
  
  validates_presence_of :code  
  before_validation :check_code
  
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
