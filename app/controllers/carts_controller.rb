class CartsController < ApplicationController
  
  before_filter { @cart = current_cart }
  before_filter { initialize_page('shopping-cart') }
  before_filter :cart_sanity, :except => [:create, :update]
  
  helper_method :order_array
  
  def index
  end
  
  def create
    @cart = Cart.new(params[:cart])
    if @cart.save
      cookies[:cart_id] = { :value => @cart.id, :expires => Time.now + 1.week}
      redirect_to @cart
    else
      
    end
  end
  
  def show    
    @line_items = @cart.line_items
    
    if @cart.products.empty?
      @shipping_total = "0"
    end
    
    @total = (@cart.subtotal + @shipping_total.to_d)
    
    #unless @cart.postal_code.blank?
    #  @doc = UpsShipping.get_rates(@cart.postal_code, total_weight)
    #  @ups_rates = @doc
    #  @ups_rates = @ups_rates.xpath("//RatingServiceSelectionResponse/RatedShipment")
    #  # !!! NEED TO CHECK FOR FAILURE !!!
    #end
    #
    #shipping_total = @cart.selected_shipping_array.blank? ? "0" : found_node = @ups_rates.search("[text()*='#{@cart.selected_shipping_array.split(',')[0]}']").first.parent.parent.at_xpath('TotalCharges/MonetaryValue').text
    #@total = (@subtotal + shipping_total.to_d)

  end
  
  def update
    if @cart.update_attributes(params[:cart])
      if params[:checkout].present?
        redirect_to checkout_cart_path(@cart)
      else  
        flash[:success] = "Shopping cart updated!"
        redirect_to @cart
      end  
    else
      #flash[:danger] = "There was a problem updating your shopping.  Try again or contact support for further assistance."
      render 'show'
    end  
  end
  
  def checkout
    @stage = params[:stage] if params[:stage].present?
     
    @cart.build_billing_address if params[:new_billing].present?
    @cart.build_shipping_address if params[:new_shipping].present?
    
    #START THE GAUNTLET - MUST PASS THROUGH SERIES OF GATES TO WIN!
    # GATE 1 - HAS USER
    if user_signed_in?     
      current_user.carts << @cart if @cart.user.nil? #make association if it has not happened yet somehow
      
      #GATE 2 - BILLING INFORMATION
      if @cart.billing_address.nil?
        @stage = "billing"
        @cart.build_billing_address if @cart.user.addresses.empty?
      else       
        #GATE 3 - SHIPPING INFORMATION
        if @cart.shipping_address.nil? && !@cart.products.empty?
          @stage = "shipping" unless @stage == "billing"         
        else
          #GATE 4 - SHIPPING METHOD
          if !@cart.shipping_confirm? && !@cart.products.empty?
            @stage = "shipping_method" unless @stage == "billing" || @stage == "shipping"      
          else        
            #GATE - WAIVERS  
            if !@cart.courses.empty? && @cart.waiver.nil?
              @stage = "waiver" unless @stage == "billing"
              @cart.build_waiver :first_name => current_user.first_name, :middle_initial => current_user.middle_initial, :last_name => current_user.last_name, :address_1 => @cart.billing_address.address_1, 
                :address_2 => @cart.billing_address.address_2, :city => @cart.billing_address.city, :state => @cart.billing_address.state, :postal_code => @cart.billing_address.postal_code, 
                :home_phone => @cart.user.home_phone, :work_phone => @cart.user.work_phone, :work_phone_ext => @cart.user.work_phone_ext, :cell_phone => @cart.user.cell_phone, :birth_date => @cart.user.birthdate,
                :email_address => @cart.user.email, :occupation => @cart.user.occupation, :emergency_contact => !@cart.user.waivers.empty? ? @cart.user.waivers.last.emergency_contact : nil
            else  
              @stage = "review" unless @stage == "billing" || @stage == "shipping" || @stage == "shipping_method"
            end  
          end
          
        end
        
      end  
    else
      @stage = "user"
    end
    
    
    if @stage == "shipping_method"
      doc = UpsShipping.get_rates(@cart.shipping_address.postal_code, @cart.total_weight)
      # !!! CAPTURE API ERROR !!! #
      @ups_rates = doc.xpath("//RatingServiceSelectionResponse/RatedShipment") 
    end
   
  end
  
  def update_checkout
    if @cart.update_attributes(params[:cart])
      
      if params[:continue_to_payment].present?
        pairs = get_intuit_ticket(@cart)
        
        # CHECKOUT TERMINAL       
        redirect_to "#{Settings.intuit_payments.terminal_url}?Ticket=#{Rack::Utils.escape(pairs['Ticket'])}&OpId=#{Rack::Utils.escape(pairs['OpId'])}&action=checkout"      

      else  
        redirect_to checkout_cart_path(@cart)
      end  
    else
      @stage = params[:stage]
      render 'checkout'
    end
  end
  
  
