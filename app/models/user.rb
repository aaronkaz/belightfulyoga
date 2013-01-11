class User < AbstractModel
  
  belongs_to :client_group
  has_many :addresses
  has_many :carts
  has_many :waivers
  
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
  
  with_options :if => :code do |user|
    user.validates_presence_of :code  
    user.before_validation :check_code
  end
  
  
  
  
  VIEW_COLUMNS = [ ['id', ''], ['client_group', 'association_select'], ['email', ''], ['first_name', ''], ['last_name', ''] ]
  FORM_COLUMNS = [ ['client_group', 'association_select'], ['first_name', 'string'], ['last_name', 'string'], ['home_phone', 'string'], ['work_phone', 'string'], ['work_phone_ext', 'string'], ['cell_phone', 'string'], ['occupation', 'string'], ['emergency_contact', 'string'], ['birthdate', 'string'] ]
  
  FILTER_COLUMNS = ['first_name', 'last_name', 'client_group_id']
  SEARCH_COLUMNS = ['id', 'first_name', 'last_name', 'email']
  
  ASS_SEL_VIEW = ['first_name', 'last_name']
  
  
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
