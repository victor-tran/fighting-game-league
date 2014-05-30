class MembershipsController < ApplicationController
	before_action :signed_in_user
  
  def create
    @league = League.find(params[:membership][:league_id])

    unless @league.started == true
      if @league.password_protected 
        if @league.authenticate(params[:membership][:password])
          current_user.join!(@league)
          flash[:notice] = "Joined " + @league.name
          redirect_to @league
        else
          flash[:warning] = "Invalid password"
          redirect_to join_password_league_path(@league)
        end
      else
        current_user.join!(@league)
        respond_to do |format|
          format.html { redirect_to @league }
          format.js
        end
      end
    end
  end

  def destroy
    @league = Membership.find(params[:id]).league
    unless @league.started == true
      current_user.leave!(@league)
      respond_to do |format|
        format.html { redirect_to @league }
        format.js
      end
    end
  end
end
