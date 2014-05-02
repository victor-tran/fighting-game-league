class LikesController < ApplicationController
  before_action :signed_in_user

  def create
    #binding.pry
    @post = Post.find(params[:like][:post_id])
    current_user.like_post!(@post)
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js { @post }
    end
  end

  def destroy
    #binding.pry
    @post = Like.find(params[:id]).post
    current_user.unlike_post!(@post)
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js { @post }
    end
  end
end
