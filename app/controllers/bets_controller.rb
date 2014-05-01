class BetsController < ApplicationController
  before_action :signed_in_user
  
  def create
    @match = Match.find(params[:bet][:match_id])
    @fav_user = User.find(params[:bet][:favorite_id])
    wager_amount = params[:bet][:wager_amount].to_i
    if wager_amount > current_user.fight_bucks
      flash[:warning] = "Not enough fight bucks"
    else
      # Create the bet.
      bet = current_user.bet!(@match, @fav_user, wager_amount)

      # Create a betting post to display on user feeds.
      if @fav_user == @match.p1
        current_user.posts.create!(action: 'bet_on_p1', bet_id: bet.id)
      else
        current_user.posts.create!(action: 'bet_on_p2', bet_id: bet.id)
      end
    end
    redirect_to match_path(@match)
  end
end
