class Teacher < Admin
  default_scope where(:is_teacher => true)
  
  has_many :courses
  has_many :course_events
  
  validates_presence_of :first_name, :last_name, :color
  
  def full_name
    return "#{self.first_name} #{self.last_name}"
  end
  
  RailsAdmin.config do |config|
    config.model Teacher do 
      parent Admin
      weight -3
      
      object_label_method :full_name
      configure :color, :color
      
      list do
        sort_by :first_name
        field :id
        field :first_name
        field :last_name
        field :email
        field :color
      end
      
      edit do
        field :first_name
        field :last_name
        field :email
        field :password
        field :password_confirmation
        field :color
      end
      
    end
  end
  
end
