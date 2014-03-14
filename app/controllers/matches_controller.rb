class MatchesController < ApplicationController
  before_action :get_match, only: [:edit, :update, :show, :p1_edit_score,
                                   :p1_set_score, :p2_edit_score, :p2_set_score,
                                   :confirm_score, :p1_edit_character,
                                   :p1_set_character, :p2_edit_character,
                                   :p2_set_character, :dispute, :edit_dispute,
                                   :resolve]

  def get_match
    @match = Match.find(params[:id])
  end

  def index
  end

  def show
    @league = @match.league
  end

  def edit
	end

	def update
    if @match.update_attributes(match_params)
      flash[:notice] = "Match date/time updated."
      redirect_to matches_path
    else
      render 'edit'
    end
  end

  def p1_edit_score
  end

  def p1_set_score
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
  end

  def p2_set_score
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
    @characters = @match.game.characters
  end

  def p1_set_character
    if @match.update_attributes(match_params)
      unless @match.p1_characters.empty?
        flash[:notice] = "P1 character set."
      end
      redirect_to matches_path
    end
  end

  def p2_edit_character
    @characters = @match.game.characters
  end

  def p2_set_character
    if @match.update_attributes(match_params)
      unless @match.p2_characters.empty?
        flash[:notice] = "P2 character set."
      end
      redirect_to matches_path
    end
  end

  def dispute
    @match.update_attribute(:disputed, true)
    flash[:notice] = "Match dispute sent to commissioner."
    redirect_to matches_path
  end

  def edit_dispute
    @characters = @match.game.characters
  end

  def resolve
    if @match.update_attributes(edit_dispute_params)
      flash[:notice] = "Dispute resolved."
      redirect_to matches_path
    end
  end

  private
    def edit_dispute_params
      params.require(:match).permit(:p1_score, :p2_score, :match_date, 
        :p1_accepted, :p2_accepted, :disputed, :finalized_date, 
        :p1_characters => [], :p2_characters => [])
    end
    
    def match_params
      params.require(:match).permit(:p1_score, :p2_score, :match_date, 
        :p1_accepted, :p2_accepted, :disputed, :finalized_date, 
        :p1_characters => [], :p2_characters => [])
    end
end
