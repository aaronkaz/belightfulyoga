class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_cart
  
private

  def current_cart
    Cart.where(:status => "New").find(cookies[:cart_id])
    rescue ActiveRecord::RecordNotFound
    nil 
  end
  
  def initialize_page(id)
    @page = Page.find(id)
    @page.page_parts.each do |pp|
      instance_variable_set "@#{pp.title.gsub(' ', '_').downcase}", @page.page_part_placements.find_by_page_part_id(pp.id)
    end 
  end
  
  def account_sidebar
    @sidebar_override = render_to_string(:partial => 'layouts/account')
  end

  def make_tmpname(prefix_suffix, n)
    case prefix_suffix
    when String
      prefix = prefix_suffix
      suffix = ""
    when Array
      prefix = prefix_suffix[0]
      suffix = prefix_suffix[1]
    else
      raise ArgumentError, "unexpected prefix_suffix: #{prefix_suffix.inspect}"
    end
    t = Time.now.strftime("%Y%m%d")
    path = ""
    path << "#{n}" if n
    path << "#{prefix}#{t}-#{$$}-#{rand(0x100000000).to_s(36)}"
    path << suffix
  end
  
end
