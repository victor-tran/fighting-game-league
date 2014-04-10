class OrdersController < ApplicationController
  #before_filter :authenticate_user!
  def index
    @orders = current_user.orders.all( :limit => 10, :order => "id DESC" )
  end

  def create
    @order = current_user.orders.build
    @order.attributes = orders_params
    @order.return_url = order_execute_url(":order_id")
    @order.cancel_url = order_cancel_url(":order_id")
    if @order.payment_method and @order.save
      if @order.approve_url
        redirect_to @order.approve_url
      else
        redirect_to orders_path, :notice => "Order was placed successfully"
      end
    else
      render :create, :alert  => @order.errors.to_a.join(", ")
    end
  end

  def execute
    @order = current_user.orders.find(params[:order_id])
    if @order.execute(params["PayerID"])
      if @order.amount == '5'
        current_user.update_attribute(:fight_bucks, current_user.fight_bucks + 500)
      elsif @order.amount == '10'
        current_user.update_attribute(:fight_bucks, current_user.fight_bucks + 2000)
      elsif @order.amount == '20'
        current_user.update_attribute(:fight_bucks, current_user.fight_bucks + 10000)
      end
      redirect_to root_url, :notice => "Order was placed successfully"
    else
      redirect_to root_url, :alert => @order.payment.error.inspect
    end
  end

  def cancel
    @order = current_user.orders.find(params[:order_id])
    unless @order.state == "approved"
      @order.state = "cancelled"
      @order.save
    end
    redirect_to root_url, :alert => "Order was cancelled"
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  
  private
    def orders_params
      params.require(:order).permit(:user_id, :payment_method, :amount, :description, :credit_card)
    end
end
