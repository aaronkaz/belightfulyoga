module Scheduler::ApplicationHelper
  
  def sortable(column, title = nil)
  title ||= title.titleize
  css_current = column == sort_column ? "current sort-column" : "sort-column"

  if column == sort_column && sort_direction == "asc"
    css_class = "ui-icon-triangle-1-n"
  elsif column == sort_column && sort_direction == "desc"
    css_class = "ui-icon-triangle-1-s"
  else
    css_class = "ui-icon-triangle-2-n-s"
  end
    
  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
  link_to content_tag('span', '', :class => 'ui-icon ' + css_class) + title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_current}
  
  end
  
  def boolean_show(bool)
    if bool == true
      content_tag :span, raw("<i class='icon-check'></i>"), :class => "badge badge-success"
    else
      content_tag :span, raw("<i class='icon-remove'></i>"), :class => "badge badge-important"
    end
  end
  
end
