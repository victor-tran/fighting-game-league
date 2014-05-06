class LikesController < ApplicationController
  before_action :signed_in_user

  def create
    @post = Post.find(params[:like][:post_id])
    current_user.like_post!(@post)

    # Send a notification to commissioner for a league_post.
    if @post.postable_type == 'League'
      op = @post.postable.commissioner
      n = op.notifications.create!(sendable_id: current_user.id,
                               sendable_type: 'User',
                               targetable_id: @post.id,
                               targetable_type: 'Post',
                               read: false)

      # Heroku code
      Pusher['private-user-'+op.id.to_s].trigger('new_notification',
                                                 { notification_id: n.id })
    
    # Send a notification to OP that current user liked their post.
    else
      op = @post.postable
      n = op.notifications.create!(sendable_id: current_user.id,
                               sendable_type: 'User',
                               targetable_id: @post.id,
                               targetable_type: 'Post',
                               read: false)
      Pusher['private-user-'+op.id.to_s].trigger('new_notification',
                                                 { notification_id: n.id })
    end
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js { @post }
    end
  end

  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike_post!(@post)
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js { @post }
    end
  end
end
