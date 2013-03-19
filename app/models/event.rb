class Event < ActiveRecord::Base
  attr_accessible :description, :end_date, :end_time, :start_date, :start_time, :title
  
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
      end
      
    end
  end
end
