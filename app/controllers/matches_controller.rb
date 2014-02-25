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
      redirect_to matches_path
    else
      render 'edit'
    end
  end

  def p1_edit_score
    @match = Match.find(params[:id])
  end

  def p1_set_score
    @match = Match.find(params[:id])
    if @match.update_attributes(match_params)
      if @match.p1_score == 0 && @match.p2_score == 0
        @match.update_attribute(:p1_accepted, false)
        render 'p1_edit_score'
      else
        flash[:notice] = "Match score set."
        redirect_to matches_path
      end
    else
      render 'p1_edit_score'
    end
  end

  def p2_edit_score
    @match = Match.find(params[:id])
  end

  def p2_set_score
    @match = Match.find(params[:id])
    if @match.update_attributes(match_params)
      if @match.p1_score == 0 && @match.p2_score == 0
        @match.update_attribute(:p2_accepted, false)
        render 'p2_edit_score'
      else
        flash[:notice] = "Match score set."
        redirect_to matches_path
      end
    else
      render 'p2_edit_score'
    end
  end

  def confirm_score
    @match = Match.find(params[:id])
    if @match.update_attributes(match_params)
      
      # Match score accepted. 
      if @match.p1_accepted == true || @match.p2_accepted == true
        @match.pay_winning_betters
        flash[:notice] = "Match score accepted."
      # Match score declined.
      else
        flash[:error] = "Match score declined."
      end
    end
    redirect_to matches_path
  end

  def p1_edit_character
    @match = Match.find(params[:id])
    @characters = Game.find(@match.game_id).characters
  end

  def p1_set_character
    @match = Match.find(params[:id])
    if @match.update_attributes(match_params)
      if @match.p1_character != nil
        flash[:notice] = "P1 character set."
      end
      redirect_to matches_path
    end
  end

  def p2_edit_character
    @match = Match.find(params[:id])
    @characters = Game.find(@match.game_id).characters
  end

  def p2_set_character
    @match = Match.find(params[:id])
    if @match.update_attributes(match_params)
      if @match.p2_character != nil
        flash[:notice] = "P2 character set."
      end
      redirect_to matches_path
    end
  end

  def dispute
    @match = Match.find(params[:id])
    if @match.update_attributes(match_params)
      flash[:notice] = "Match dispute sent to commissioner."
      redirect_to matches_path
    end
  end

  def edit_dispute
    @match = Match.find(params[:id])
    @characters = Game.find(@match.game_id).characters
  end

  def resolve
    @match = Match.find(params[:id])
    if @match.update_attributes(match_params)
      flash[:notice] = "Dispute resolved."
      redirect_to matches_path
    end
  end

  private
    def match_params
      params.require(:match).permit(:p1_score, :p2_score, :match_date, 
        :p1_accepted, :p2_accepted, :p1_character, :p2_character, :disputed,
        :finalized_date)
    end
end
