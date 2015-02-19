class Course < AbstractModel

  #ASSOCIATIONS
  belongs_to :client_group
  belongs_to :teacher  
  has_many :course_registrations, :dependent => :destroy
    accepts_nested_attributes_for :course_registrations
  
  
  #has_many :users, :through => :course_registrations
  
  has_many :course_events, -> {order(:event_date)}, :dependent => :destroy 
    accepts_nested_attributes_for :course_events, :allow_destroy => true
    has_many :walkins, :through => :course_events
  has_many :line_items, as: :line_itemable
  
  
  #ACCESSORS
  attr_accessor :ics_file, :schedule
  attr_accessible :client_group_id, :teacher_id, :title, :end_date, :hide_date, :is_family, :description, 
  :location, :notes, :price, :paid_by_company, :start_date, :start_time, :image, :image_cache, :remove_image, :length_minutes, :teacher_rate, :end_time, :old_id, 
  :active, :course_events_attributes, :frequency, :reminder, :course_registrations_attributes, :day, :course_type, :registration_type
  #attr_accessible :end_time, :day
  
  
  #OTHER MACROS
  mount_uploader :image, CourseImageUploader
  
  
  #CALLBACKS
  validates_presence_of :end_date, :price, :start_date, :start_time, :length_minutes, :frequency, :course_type#, :teacher_id, :teacher_rate #hide for seed
  validates_presence_of :teacher_id, :teacher_rate, :if => lambda { self.active? }
  
  validates_presence_of :client_group_id, :if => lambda { self.registration_type == 'private' }
  
  after_create :create_or_update_events, :if => lambda { self.active? && !self.start_date.blank? && !self.end_date.blank? && self.teacher.present? }
  after_save :create_or_update_events, :if => lambda { self.active? && (self.start_date_changed? || self.end_date_changed? || self.start_time_changed? || self.length_minutes_changed? || self.teacher_id_changed? || self.teacher_rate_changed?) }
  
  
  
  #SCOPES
  scope :unscheduled, -> {where(:active => true).where('courses.id NOT IN (SELECT DISTINCT(course_id) FROM course_events)').order(:start_date)}
  scope :current, -> {where(:active => true).where('start_date <= ? AND end_date >= ?', Date.today, Date.today)}
  scope :remind, -> {current.where('end_date <= ?', 3.weeks.from_now).where(:reminder => true).where('courses.client_group_id NOT IN ( SELECT client_group_id FROM courses WHERE client_group_id = courses.client_group_id AND start_date > ? )', 3.weeks.from_now) }
  
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
    address << self.client_group.full_address if self.client_group.present?
    address
  end
  
  def is_paid_by_company?
    paid_by_company.to_i != 0 ? true : false
  end
  
  
  def amount_collected
    if paid_by_company.to_i != 0
      paid_by_company
    else
      course_registrations.sum(:paid)
    end
  end
  
  def walkin_amount_collected
    walkins.sum(:paid)
  end
  
  def total_collected
    amount_collected + walkin_amount_collected
  end
  
  def total_pay_out
    course_events.sum(:teacher_pay_out) + (walkin_amount_collected * 0.5)
  end
  
  def net
    total_collected - total_pay_out
  end
  
  
  after_initialize do
    if self.new_record?
      self.course_type = 'individual'
    end
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
        field :client_group do
          searchable [:title, :id]
        end
        field :start_date
        field :end_date
        field :teacher
        field :schedule do
          searchable [:first_name, :last_name, :id]
          pretty_value do
            if bindings[:object].active?
              bindings[:view].link_to(bindings[:view].raw("<i class='icon-pencil'></i> Schedule"), bindings[:view].main_app.edit_scheduler_course_path(bindings[:object]), :class => "btn btn-mini")
            end
          end
        end
        field :active
        field :course_registrations do
          pretty_value do
            bindings[:view].link_to("#{bindings[:object].course_registrations.count}", {:action => :index, :controller => 'rails_admin/main', :model_name => "CourseRegistration", "f[course][51422][o]" => "is", "f[course][51422][v]" => "#{bindings[:object].id}", :query => ""})
          end
        end
        #field :is_family
      end
      
      edit do
        group :course_data do
          label "Course Data"
          field :active
          field :course_type, :enum do
            enum do
              [['Individual', 'individual'], ['Family/Group (single price)', 'family'], ['Family/Group (incurrs fees)', 'multiple']]
            end
          end
          field :registration_type, :enum do
            enum do
              [['Private', 'private'], ['Public', 'public'], ['Training', 'training']]
            end
          end
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
          #field :is_family do
          #  help 'Check this box to allow family registrations.'
          #end
          field :reminder do
            help 'Check for reminder to schedule next series'
          end
        end
        group :course_info do
          label "Registration Details"
          field :title do
            help "'Belightful Yoga' will be prepended to all class names.  Leave blank if no additional information is needed."
          end
          field :start_date
          field :end_date
          #field :hide_date do
          #  help 'set the date to close online registration'
          #end  
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
              (30..600).step(15).collect { |i| ["#{i.to_d/60}", i]}
            end
          end
          field :frequency, :enum do
            enum do
              ['weekly', 'daily', 'monthly']
            end
          end
          field :price
          field :notes, :ck_editor
          field :image, :carrierwave    
        end
      end
      
    end
  end
  
protected

  def freq_to_days
    if self.frequency == 'daily'
      return 1
    elsif self.frequency == 'weekly'
      return 7
    elsif self.frequency == 'monthly'
      return 28
    end
  end

  def generate_events(start_at, end_at)
    $tmp_date = start_at
    
    begin
      event = self.course_events.new
      event.update_attributes(:event_date => "#{$tmp_date} #{self.start_time}", :teacher_id => self.teacher_id, :teacher_pay_out => self.teacher_rate)
      if self.frequency == 'daily'
        $tmp_date += 1.day
      elsif self.frequency == 'weekly'
        $tmp_date += 1.week
      elsif self.frequency == 'monthly'
        $tmp_date += 4.weeks
      end
    end while $tmp_date <= end_at 
  end


  def create_or_update_events
    logger.info "\n\n\n\n\n\nfind or create\n\n\n\n\n\n\n\n\n"

      
      if self.course_events.empty?
    
        generate_events(self.start_date, self.end_date)
        
      else
        num_days = self.end_date.mjd - self.start_date.mjd
        num_events = (num_days / self.freq_to_days) + 1
        $tmp_date = self.start_date
        
        self.course_events.order(:event_date).each_with_index do |course_event, index|
          if (index + 1) > num_events
            course_event.destroy
          else
            course_event.update_attributes(:event_date => "#{$tmp_date} #{self.start_time}", :teacher_id => self.teacher_id, :teacher_pay_out => self.teacher_rate)
          end
        
          if self.frequency == 'daily'
            $tmp_date += 1.day
          elsif self.frequency == 'weekly'
            $tmp_date += 1.week
          elsif self.frequency == 'monthly'
            $tmp_date += 4.weeks
          end
          
        end
        
        if self.course_events.length < num_events
          generate_events($tmp_date, self.end_date)
        end
        
      end 
      
      #self.course_events.where('event_date > ?', self.end_date).delete_all 
  end  
  
end
