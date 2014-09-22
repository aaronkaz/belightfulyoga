class WaiversController < ApplicationController
  
  layout 'min'
  before_filter { @cart = Cart.find(params[:cart_id])}
  
  def show
    @waiver = @cart.waivers.find(params[:id])
  end
  
end
