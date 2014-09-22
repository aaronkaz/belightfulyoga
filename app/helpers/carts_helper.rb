module CartsHelper
  
  def registrants_breadcrumb(index)
    link_to_unless @stage == "registrants", raw("<span class='badge'>#{index}</span> Registrants"), checkout_cart_path(@cart, :stage => "registrants")
  end
  
  def billing_address_breadcrumb(index)
    link_to_unless @stage == "billing" || (@cart.multiple_registrants? && !@cart.registrants_complete?), raw("<span class='badge'>#{index}</span> Billing Address"), checkout_cart_path(@cart, :stage => "billing")
  end
  
  def shipping_address_breadcrumb(index)
    link_to_unless @stage == "shipping" || (@cart.multiple_registrants? && !@cart.registrants_complete?) || @cart.billing_address.nil?, raw("<span class='badge'>#{index}</span> Shipping Address"), checkout_cart_path(@cart, :stage => "shipping")
  end
  
  def shipping_method_breadcrumb(index)
    link_to_unless @stage == "shipping_method" || (@cart.multiple_registrants? && !@cart.registrants_complete?) || @cart.billing_address.nil? || @cart.shipping_address.nil?, raw("<span class='badge'>#{index}</span> Shipping Method"), checkout_cart_path(@cart, :stage => "shipping_method")
  end
  
  def waiver_breadcrumb(index)
    link_to_unless @stage == "waiver" || (@cart.multiple_registrants? && !@cart.registrants_complete?) || (@cart.billable? && @cart.billing_address.nil?) || (@cart.shippable? && @cart.shipping_address.nil?) || (@cart.shippable? && !@cart.shipping_confirm?), raw("<span class='badge'>#{index}</span> Course Waiver"), checkout_cart_path(@cart, :stage => "waiver")
  end
  
  def review_breadcrumb(index)
    link_to_unless @stage == "review" || (@cart.multiple_registrants? && !@cart.registrants_complete?) || (@cart.billable? && @cart.billing_address.nil?) || (@cart.shippable? && @cart.shipping_address.nil?) || (@cart.shippable? && !@cart.shipping_confirm?) || (!@cart.waivers_complete?), raw("<span class='badge'>#{index}</span> Review and Pay"), checkout_cart_path(@cart, :stage => "review")
  end
  
  
  def link_to_add_guest(name, f, association)
      new_object = f.object.send(association).klass.new
      id = new_object.object_id
      fields = f.fields_for(association, new_object, child_index: id) do |builder|
        render('waiver_guest', f: builder)
      end
      link_to(raw("<i class='icon-plus icon-white'></i> #{name}"), "#", class: "btn btn-info", id: "add_waiver_guest", data: {id: id, fields: fields.gsub("\n", "")})
  end
  
  def link_to_add_non_user(name, f, association = :non_users)
      new_object = f.object.send(association).klass.new
      id = new_object.object_id
      fields = f.fields_for(association, new_object, child_index: id) do |builder|
        render('line_item_non_user', non_user: builder)
      end
      link_to(raw("<i class='icon-plus icon-white'></i> #{name}"), "#", class: "btn btn-info", id: "add_non_user", data: {id: id, fields: fields.gsub("\n", "")})
  end
    
end
