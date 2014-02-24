class BetsController < ApplicationController
  before_action :signed_in_user
  
  def create
    @match = Match.find(params[:bet][:match_id])
    @user = User.find(params[:bet][:favorite_id])
    wager_amount = params[:bet][:wager_amount].to_i
    if wager_amount > current_user.fight_bucks
      flash[:warning] = "Not enough fight bucks"
    else
      current_user.bet!(@match, @user, wager_amount)
    end
    redirect_to match_path(@match)
  end
end
