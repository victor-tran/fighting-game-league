class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.all( :limit => 10, :order => "id DESC" )
  end

  # For payments via credit card.
  def credit_card
    @order = current_user.orders.build
    @amount = params[:order][:amount]
    @description = params[:order][:description]
    @payment_method = params[:order][:payment_method]
  end

  def pay_with_credit_card
    @order = current_user.orders.build(credit_card_params)

    if @order.payment_method and @order.save
      @payment = Payment.new(
        {
          intent: "sale",
          payer: {
            payment_method: @order.payment_method,

            funding_instruments: [{
                credit_card: {
                  type:         @order.credit_card[:type],
                  number:       @order.credit_card[:number],
                  expire_month: @order.credit_card[:expire_month],
                  expire_year:  @order.credit_card[:expire_year],
                  first_name:   @order.credit_card[:first_name],  
                  last_name:    @order.credit_card[:last_name]
                }
            }]
          },
          transactions: [{
            amount: {
              total: @order.amount,
              currency: "USD" },
            description: @order.description
          }]
        }
      )
          
      if @payment.create
        @order.payment_id = @payment.id
        @order.state      = @payment.state
        @order.save
        if @order.state == 'approved'
          if @order.amount == '5'
            current_user.update_attribute(:fight_bucks, current_user.fight_bucks + 500)
          elsif @order.amount == '10'
            current_user.update_attribute(:fight_bucks, current_user.fight_bucks + 2000)
          elsif @order.amount == '20'
            current_user.update_attribute(:fight_bucks, current_user.fight_bucks + 10000)
          end
          redirect_to root_url, :notice => "Order was placed successfully"
        else
          redirect_to root_url, :alert => "Order was not approved."
        end
      else
        errors.add :payment_method, @payment.error["message"] if @payment.error
        raise ActiveRecord::Rollback, "Can't place the order"
      end

    else
      redirect_to fight_bucks_path, alert: @order.errors.to_a.join(", ")
    end
  end

  # For payments via PayPal.
  def create
    @order = current_user.orders.build(paypal_params)
    @order.return_url = order_execute_url(":order_id")
    @order.cancel_url = order_cancel_url(":order_id")

    if @order.payment_method and @order.save
      if @order.approve_url
        redirect_to @order.approve_url
      end
    else
      redirect_to fight_bucks_path, alert: @order.errors.to_a.join(", ")
    end
  end

  def execute
    @order = current_user.orders.find(params[:order_id])

    binding.pry

    if @order.execute(params["PayerID"])
      if @order.state == 'approved'
        if @order.amount == '5'
          current_user.update_attribute(:fight_bucks, current_user.fight_bucks + 500)
        elsif @order.amount == '10'
          current_user.update_attribute(:fight_bucks, current_user.fight_bucks + 2000)
        elsif @order.amount == '20'
          current_user.update_attribute(:fight_bucks, current_user.fight_bucks + 10000)
        end
        redirect_to root_url, :notice => "Order was placed successfully"
      else
        redirect_to root_url, :alert => "Order was not approved."
      end
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
    def credit_card_params
      params.require(:order).permit(:amount, :description, :payment_method,
                                    credit_card: [ :first_name,
                                                   :last_name,
                                                   :type,
                                                   :number,
                                                   :cvv2,
                                                   :expire_month,
                                                   :expire_year ])
    end

    def paypal_params
      params.require(:order).permit(:amount, :description, :payment_method)
    end
end
