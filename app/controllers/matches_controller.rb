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
      flash[:notice] = "Match settings updated."
      redirect_to @match
    else
      render 'edit'
    end
  end

  def set_score
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
