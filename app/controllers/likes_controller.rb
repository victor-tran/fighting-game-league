class LikesController < ApplicationController
  before_action :signed_in_user

  def create
    @post = Post.find(params[:like][:post_id])
    current_user.like_post!(@post)

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
                                   action: "liked",
                                   read: false)
      # Send a push notification via Pusher API to OP.
      if current_user.avatar_file_name == nil
        Pusher['private-user-'+op.id.to_s].trigger('new_like_notification',
                                                   { op_id: @post.postable_id,
                                                     op_type: @post.postable_type.underscore.pluralize,
                                                     targetable_id: n.targetable_id,
                                                     targetable_type: n.targetable_type.underscore.pluralize,
                                                     sender_name: current_user.alias,
                                                     unread_count: op.notifications.unread.count,
                                                     post_content: @post.content,
                                                     no_avatar: true,
                                                     notification_id: n.id })
      else
        Pusher['private-user-'+op.id.to_s].trigger('new_like_notification',
                                                   { op_id: @post.postable_id,
                                                     op_type: @post.postable_type.underscore.pluralize,
                                                     targetable_id: n.targetable_id,
                                                     targetable_type: n.targetable_type.underscore.pluralize,
                                                     sender_name: current_user.alias,
                                                     unread_count: op.notifications.unread.count,
                                                     post_content: @post.content,
                                                     no_avatar: false,
                                                     img_alt: current_user.avatar_file_name.gsub(".jpg", ""),
                                                     img_src: current_user.avatar.url(:post),
                                                     notification_id: n.id })
      end
    end
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js { @post }
    end
  end

  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike_post!(@post)

    # Delete a notification for current user, unless they are unliking their
    # own post. In that case, there wasn't a notification created.
    op = User.new

    if @post.postable_type == 'League'
      # Delete the notification sent to commissioner for a league_post.
      op = @post.postable.commissioner
    else
      # Delete the notification sent to OP from current user.
      op = @post.postable
    end

    unless current_user?(op)
      # Delete OP's notification on the backend.
      n = op.notifications.find_by(sendable_id: current_user.id,
                                   sendable_type: 'User',
                                   targetable_id: @post.id,
                                   targetable_type: 'Post').destroy
      # Send a push notification via Pusher API to OP.
      Pusher['private-user-'+op.id.to_s].trigger('delete_notification',
                                                 { unread_count: op.notifications.unread.count,
                                                   notification_id: n.id })
    end
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js { @post }
    end
  end

  private
    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
end
