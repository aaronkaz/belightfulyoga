class Course < AbstractModel
  
  def self.attributes_protected_by_default
      # default is ["id","type"]
      []
  end
  
  
  #ASSOCIATIONS
  belongs_to :client_group
  belongs_to :teacher  
  has_many :course_registrations, :dependent => :destroy
  has_many :users, :through => :course_registrations
  has_many :course_events, :dependent => :destroy  
  has_many :line_items, as: :line_itemable
  
  
  #ACCESSORS
  attr_accessor :ics_file
  attr_accessible :client_group_id, :teacher_id, :title, :end_date, :hide_date, :is_family, :description, 
  :location, :notes, :price, :paid_by_company, :start_date, :start_time, :image, :image_cache, :remove_image, :length_minutes, :teacher_rate#, :id, :end_time #show for seed
  #attr_accessible :end_time, :day
  
  
  #OTHER MACROS
  mount_uploader :image, CourseImageUploader
  
  
  #CALLBACKS
  validates_presence_of :client_group_id, :end_date, :price, :start_date, :start_time, :length_minutes#, :teacher_id, :teacher_rate #hide for seed
  after_commit :create_or_update_events
  
  
  #VIRTUAL METHODS
  
  def day
    self.start_date.strftime("%A")
  end
  
  def end_time
    self.start_time + self.length_minutes.minutes
  end
  
  def line_item_title
    "#{self.default_title} Course -- #{self.start_date.strftime('%m/%d/%Y')} to #{self.end_date.strftime('%m/%d/%Y')}"
  end
  
  def admin_title
    "#{self.client_group.title} - #{self.start_date.strftime('%m/%d/%Y')} to #{self.end_date.strftime('%m/%d/%Y')}" rescue "#{id}"
  end
  
  def default_title
    "Belightful Yoga #{self.title}"
  end
  
  def address
    address = ""
    address << "#{self.location}<br>" unless self.location.blank?
    address << self.client_group.full_address
    address
  end
  
  
  #RAILS ADMIN
  RailsAdmin.config do |config|
    config.model Course do    
      navigation_label 'Course Management'
      weight -11
      object_label_method do
          :admin_title
      end
      
      edit do
        group :course_data do
          label "Course Data"
          field :client_group
          field :teacher
          field :teacher_rate
          field :paid_by_company do
            label 'Amount Paid by Company'
            help 'Use this field if registrations are pre-paid for users.  Leave price below at 0.'
          end
          field :location do
            label 'Location/Room'
          end
          field :is_family do
            help 'Check this box to allow family registrations.'
          end
        end
        group :course_info do
          label "Registration Details"
          field :title do
            help "'Belightful Yoga' will be prepended to all class names.  Leave blank if no additional information is needed."
          end
          field :start_date
          field :end_date
          field :hide_date do
            help 'set the date to close online registration'
          end  
          #field :day, :enum do
          #  enum do
          #    ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
          #  end
          #end
          field :start_time
          field :length_minutes, :enum do
            enum do
              ['30', '45', '60', '75', '90', '105', '120']
            end
          end
          field :price
          field :notes
          field :image, :carrierwave    
        end
      end
      
    end
  end
  
protected

  def create_or_update_events
    unless self.start_date.blank? || self.end_date.blank?
      from = self.start_date
      to = self.end_date
      tmp_date = from
      tmp_index = 0        
      begin
        event = self.course_events.find_or_create_by_event_index(tmp_index)
        event.update_attributes(:event_date => "#{tmp_date} #{self.start_time}", :teacher_id => self.teacher_id, :teacher_pay_out => self.teacher_rate)
        tmp_date += 1.week
        tmp_index += 1
      end while tmp_date <= to
    end  
  end  
  
end
