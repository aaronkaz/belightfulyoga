class AbstractModel < ActiveRecord::Base
  
  self.abstract_class = true
  
  ALLOW_NEW = true
  ALLOW_EDIT = true
  ALLOW_DELETE = true
  ALLOW_SHOW = true
  ALLOW_FILTER = true
  ALLOW_BULK = true

  def self.search(search)
    if !search.blank?
      query_string = ""
      #self.columns.each_with_index do |column, index| 
      self::SEARCH_COLUMNS.each_with_index do |column, index| 
        query_string << " OR " unless index == 0
        query_string << "CAST(#{column} as TEXT) ilike :search"
      end  
      where(query_string, {:search => "%#{search}%"})
    else
      scoped
    end
  end
  
  def self.filters(filters)
    if filters
      query_string = ""
      filters.each_with_index do |filter, index|
        query_string << " AND " unless index == 0
        if filter[1].to_a[0][1].include?('.') #find if filter specifies the table
          query_string << "CAST(#{filter[1].to_a[0][1]} as TEXT) #{filter[1].to_a[1][1]} "
        else  
          query_string << "CAST(#{self.model_name.tableize}.#{filter[1].to_a[0][1]} as TEXT) #{filter[1].to_a[1][1]} "
        end  
        if filter[1].to_a[1][1] == "iLIKE"
          query_string << "'%#{filter[1].to_a[2][1]}%'"
        else
          query_string << "'#{filter[1].to_a[2][1]}'"
        end
      end  
      where(query_string)
    else
      scoped
    end
  end
  
end