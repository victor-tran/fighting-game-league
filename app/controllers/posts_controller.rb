class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
    @comment = @post.comments.build if signed_in?
  end

  def likers
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end
end