private

  def get_intuit_ticket(cart)
    # GET TICKET
    
    response = Typhoeus.post(
      Settings.intuit_payments.ticket_url,
      params: { 
        AuthModel: "#{Settings.intuit_payments.auth_model}",
        AppLogin: "#{Settings.intuit_payments.app_login}",
        AuthTicket: "#{Settings.intuit_payments.auth_ticket}",
        TxnType: "#{Settings.intuit_payments.txn_type}",
        Amount: "#{cart.grand_total}",
        CustomerName: "#{cart.user.first_name} #{cart.user.last_name}",
        CustomerStreet: "#{cart.billing_address.address_1}",
        CustomerCity: "#{cart.billing_address.city}",
        CustomerState: "#{cart.billing_address.state}",
        CustomerPostalCode: "#{cart.billing_address.postal_code}",
        CustomerId: "#{cart.user.id}",
        InvoiceId: "#{cart.id}",
        IsCustomerFacing: 1,
        Order: order_array,
        SalesTaxAmount: "#{cart.sales_tax}",
        ShippingAmount: "#{cart.selected_shipping_array.split(',')[1]}",
        ReturnURL: "",
        ShippingCustomerEmail: "#{cart.user.email}",
        ShippingCustomerPhone: "#{cart.user.day_phone}",
        ShipToName: "#{cart.user.first_name} #{cart.user.last_name}",
        ShipToStreet: "#{cart.shipping_address.address_1}",
        ShipToCity: "#{cart.shipping_address.city}",
        ShipToState: "#{cart.shipping_address.state}",
        ShipToPostalCode: "#{cart.shipping_address.postal_code}"
        }
    )
    # PARSE RETURNED NAME-VALUE PAIRS
    require 'shellwords'
    shellwords = Shellwords.shellwords(response.body)
    pairs = shellwords.map{ |s| s.split('=', 2) }.flatten
    pairs = Hash[*pairs]
    return pairs
  end  
  
  def order_array
    skeleton = {
      "Items" => []
    }
    template = {
      "ItemSku" => "",
      "ItemDesc" => "",
      "ItemPrice" => "",
      "ItemQty" => "",
      "ItemIsShippable" => "",
      "ItemIsTaxable" => ""    
    }
    @cart.line_items.each do |line_item|
      temp_inst = template.clone
      temp_inst["ItemSku"] = line_item.line_itemable.sku
      temp_inst["ItemDesc"] = line_item.line_itemable.title
      temp_inst["ItemPrice"] = line_item.line_itemable.price
      temp_inst["ItemQty"] = line_item.qty
      temp_inst["ItemIsShippable"] = "1"
      temp_inst["ItemIsTaxable"] = @cart.billing_address.state == "TX" ? "1" : "0"
      skeleton["Items"] << temp_inst
    end
    return skeleton
  end
  
  def cart_sanity
    if @cart.nil? || (!@cart.nil? && @cart.line_items.empty?)
      flash[:info] = "There is nothing in your shopping cart!  Add items to continue."
      redirect_to request.referrer
    end
  end
  
end
