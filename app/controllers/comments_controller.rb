class CommentsController < ApplicationController
  before_action :signed_in_user
  
  def create
    @post = Post.find(params[:comment][:post_id])
    @comment = @post.comments.build(comment_params)
    if @comment.save
      flash[:notice] = "Comment posted!"
    end

    # Create a notification for current user,
    # unless they are liking their own post.
    op = User.new

    if @post.postable_type == 'League'
      # Send a notification to commissioner for a league_post.
      op = @post.postable.commissioner
    else
      # Send a notification to OP that current user liked their post.
      op = @post.postable
    end

    unless current_user?(op)
      # Create a notification on the backend.
      n = op.notifications.create!(sendable_id: current_user.id,
                                   sendable_type: 'User',
                                   targetable_id: @post.id,
                                   targetable_type: 'Post',
                                   read: false)
      # Send a push notification via Pusher API to OP.
      Pusher['private-user-'+op.id.to_s].trigger('new_comment_notification',
                                                 { op_id: @post.postable_id,
                                                   op_type: @post.postable_type.underscore.pluralize,
                                                   targetable_id: n.targetable_id,
                                                   targetable_type: n.targetable_type.underscore.pluralize,
                                                   sender_name: current_user.alias,
                                                   unread_count: op.notifications.unread.count })
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
