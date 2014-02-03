class MembershipsController < ApplicationController
	before_action :signed_in_user
  
  def create
    @league = League.find(params[:membership][:league_id])
    current_user.join!(@league)
    respond_to do |format|
      format.html { redirect_to leagues_path }
      format.js
    end
  end

  def destroy
    @league = Membership.find(params[:id]).league
    current_user.leave!(@league)
    respond_to do |format|
      format.html { redirect_to leagues_path }
      format.js
    end
  end
end
