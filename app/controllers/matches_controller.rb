class MatchesController < ApplicationController
  before_action :get_match, only: [:edit_date, :set_date, :show, :p1_edit_score,
                                   :p1_set_score, :p2_edit_score, :p2_set_score,
                                   :accept_score, :decline_score,
                                   :p1_edit_character, :p1_set_character,
                                   :p2_edit_character, :p2_set_character,
                                   :dispute, :edit_dispute, :resolve]

  def get_match
    @match = Match.find(params[:id])
  end

  def index
  end

  def show
    @league = @match.league
  end

  def edit_date
	end

	def set_date
    if @match.update_attributes(set_date_params)
      flash[:notice] = "Match date/time updated."
      redirect_to matches_path
    else
      render 'edit_date'
    end
  end

  def p1_edit_score
  end

  def p1_set_score
    if @match.update_attributes(p1_set_score_params)
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
    if @match.update_attributes(p2_set_score_params)
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

  def accept_score
    if @match.update_attributes(p1_accepted: true, p2_accepted: true,
                                finalized_date: Time.now)
        @match.pay_winning_betters
        flash[:notice] = "Match score accepted."
    end
    redirect_to matches_path
  end

  def decline_score
    if @match.update_attributes(p1_accepted: false, p2_accepted: false,
                                p1_score: 0, p2_score: 0)
    flash[:error] = "Match score declined."
    end
    redirect_to matches_path
  end

  def p1_edit_character
    @characters = @match.game.characters
  end

  def p1_set_character
    if @match.update_attributes(p1_set_character_params)
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
    if @match.update_attributes(p2_set_character_params)
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
    if @match.update_attributes(resolve_params)
      flash[:notice] = "Dispute resolved."
      redirect_to matches_path
    end
  end

  private
    def set_date_params
      params.require(:match).permit(:match_date)
    end

    def resolve_params
      params.require(:match).permit(:p1_score, :p2_score, :match_date, 
        :p1_accepted, :p2_accepted, :disputed, :finalized_date, 
        :p1_characters => [], :p2_characters => [])
    end

    def p1_set_score_params
      params.require(:match).permit(:p1_score, :p2_score, :p1_accepted)
    end

    def p2_set_score_params
      params.require(:match).permit(:p1_score, :p2_score, :p2_accepted)
    end

    def p1_set_character_params
      params.require(:match).permit(:p1_characters => [])
    end

    def p2_set_character_params
      params.require(:match).permit(:p2_characters => [])
    end
end
