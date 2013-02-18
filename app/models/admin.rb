class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :first_name, :last_name, :is_teacher, :first_name, :last_name, :is_teacher, :color
  
  RailsAdmin.config do |config|
    config.model Admin do   
      label 'Administrator' 
      navigation_label 'Users'
      weight -3
    end
  end
  
end
