class Waiver < ActiveRecord::Base
  belongs_to :cart
  belongs_to :user
  attr_accessible :address_1, :address_2, :birth_date, :cell_phone, :city, :email_address, :emergency_contact, :family_members, :first_name, :guardian_of, :guardian_signature, :home_phone, :last_name, :middle_initial, :occupation, :postal_code, :referral, :signature, :state, :work_phone, :work_phone_ext
  
  before_validation { self.user = self.cart.user }
  validates_presence_of :first_name, :last_name, :address_1, :city, :state, :postal_code
  validate :phone_exists
  validates_presence_of :birth_date, :email_address, :occupation, :emergency_contact, :referral
  validate :signature_sanity
  
  after_create :update_user_profile
  
protected

  def phone_exists
    if cell_phone.blank? && home_phone.blank? && work_phone.blank?
      errors.add "home, work, or cell number", "must be present"
    end
  end
  
  def signature_sanity
    if signature.blank? && guardian_signature.blank?
      errors.add :signature
    else
      #CHECK THAT SIGNATURE CONTAINS FIRST NAME AND LAST NAME
      if !signature.blank?
        errors.add :signature, "does not match entered name" unless signature.downcase.include?(first_name.downcase) && signature.downcase.include?(last_name.downcase)
      end 
      #IF SOMETHING ENTERED FOR GUARDIAN OF OR SIGNATURE, MAKE SURE THERE IS MATCH
      errors.add :guardian_of, "must be present" if !guardian_signature.blank? && guardian_of.blank?
      errors.add :guardian_signature, "must be present" if !guardian_of.blank? && guardian_signature.blank?
      errors.add :guardian_signature, "does not match entered name" unless (guardian_signature.downcase.include?(first_name.downcase) && guardian_signature.downcase.include?(last_name.downcase)) || guardian_signature.blank?
    end
  end
  
  def update_user_profile
    user.update_attributes(:first_name => first_name, :middle_initial => middle_initial, :last_name => last_name, :home_phone => home_phone, :cell_phone => cell_phone, :work_phone => work_phone, :work_phone_ext => work_phone_ext, :occupation => occupation)
  end
  
end
