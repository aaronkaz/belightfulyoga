class CarouselSlide < ActiveRecord::Base
  acts_as_list
  mount_uploader :image, CarouselSlideImageUploader
  
  attr_accessible :image, :image_cache, :remove_image, :url, :active
  
  
  RailsAdmin.config do |config|
    config.model CarouselSlide do    
      navigation_label 'CMS'
      weight -6
      
      list do
        sort_by :position
        field :position
        field :image
        field :url
        field :active
      end
      
      edit do
        field :image, :carrierwave
        field :url
        field :active
      end
      
    end
  end
  
  
end
