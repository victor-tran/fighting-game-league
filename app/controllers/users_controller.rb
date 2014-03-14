class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :get_user,       only: [:edit, :update, :show]

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
      sign_in @user
      UserMailer.signup_confirmation(@user).deliver
      flash[:notice] = "Welcome to the Fighting Game League!"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(edit_user_params)
      flash[:notice] = "Profile updated."
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def show
  end
  
  private
    def create_user_params
      params.require(:user).permit(:first_name, :last_name, :alias, :email, 
                                   :password, :password_confirmation,
                                   :fight_bucks)
    end

    def edit_user_params
      params.require(:user).permit(:first_name, :last_name, :alias, :email, 
                                   :password, :password_confirmation, :bio, 
                                   :tagline, :avatar, :facebook_account,
                                   :twitter_account, :twitch_account)
    end

  	# Before filters

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
