class BetsController < ApplicationController
  before_action :signed_in_user
  
  def create
    @match = Match.find(params[:bet][:match_id])
    @user = User.find(params[:bet][:favorite_id])
    current_user.bet!(@match, @user)
    redirect_to match_path(@match)
  end

end
