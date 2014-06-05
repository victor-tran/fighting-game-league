class LeaguesController < ApplicationController

  before_action :signed_in_user, only: [:new, :edit, :update]
  before_action :is_commissioner, only: [:edit, :update]

  before_action :get_league,    only: [:edit, :update, :show, :start, :next_round,
                                       :end_season, :statistics, :join_password,
                                       :profile, :standings, :fighters,
                                       :start_playoffs, :end_playoffs,
                                       :edit_fighter_list, :set_fighter_list]

  before_action :respond_to_js, only: [:profile, :standings,
                                       :fighters]


  def get_league
    @league = League.find(params[:id])
  end

  def respond_to_js
    respond_to do |format|
      format.js
    end
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(create_league_params)
    @league.password_confirmation = params[:league][:password_confirmation]
    if @league.save
      # Commissioner will join their own league.
      current_user.memberships.build(league_id: @league.id)
      current_user.join!(@league)
      flash[:notice] = "League created!"
      redirect_to @league
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end
  
  def update
    if @league.update_attributes(update_league_params)
      flash[:notice] = "League successfully updated."
      redirect_to @league   
    else
      render 'edit'
    end
  end

  def start
    if @league.update_attributes(start_league_params)
      # Generate the list of the fighters for this season.
      fighters = Array.new
      @league.users.each do |user|
        fighters.push(user.id)
      end

      # Create a new season for this league.
      if @league.seasons.empty?
        @league.seasons.create!(number: 1,
                                current_season: true,
                                fighters: fighters)
      else
        @league.seasons.create!(number: @league.seasons.last.number + 1,
                                current_season: true,
                                fighters: fighters)
      end

      # Generate matches for the season.
      @league.generate_matches

      # Send a push notification to each follower letting them know that the
      # season has begun.
      @league.followers.each do |follower|
        unless follower == @league.commissioner
          
          # Create a notification on the backend.
          n = follower.notifications.create!(sendable_id: @league.id,
                                             sendable_type: 'League',
                                             targetable_id: @league.id,
                                             targetable_type: 'League',
                                             content: Notification.season_started(@league),
                                             read: false)
          # Send a push notification via Pusher API to follower.
          if @league.banner_file_name == nil
            Pusher['private-user-'+follower.id.to_s].trigger('league_notification',
                                                             { league_id: @league.id,
                                                               unread_count: follower.notifications.unread.count,
                                                               notification_content: Notification.season_started(@league),
                                                               no_banner: true,
                                                               notification_id: n.id })
          else
            Pusher['private-user-'+follower.id.to_s].trigger('league_notification',
                                                             { league_id: @league.id,
                                                               unread_count: follower.notifications.unread.count,
                                                               notification_content: Notification.season_started(@league),
                                                               no_banner: false,
                                                               img_alt: @league.banner_file_name.gsub(/.(jpg|jpeg|gif|png)/,""),
                                                               img_src: @league.banner.url(:post),
                                                               notification_id: n.id })
          end
        end
      end

      # Create a post for followers of the league to see that the
      # season started.
      @league.posts.create!(action: 'started',
                            content: Notification.season_started(@league))
      flash[:notice] = "League successfully started!"
    end
    redirect_to @league
  end

  def next_round
    @league.update_attribute(:current_round, @league.current_round + 1)

    # Send a push notification to each follower letting them know that the
    # next round of the season has begun.
    @league.followers.each do |follower|
      unless follower == @league.commissioner
        
        # Create a notification on the backend.
        n = follower.notifications.create!(sendable_id: @league.id,
                                           sendable_type: 'League',
                                           targetable_id: @league.id,
                                           targetable_type: 'League',
                                           content: Notification.new_round_started(@league),
                                           read: false)
        # Send a push notification via Pusher API to follower.
        if @league.banner_file_name == nil
          Pusher['private-user-'+follower.id.to_s].trigger('league_notification',
                                                           { league_id: @league.id,
                                                             unread_count: follower.notifications.unread.count,
                                                             notification_content: Notification.new_round_started(@league),
                                                             no_banner: true,
                                                             notification_id: n.id })
        else
          Pusher['private-user-'+follower.id.to_s].trigger('league_notification',
                                                           { league_id: @league.id,
                                                             unread_count: follower.notifications.unread.count,
                                                             notification_content: Notification.new_round_started(@league),
                                                             no_banner: false,
                                                             img_alt: @league.banner_file_name.gsub(/.(jpg|jpeg|gif|png)/,""),
                                                             img_src: @league.banner.url(:post),
                                                             notification_id: n.id })
        end
      end
    end

    @league.posts.create!(action: 'next_round',
                          content: Notification.new_round_started(@league))
    flash[:notice] = "Round #{@league.current_round} started."
    redirect_to @league
  end

  def start_playoffs
    @league.update_attribute(:playoffs_started, true)
    @league.start_playoffs
    # Send a push notification to each follower letting them know that the
    # next round of the season has begun.
    @league.followers.each do |follower|
      unless follower == @league.commissioner
        
        # Create a notification on the backend.
        n = follower.notifications.create!(sendable_id: @league.id,
                                           sendable_type: 'League',
                                           targetable_id: @league.id,
                                           targetable_type: 'League',
                                           content: Notification.playoffs_started(@league),
                                           read: false)
        # Send a push notification via Pusher API to follower.
        if @league.banner_file_name == nil
          Pusher['private-user-'+follower.id.to_s].trigger('league_notification',
                                                           { league_id: @league.id,
                                                             unread_count: follower.notifications.unread.count,
                                                             notification_content: Notification.playoffs_started(@league),
                                                             no_banner: true,
                                                             notification_id: n.id })
        else
          Pusher['private-user-'+follower.id.to_s].trigger('league_notification',
                                                           { league_id: @league.id,
                                                             unread_count: follower.notifications.unread.count,
                                                             notification_content: Notification.playoffs_started(@league),
                                                             no_banner: false,
                                                             img_alt: @league.banner_file_name.gsub(/.(jpg|jpeg|gif|png)/,""),
                                                             img_src: @league.banner.url(:post),
                                                             notification_id: n.id })
        end
      end
    end
    @league.posts.create!(action: 'playoffs_started',
                          content: Notification.playoffs_started(@league))
    flash[:notice] = "Playoffs started!"
    redirect_to @league
  end

  def end_playoffs
    @league.end_playoffs
    # Send a push notification to each follower letting them know that the
    # next round of the season has begun.
    @league.followers.each do |follower|
      unless follower == @league.commissioner
        
        # Create a notification on the backend.
        n = follower.notifications.create!(sendable_id: @league.id,
                                           sendable_type: 'League',
                                           targetable_id: @league.id,
                                           targetable_type: 'League',
                                           content: Notification.playoffs_ended(@league),
                                           read: false)
        # Send a push notification via Pusher API to follower.
        if @league.banner_file_name == nil
          Pusher['private-user-'+follower.id.to_s].trigger('league_notification',
                                                           { league_id: @league.id,
                                                             unread_count: follower.notifications.unread.count,
                                                             notification_content: Notification.playoffs_ended(@league),
                                                             no_banner: true,
                                                             notification_id: n.id })
        else
          Pusher['private-user-'+follower.id.to_s].trigger('league_notification',
                                                           { league_id: @league.id,
                                                             unread_count: follower.notifications.unread.count,
                                                             notification_content: Notification.playoffs_ended(@league),
                                                             no_banner: false,
                                                             img_alt: @league.banner_file_name.gsub(/.(jpg|jpeg|gif|png)/,""),
                                                             img_src: @league.banner.url(:post),
                                                             notification_id: n.id })
        end
      end
    end
    @league.posts.create!(action: 'playoffs_ended',
                          content: Notification.playoffs_ended(@league))
    flash[:notice] = "Playoffs complete!"
    redirect_to @league
  end

  def end_season
    if @league.update_attributes(end_season_params)
      flash[:notice] = "Season #{@league.current_season.number} complete!"

      # Make current season, not the current season anymore.
      @league.current_season.update_attribute(:current_season, false)
    end
    redirect_to @league
  end

  def join_password
  end

  def profile
  end

  def standings
  end

  def statistics
    if params[:season] == nil
      @selected_season = @league.current_season
    else
      @selected_season = params[:season]
    end
    respond_to do |format|
      format.js
    end
  end

  def fighters
  end

  def followers
    @title = "Followers"
    @league = League.find(params[:id])
    @followers = @league.followers.paginate(page: params[:page])
  end

  def edit_fighter_list
  end

  def set_fighter_list
    Membership.where("league_id = ? AND user_id IN (?)", @league.id ,params[:user_ids]).destroy_all
    redirect_to edit_fighter_list_league_path(@league)
  end

  private
    def create_league_params
      params.require(:league).permit(:name, :game_id, :commissioner_id,
                                     :started, :current_round, :match_count,
                                     :info, :password_protected, :password,
                                     :password_confirmation, :playoffs_started,
                                     :time_zone)
    end

    def update_league_params
      params.require(:league).permit(:name, :match_count, :info, :banner,
                                     :time_zone)
    end

    def start_league_params
      params.require(:league).permit(:started, :current_round)
    end

    def end_season_params
      params.require(:league).permit(:started, :current_round,
                                     :playoffs_started)
    end

    def 

    # Authorization methods
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def is_commissioner
      @league = League.find(params[:id])
      redirect_to(root_url) unless current_user?(User.find(@league.commissioner_id))
    end
end
