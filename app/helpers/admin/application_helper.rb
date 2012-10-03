module Admin::ApplicationHelper
  
  def sidebar_link(m)
    model_class = m.constantize
    content_tag :li, link_to(model_class.model_name.human.titleize.pluralize, eval("admin_#{model_class.model_name.tableize}_path")), :class => params[:controller] == "admin/#{model_class.model_name.tableize}" ? "active" : nil  	
  end
  
  def link_to_filter_attribute(column)
    rand_id = rand(10000)
    fields = render('admin/shared/filter_row', id: rand_id, attribute: column.name, o: nil, q: nil)
    link_to column.name, '#', class: "filter_attr", data: {id: rand_id, fields: fields.gsub("\n", ""), "field-name" => column.name}
  end
  
end