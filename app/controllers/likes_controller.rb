class LikesController < ApplicationController
  before_action :signed_in_user

  def create
    @post = Post.find(params[:like][:post_id])
    current_user.like_post!(@post)

    # Send a notification to commissioner for a league_post.
    if @post.postable_type == 'League'
      op = @post.postable.commissioner

      # Create a notification on the backend.
      n = op.notifications.create!(sendable_id: current_user.id,
                               sendable_type: 'User',
                               targetable_id: @post.id,
                               targetable_type: 'Post',
                               read: false)
      # Send a push notification via Pusher API to OP.
      Pusher['private-user-'+op.id.to_s].trigger('new_notification',
                                                 { notification_id: n.id,
                                                   unread_count: op.notifications.unread.count })
    
    # Send a notification to OP that current user liked their post.
    else
      op = @post.postable

      # Create a notifiation on the backend.
      n = op.notifications.create!(sendable_id: current_user.id,
                               sendable_type: 'User',
                               targetable_id: @post.id,
                               targetable_type: 'Post',
                               read: false)
      # Send a push notification via Pusher API to OP.
      Pusher['private-user-'+op.id.to_s].trigger('new_notification',
                                                 { notification_id: n.id,
                                                   unread_count: op.notifications.unread.count })
    end
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js { @post }
    end
  end

  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike_post!(@post)

    # Delete the notification sent to commissioner for a league_post.
    if @post.postable_type == 'League'
      op = @post.postable.commissioner

      # Delete OP's notification on the backend.
      n = op.notifications.find_by(sendable_id: current_user.id,
                                   sendable_type: 'User',
                                   targetable_id: @post.id,
                                   targetable_type: 'Post').destroy
      # Send a push notification via Pusher API to OP.
      Pusher['private-user-'+op.id.to_s].trigger('delete_notification',
                                                 { unread_count: op.notifications.unread.count })
    else
      op = @post.postable

      # Delete OP's notification on the backend.
      n = op.notifications.find_by(sendable_id: current_user.id,
                                   sendable_type: 'User',
                                   targetable_id: @post.id,
                                   targetable_type: 'Post').destroy
      # Send a push notification via Pusher API to OP.
      Pusher['private-user-'+op.id.to_s].trigger('delete_notification',
                                                 { unread_count: op.notifications.unread.count })
    end
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js { @post }
    end
  end
end
