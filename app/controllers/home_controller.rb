class HomeController < ApplicationController
  def index
  end

  def pay_via_paypal
    approval_url = current_user.purchase_fight_bucks(5)
    redirect_to approval_url
  end
end
