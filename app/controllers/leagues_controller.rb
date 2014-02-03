class LeaguesController < ApplicationController
  
  def index
    @leagues = League.paginate(page: params[:page])
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
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
    @league = League.find(params[:id])
    @users = @league.users
  end

  def edit
    @league = League.find(params[:id])
  end
  
  def update
    @league = League.find(params[:id])
    if @league.update_attributes(start_league_params)
      @league.generate_matches
      flash[:notice] = "League successfully started!"
      redirect_to @league
    elsif @league.update_attributes(edit_league_params)
      flash[:notice] = "League successfully updated."
      redirect_to @league
    else
      render 'edit'
    end
  end

  private
    def league_params
      params.require(:league).permit(:name, :game_id, :commissioner_id, :started, :current_season_number, :current_round, :match_count, :info)
    end

    def start_league_params
      params.require(:league).permit(:started, :current_season_number, :current_round)
    end

    def edit_league_params
      params.require(:league).permit(:name, :game_id, :match_count, :info)
    end
end
