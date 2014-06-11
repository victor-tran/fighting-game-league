class MatchesController < ApplicationController
  before_action :get_match, only: [:edit_date, :set_date, :show, :p1_edit_score,
                                   :p1_set_score, :p2_edit_score, :p2_set_score,
                                   :accept_score, :decline_score,
                                   :p1_edit_character, :p1_set_character,
                                   :p2_edit_character, :p2_set_character,
                                   :dispute, :edit_dispute, :resolve,
                                   :add_video, :delete_video, :p1_betters,
                                   :p2_betters]

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
    # Set the timezone to the league's time zone so that the rails application
    # will not display UTC converted time.
    Time.zone = @match.league.time_zone
	end

	def set_date
    # Set the timezone to the league's time zone so that the rails application
    # won't save match_date in UTC, but rather in the league's time zone.
    Time.zone = @match.league.time_zone
    real_date = Time.zone.local(params[:match]["match_date(1i)"].to_i,
                                params[:match]["match_date(2i)"].to_i,
                                params[:match]["match_date(3i)"].to_i,
                                params[:match]["match_date(4i)"].to_i,
                                params[:match]["match_date(5i)"].to_i)
    if @match.update_attribute(:match_date, real_date)

      if current_user == @match.p1
        subject = @match.p2
      else
        subject = @match.p1
      end

      # Create a notification on the backend.
      n = subject.notifications.create!(sendable_id: current_user.id,
                                        sendable_type: 'User',
                                        targetable_id: @match.id,
                                        targetable_type: 'Match',
                                        content: Notification.date_set(@match),
                                        read: false)
      # Send a push notification via Pusher API to follower.
      if subject.avatar_file_name == nil
        Pusher['private-user-'+subject.id.to_s].trigger('pending_match_notification',
                                                         { unread_count: subject.notifications.unread.count,
                                                           notification_content: Notification.date_set(@match),
                                                           no_banner: true,
                                                           notification_id: n.id })
      else
        Pusher['private-user-'+subject.id.to_s].trigger('pending_match_notification',
                                                         { unread_count: subject.notifications.unread.count,
                                                           notification_content: Notification.date_set(@match),
                                                           no_banner: false,
                                                           img_alt: subject.avatar_file_name.gsub(/.(jpg|jpeg|gif|png)/,""),
                                                           img_src: subject.avatar.url(:post),
                                                           notification_id: n.id })
      end

      @match.league.posts.create!(action: "date_set",
                                  subjectable_id: @match.id,
                                  subjectable_type: 'Match',
                                  content: Notification.date_set(@match))
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
      if @match.winner_id == @match.p1_id
        @match.league.posts.create!(action: "score_set",
                                    subjectable_id: @match.id,
                                    subjectable_type: 'Match',
                                    content: "#{@match.p1.alias} defeated #{@match.p2.alias} #{@match.p1_score}-#{@match.p2_score}.")
      else
        @match.league.posts.create!(action: "score_set",
                                    subjectable_id: @match.id,
                                    subjectable_type: 'Match',
                                    content: "#{@match.p2.alias} defeated #{@match.p1.alias} #{@match.p1_score}-#{@match.p2_score}.")
      end
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
      @match.league.posts.create!(action: "score_set",
                                  subjectable_id: @match.id,
                                  subjectable_type: 'Match')
      flash[:notice] = "Dispute resolved."
      redirect_to matches_path
    end
  end

  def add_video
    # For some reason can't use @match.update_attribute...
    Match.find(params[:id]).update_attribute(:videos, @match.videos.push(params[:video_url]))
    flash[:notice] = "Match footage added."
    redirect_to @match
  end

  def delete_video
    @match.videos.delete(params[:video_url])
    # For some reason can't use @match.update_attribute...
    Match.find(params[:id]).update_attribute(:videos, @match.videos)
    flash[:notice] = "Match footage deleted."
    redirect_to @match
  end

  def p1_betters
    respond_to do |format|
      format.html
      format.js
    end
  end

  def p2_betters
    respond_to do |format|
      format.html
      format.js
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
        :round_number, :game_id, :season_id, :league_id, :tournament_id)
    end
end
