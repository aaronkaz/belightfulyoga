class Event < ActiveRecord::Base
  attr_accessible :description, :end_date, :end_time, :start_date, :start_time, :title, :image, :image_cache, :remove_image
  
  mount_uploader :image, EventImageUploader
  
  def datetimestring
    if !self.start_date.blank?
      string = "#{self.start_date.strftime("%a")}., #{self.start_date.strftime('%b %d, %Y')}"
      string << " - #{self.end_date.strftime('%b %d, %Y')}" unless self.end_date.blank?
      string << ", #{self.start_time.strftime('%I:%M %p')}" unless self.start_time.blank?
      string << " - #{self.end_time.strftime('%I:%M %p')}" unless self.end_time.blank?
    else
      nil
    end
  end
  
  RailsAdmin.config do |config|
    config.model Event do    
      navigation_label 'CMS'
      weight -6
      
      edit do
        field :title
        field :start_date
        field :end_date
        field :start_time do
          strftime_format "%I:%M %p"
        end
        field :end_time do
          strftime_format "%I:%M %p"
        end
        field :description do
          ckeditor true
        end
        field :image, :carrierwave
      end
      
    end
  end
end
