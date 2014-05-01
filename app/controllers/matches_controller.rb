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

  # Action for setting scores for a tournament match.
  def create
    @match = Match.new(create_match_params)
    @tournament = Tournament.find(params[:match][:tournament_id])
    if @match.save
      # Send scores to Challonge via Challonge API
      url = @tournament.full_challonge_url.sub(/^https?\:\/\//, '').sub(/^challonge.com/,'').sub(/^\//, '')
      t = Challonge::Tournament.find(url)

      # Find the match via challonge_match_id
      t.matches.each do |match|
        if match.id == params[:match][:challonge_match_id].to_i

          # Send scores to Challonge via Challonge API
          match.scores_csv = @match.p1_score.to_s + '-' + @match.p2_score.to_s
          if @match.winner_id == @match.p1_id
            match.winner_id = match.player1_id
          else
            match.winner_id = match.player2_id
          end

          match.save
        end
      end
      redirect_to league_path(@match.league)
    else
      render :template => "tournaments/edit_match_scores"
    end
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
      @match.league.posts.create!(action: "date_set", match_id: @match.id)
      flash[:notice] = "Match date/time updated."
      redirect_to matches_path
    else
      render 'edit_date'
    end
  end

  def p1_edit_score
  end

  def p1_set_score
    if params[:match][:p1_score] == "0" && params[:match][:p2_score] == "0"
      render 'p1_edit_score'
    elsif @match.update_attributes(p1_set_score_params)
      flash[:notice] = "Match score set."
      redirect_to matches_path
    else
      render 'p1_edit_score'
    end
  end

  def p2_edit_score
  end

  def p2_set_score
    if params[:match][:p1_score] == "0" && params[:match][:p2_score] == "0"
      render 'p2_edit_score'
    elsif @match.update_attributes(p2_set_score_params)
      flash[:notice] = "Match score set."
      redirect_to matches_path
    else
      render 'p2_edit_score'
    end
  end

  def accept_score
    if @match.update_attributes(p1_accepted: true, p2_accepted: true,
                                finalized_date: Time.now)
      @match.league.posts.create!(action: "score_set", match_id: @match.id)
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
    unless params[:match][:p1_characters].reject! { |c| c.empty? }.empty?
      if @match.update_attributes(p1_set_character_params)
        flash[:notice] = "P1 character set."
      end
    end

    redirect_to matches_path
  end

  def p2_edit_character
    @characters = @match.game.characters
  end

  def p2_set_character
    unless params[:match][:p2_characters].reject! { |c| c.empty? }.empty?
      if @match.update_attributes(p2_set_character_params)
        flash[:notice] = "P2 character set."
      end
    end

    redirect_to matches_path
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
      @match.league.posts.create!(action: "score_set", match_id: @match.id)
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

    def create_match_params
      params.require(:match).permit(:p1_id, :p2_id, :p1_score, :p2_score, 
        :match_date, :p1_accepted, :p2_accepted, :disputed, :finalized_date,
        :round_number, :game_id, :season_number, :league_id, :tournament_id)
    end
end
