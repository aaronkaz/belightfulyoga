class Course < AbstractModel

  #ASSOCIATIONS
  belongs_to :client_group
  belongs_to :teacher  
  has_many :course_registrations, :dependent => :destroy
  has_many :users, :through => :course_registrations
  has_many :course_events, :order => :event_date, :dependent => :destroy 
    accepts_nested_attributes_for :course_events, :allow_destroy => true
  has_many :line_items, as: :line_itemable
  
  
  #ACCESSORS
  attr_accessor :ics_file, :schedule
  attr_accessible :client_group_id, :teacher_id, :title, :end_date, :hide_date, :is_family, :description, 
  :location, :notes, :price, :paid_by_company, :start_date, :start_time, :image, :image_cache, :remove_image, :length_minutes, :teacher_rate, :end_time, :old_id, 
  :active, :course_events_attributes, :frequency
  #attr_accessible :end_time, :day
  
  
  #OTHER MACROS
  mount_uploader :image, CourseImageUploader
  
  
  #CALLBACKS
  validates_presence_of :client_group_id, :end_date, :price, :start_date, :start_time, :length_minutes#, :teacher_id, :teacher_rate #hide for seed
  validates_presence_of :teacher_id, :teacher_rate, :if => lambda { self.active? }
  
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
      
      list do
        sort_by :start_date
        sort_reverse true
        field :id
        field :client_group
        field :start_date
        field :end_date
        field :teacher
        field :schedule do
          pretty_value do
            if bindings[:object].active?
              bindings[:view].link_to(bindings[:view].raw("<i class='icon-calendar'></i>"), bindings[:view].main_app.edit_scheduler_course_path(bindings[:object]), :class => "btn btn-small")
            end
          end
        end
        field :active
        field :course_registrations do
          pretty_value do
            bindings[:view].link_to("#{bindings[:object].course_registrations.count}", {:action => :index, :controller => 'rails_admin/main', :model_name => "CourseRegistration", "f[course][51422][o]" => "is", "f[course][51422][v]" => "#{bindings[:object].id}", :query => ""})
          end
        end
        field :is_family
      end
      
      edit do
        group :course_data do
          label "Course Data"
          field :active
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
          field :start_time do
            strftime_format "%I:%M %p"
          end
          field :length_minutes, :enum do
            label 'Class Length'
            help 'in hours'
            enum do
              (30..360).step(15).collect { |i| ["#{i.to_d/60}", i]}
            end
          end
          field :frequency, :enum do
            enum do
              ['weekly', 'daily']
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
