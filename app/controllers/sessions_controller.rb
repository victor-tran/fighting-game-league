class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user != nil && user.confirmed == true
      if user && user.authenticate(params[:session][:password])
        sign_in user
        redirect_back_or root_path
      else
        flash.now[:error] = 'Invalid email/password combination'
        render 'new'
      end
    else
      flash.now[:error] = 'Please find the email to finish registering your account'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
