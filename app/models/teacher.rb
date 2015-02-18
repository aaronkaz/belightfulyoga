class Teacher < Admin
  default_scope {where(:is_teacher => true)}
  
  has_many :courses
  has_many :course_events
  has_many :pay_outs
  
  mount_uploader :photo, TeacherPhotoUploader
  
  attr_accessible :show_on_web, :bio, :photo, :photo_cache
  
  validates_presence_of :first_name, :last_name, :color
  
  def full_name
    return "#{self.first_name} #{self.last_name}"
  end
  
  RailsAdmin.config do |config|
    config.model Teacher do 
      navigation_label 'Users'
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
        group :general do
          label "General Info"
          field :first_name
          field :last_name
          field :email
          field :password
          field :password_confirmation
          field :color
          field :admin
        end
        group :web do
          label "Website Info"
          field :show_on_web
          field :bio, :ck_editor
          field :photo, :carrierwave
        end  
      end
      
    end
  end
  
end
