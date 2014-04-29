class HomeController < ApplicationController
  def index
    if signed_in?

      user_ids = current_user.followed_user_ids.push(current_user.id)
      league_ids = current_user.followed_league_ids
      bet_ids = current_user.bet_ids

      @posts = Post.where("postable_id in (?) AND postable_type = ?", user_ids, 'User') +
               Post.where("postable_id in (?) AND postable_type = ?", league_ids, 'League') +
               Post.where("postable_id in (?) AND postable_type = ?", bet_ids, 'Bet') +
               Post.where("postable_id in (?) AND postable_type = ?", bet_ids, 'Match')
      @posts.sort! { |x,y| y.created_at <=> x.created_at }
    end
  end

  def pay_via_paypal
    approval_url = current_user.purchase_fight_bucks(5)
    redirect_to approval_url
  end
end
