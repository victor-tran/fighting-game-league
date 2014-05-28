class HomeController < ApplicationController
  def index
    if signed_in?
      user_ids = current_user.followed_user_ids.push(current_user.id)
      league_ids = current_user.followed_league_ids

      @posts = Post.where("postable_id in (?) AND postable_type = ?", user_ids, 'User') +
               Post.where("postable_id in (?) AND postable_type = ?", league_ids, 'League')
      @posts.sort! { |x,y| y.created_at <=> x.created_at }
    end
  end

  def pay_via_paypal
    approval_url = current_user.purchase_fight_bucks(5)
    redirect_to approval_url
  end

  def read_notifications
    respond_to do |format|
      format.js
    end
  end

  def search
    @results = PgSearch.multisearch(params[:query]).page(params[:page]).per_page(10)
  end

  def matchups
  end
end
