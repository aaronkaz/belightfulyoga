class NonUser < ActiveRecord::Base
  belongs_to :line_item
  has_one :cart, through: :line_item
  has_one :waiver
  
  has_one :course_registration, as: :registerable
  
  attr_accessible :age, :name
  
  validates_presence_of :age, :name
  
  def parent_user
    self.cart.user
  end
  
  def full_name
    name
  end
  
  def email
    self.cart.user.email
  end
  
end
