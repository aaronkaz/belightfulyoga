module Admin::ApplicationHelper
  
  def sidebar_link(m)
    model_class = m.constantize
    content_tag :li, link_to(model_class.model_name.human.titleize.pluralize, eval("admin_#{model_class.model_name.tableize}_path")), :class => params[:controller] == "admin/#{model_class.model_name.tableize}" ? "active" : nil  	
  end
  
  def link_to_filter_attribute(column)
    rand_id = rand(10000)
    fields = render('admin/shared/filter_row', id: rand_id, attribute: column, o: nil, q: nil)
    link_to column.humanize, '#', class: "filter_attr", data: {id: rand_id, fields: fields.gsub("\n", ""), "field-name" => column}
  end
  
  def sortable(column, title = nil)
  title ||= column.titleize
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
  
  def error_messages_ajax_for(object)
		render(:partial => 'shared/error_message_ajax', :locals => {:object => object })
	end
  
end