class CommentsController < ApplicationController
  before_action :signed_in_user
  
  def create
    @post = Post.find(params[:comment][:post_id])
    @comment = @post.comments.build(comment_params)
    if @comment.save
      flash[:notice] = "Comment posted!"
    end
    
    redirect_to polymorphic_path([@post.postable, @post])
  end

  def destroy
  end

  private

    def comment_params
      params.require(:comment).permit(:post_id, :user_id, :content)
    end
end
