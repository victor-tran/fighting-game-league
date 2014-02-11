class MatchesController < ApplicationController

  def index
  end

  def show
    @match = Match.find(params[:id])
    @league = League.find(@match.league_id)
  end

  def edit
		@match = Match.find(params[:id])
	end

	def update
    @match = Match.find(params[:id])

    if @match.update_attributes(match_params)
      flash[:notice] = "Match date/time updated."
      redirect_to @match
    else
      render 'edit'
    end
  end

  def edit_score
    @match = Match.find(params[:id])
  end

  def set_score
    @match = Match.find(params[:id])
    if @match.update_attributes(match_params)
      unless @match.p1_score == 0 && @match.p2_score == 0
        flash[:notice] = "Match score set."
      end
      redirect_to @match
    else
      render 'edit_score'
    end
  end

  def confirm_score
    @match = Match.find(params[:id])
    if @match.update_attributes(match_params)
      
      # Match score accepted. 
      if @match.p1_accepted == true || @match.p2_accepted == true
        flash[:notice] = "Match score accepted."
      # Match score declined.
      else
        flash[:error] = "Match score declined."
      end
    end
    redirect_to matches_path
  end

  private
    def match_params
      params.require(:match).permit(:p1_score, :p2_score, :match_date, :p1_accepted, :p2_accepted)
    end
end
