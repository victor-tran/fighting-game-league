class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :get_user,       only: [:edit, :update, :show, :fight_history,
                                        :followers, :following]

  def get_user
    @user = User.find(params[:id])
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(create_user_params)
    if @user.save
      redirect_to root_url
=begin Take out user sign up for beta testing.
      UserMailer.signup_confirmation(@user).deliver
      render 'pending'
    else
      render 'new'
=end
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(update_user_params)
      flash[:notice] = "Profile updated."
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def show
  end

  def confirmation
    # Find user by UUID and make confirmed true.
    @user = User.find_by_uuid(params[:uuid])
    unless @user == nil
      @user.update_attribute(:confirmed, true)
      sign_in @user
      flash[:notice] = "Welcome to the Fighting Game League!"
    end
    redirect_to root_url
  end

  def following
    @title = "Following"
    @following = @user.followed_leagues + @user.followed_users
    @users = @following.paginate(page: params[:page], per_page: 10)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def fight_history
    @decided_matches = @user.matches.reject { |match| match.finalized_date == nil }.sort { |x,y| y.finalized_date <=> x.finalized_date }
    @decided_matches = @decided_matches.paginate(page: params[:page], per_page: 10)
  end
  
  private
    def create_user_params
      params.require(:user).permit(:first_name, :last_name, :alias, :email, 
                                   :password, :password_confirmation,
                                   :fight_bucks, :uuid, :confirmed)
    end

    def update_user_params
      params.require(:user).permit(:first_name, :last_name, :alias, :email, 
                                   :password, :password_confirmation, :bio, 
                                   :tagline, :avatar, :facebook_account,
                                   :twitter_account, :twitch_account)
    end

  	# Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
