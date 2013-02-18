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
      
      object_label_method do
          :full_name
      end
    end
  end
  
end
