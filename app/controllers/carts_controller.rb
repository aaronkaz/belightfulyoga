class CartsController < ApplicationController
  
  layout :resolve_layout
  
  before_filter { @cart = current_cart }
  before_filter { initialize_page('shopping-cart') }
  before_filter :cart_sanity, :except => [:create, :update, :receipt]
  
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
    @checkout_steps = checkout_steps
    @stage = params[:stage] if params[:stage].present?
     
    @cart.build_billing_address if params[:new_billing].present?
    @cart.build_shipping_address if params[:new_shipping].present?
    
    #START THE GAUNTLET - MUST PASS THROUGH SERIES OF GATES TO WIN!
    # GATE 1 - HAS USER
    if user_signed_in?     
      current_user.carts << @cart if @cart.user.nil? #make association if it has not happened yet somehow
      
      #GATE 2 - BILLING INFORMATION
      if @cart.billable? && @cart.billing_address.nil?
        @stage = "billing"
        @cart.build_billing_address if @cart.user.addresses.empty?
      else       
        #GATE 3 - SHIPPING INFORMATION
        if @cart.shippable? && @cart.shipping_address.nil?
          @stage = "shipping" unless @stage == "billing"         
        else
          #GATE 4 - SHIPPING METHOD
          if @cart.shippable? && !@cart.shipping_confirm?
            @stage = "shipping_method" unless @stage == "billing" || @stage == "shipping"      
          else       
             
            #GATE - WAIVERS  
            if @cart.require_waiver? && @cart.waiver.nil?
              @stage = "waiver" unless @stage == "billing" || @stage == "shipping" || @stage == "shipping_method" || @stage == "review"
              last_waiver = current_user.waivers.last
              
              if @cart.billing_address.present?
                @cart.build_waiver :first_name => current_user.first_name, :middle_initial => current_user.middle_initial, :last_name => current_user.last_name, :address_1 => @cart.billing_address.address_1, 
                  :address_2 => @cart.billing_address.address_2, :city => @cart.billing_address.city, :state => @cart.billing_address.state, :postal_code => @cart.billing_address.postal_code, 
                  :home_phone => @cart.user.home_phone, :work_phone => @cart.user.work_phone, :work_phone_ext => @cart.user.work_phone_ext, :cell_phone => @cart.user.cell_phone, :birth_date => @cart.user.birthdate,
                  :email_address => @cart.user.email, :occupation => @cart.user.occupation, :emergency_contact => !@cart.user.waivers.empty? ? @cart.user.waivers.last.emergency_contact : nil
              elsif !last_waiver.nil?
                @cart.build_waiver :first_name => current_user.first_name, :middle_initial => current_user.middle_initial, :last_name => current_user.last_name, :address_1 => last_waiver.address_1, 
                  :address_2 => last_waiver.address_2, :city => last_waiver.city, :state => last_waiver.state, :postal_code => last_waiver.postal_code, 
                  :home_phone => last_waiver.home_phone, :work_phone => last_waiver.work_phone, :work_phone_ext => last_waiver.work_phone_ext, :cell_phone => last_waiver.cell_phone, :birth_date => last_waiver.birth_date,
                  :email_address => @cart.user.email, :occupation => last_waiver.occupation, :emergency_contact => last_waiver.emergency_contact
                
              else
                @cart.build_waiver :first_name => current_user.first_name, :middle_initial => current_user.middle_initial, :last_name => current_user.last_name, :home_phone => @cart.user.home_phone, :work_phone => @cart.user.work_phone, :work_phone_ext => @cart.user.work_phone_ext, :cell_phone => @cart.user.cell_phone, :birth_date => @cart.user.birthdate,
                  :email_address => @cart.user.email, :occupation => @cart.user.occupation, :emergency_contact => nil
              end
            else               
              @stage = "review" unless @stage == "billing" || @stage == "shipping" || @stage == "shipping_method" || @stage == "waiver"
              # IF CART IS NON-BILLABLE
              if !@cart.billable?
                @cart.update_attribute(:status, "Fulfilled")
                UserMailer.order_confirmation(@cart.id).deliver
                flash[:success] == "Your order is complete!"
                redirect_to receipt_cart_path(@cart)
              end
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
      #@ups_rates = doc.xpath("//RatingServiceSelectionResponse/RatedShipment") 
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
      @checkout_steps = checkout_steps
      @stage = params[:stage]
      render 'checkout'
    end
  end
  
  def receipt
    
    #CAPTURE RETURN FROM PAYPAL
    if request.method == "POST"
      @cart = Cart.find(params[:id])
      @cart.update_attributes(:status => params[:payment_status])
      #SEND EMAIL
      redirect_to receipt_cart_path(@cart)
      #render :text => params[:payment_status]
    else  
      @cart = current_user.carts.find(params[:id])
    end  
  end
  
  
  def pp_callback
    #CALLBACK TO PAYPAL??
    @cart = Cart.find(params[:id])
    @cart.update_attributes(:status => params[:payment_status])
    render :head => :ok, :nothing => true
  end
  
  
private

  def checkout_steps
    checkout_steps = Array.new
    checkout_steps << "billing_address" if @cart.billable?
    checkout_steps << "shipping_address" if @cart.shippable?
    checkout_steps << "shipping_method" if @cart.shippable?
    checkout_steps << "waiver" if @cart.require_waiver?
    checkout_steps << "review" if @cart.billable?
    return checkout_steps
  end
  
  def cart_sanity
    if @cart.nil?
      flash[:info] = "There is nothing in your shopping cart!  Add items to continue."
      redirect_to request.referrer
    end
  end
  
  def resolve_layout
    case action_name
    when "receipt"
      "user"
    else
      "application"
    end
  end
  
end
