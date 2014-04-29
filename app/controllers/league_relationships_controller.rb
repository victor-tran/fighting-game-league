class LeagueRelationshipsController < ApplicationController
  before_action :signed_in_user

  def create
    @league = League.find(params[:league_relationship][:league_id])
    current_user.follow_league!(@league)
    respond_to do |format|
      format.html { redirect_to @league }
      format.js
    end
  end

  def destroy
    @league = LeagueRelationship.find(params[:id]).league
    current_user.unfollow_league!(@league)
    respond_to do |format|
      format.html { redirect_to @league }
      format.js
    end
  end
end
