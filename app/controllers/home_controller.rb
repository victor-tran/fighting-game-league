class HomeController < ApplicationController
  def index
    if signed_in?
      @post  = current_user.posts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def pay_via_paypal
    approval_url = current_user.purchase_fight_bucks(5)
    redirect_to approval_url
  end
end
