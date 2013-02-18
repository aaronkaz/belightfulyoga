module CartsHelper
  
  def billing_address_breadcrumb(index)
    link_to_unless @stage == "billing", raw("<span class='badge'>#{index}</span> Billing Address"), checkout_cart_path(@cart, :stage => "billing")
  end
  
  def shipping_address_breadcrumb(index)
    link_to_unless @stage == "shipping" || @cart.billing_address.nil?, raw("<span class='badge'>#{index}</span> Shipping Address"), checkout_cart_path(@cart, :stage => "shipping")
  end
  
  def shipping_method_breadcrumb(index)
    link_to_unless @stage == "shipping_method" || @cart.billing_address.nil? || @cart.shipping_address.nil?, raw("<span class='badge'>#{index}</span> Shipping Method"), checkout_cart_path(@cart, :stage => "shipping_method")
  end
  
  def waiver_breadcrumb(index)
    link_to_unless @stage == "waiver" || (@cart.billable? && @cart.billing_address.nil?) || (@cart.shippable? && @cart.shipping_address.nil?) || (@cart.shippable? && !@cart.shipping_confirm?), raw("<span class='badge'>#{index}</span> Course Waiver"), checkout_cart_path(@cart, :stage => "waiver")
  end
  
  def review_breadcrumb(index)
    link_to_unless @stage == "review" || (@cart.billable? && @cart.billing_address.nil?) || (@cart.shippable? && @cart.shipping_address.nil?) || (@cart.shippable? && !@cart.shipping_confirm?) || (@cart.require_waiver? && @cart.waiver.nil?), raw("<span class='badge'>#{index}</span> Review and Pay"), checkout_cart_path(@cart, :stage => "review")
  end
  
  
  def link_to_add_guest(name, f, association)
      new_object = f.object.send(association).klass.new
      id = new_object.object_id
      fields = f.fields_for(association, new_object, child_index: id) do |builder|
        render('waiver_guest', f: builder)
      end
      link_to(raw("<i class='icon-plus icon-white'></i> #{name}"), "#", class: "btn btn-info", id: "add_waiver_guest", data: {id: id, fields: fields.gsub("\n", "")})
  end
    
end
