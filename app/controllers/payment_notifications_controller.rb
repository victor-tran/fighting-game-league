class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    PaymentNotification.create!(params:         params,
                                user_id:        params[:custom],
                                status:         params[:payment_status],
                                transaction_id: params[:txn_id],
                                amount:         params[:item_number])
    render nothing: true
  end
end
