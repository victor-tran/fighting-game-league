class LeaguesController < ApplicationController

  before_action :signed_in_user, only: [:new, :edit, :update]
  before_action :is_commissioner, only: [:edit, :update]

  before_action :get_league,    only: [:edit, :update, :show, :start, :next_round,
                                       :end_season, :statistics, :join_password,
                                       :profile, :standings, :fighters]

  before_action :respond_to_js, only: [:profile, :standings, :statistics,
                                       :fighters]


  def get_league
    @league = League.find(params[:id])
  end

  def respond_to_js
    respond_to do |format|
      format.js
    end
  end
  
  def index
    @leagues = League.text_search(params[:query]).page(params[:page]).per_page(20)
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(create_league_params)
    if @league.save
      # User will join their own league.
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
      @league.generate_matches
      flash[:notice] = "League successfully started!"
    end
    redirect_to @league
  end

  def next_round
    @league.update_attribute(:current_round, @league.current_round + 1)
    flash[:notice] = "Round " + @league.current_round.to_s + " started."
    redirect_to @league
  end

  def end_season
    if @league.update_attributes(end_season_params)
      flash[:notice] = "Season " + @league.current_season_number.to_s +
                       " complete!"
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
  end

  def fighters
  end

  private
    def create_league_params
      params.require(:league).permit(:name, :game_id, :commissioner_id, :started,
        :current_season_number, :current_round, :match_count, :info,
        :password_protected, :password, :password_confirmation)
    end

    def update_league_params
      params.require(:league).permit(:name, :match_count, :info, :banner)
    end

    def start_league_params
      params.require(:league).permit(:started, :current_season_number,
                                     :current_round)
    end

    def end_season_params
      params.require(:league).permit(:started, :current_round)
    end

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
