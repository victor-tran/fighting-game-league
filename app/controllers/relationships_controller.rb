class RelationshipsController < ApplicationController
  before_action :signed_in_user

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)

    # Create a notification on the backend.
    n = @user.notifications.create!(sendable_id: current_user.id,
                                    sendable_type: 'User',
                                    targetable_id: @user.id,
                                    targetable_type: 'User',
                                    action: "followed",
                                    read: false)
    # Send a push notification via Pusher API to @user.
    if current_user.avatar_file_name == nil
      Pusher['private-user-'+@user.id.to_s].trigger('new_follower_notification',
                                                     { follower_id: current_user.id,
                                                       unread_count: @user.notifications.unread.count,
                                                       notification_content: "#{current_user.alias} followed you.",
                                                       no_avatar: true,
                                                       notification_id: n.id })
    else
      Pusher['private-user-'+@user.id.to_s].trigger('new_follower_notification',
                                                     { follower_id: current_user.id,
                                                       unread_count: @user.notifications.unread.count,
                                                       notification_content: "#{current_user.alias} followed you.",
                                                       no_avatar: false,
                                                       img_alt: current_user.avatar_file_name.gsub(".jpg", ""),
                                                       img_src: current_user.avatar.url(:post),
                                                       notification_id: n.id })
    end
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    # Delete @user's notification on the backend.
    n = @user.notifications.find_by(sendable_id: current_user.id,
                                    sendable_type: 'User',
                                    targetable_id: @user.id,
                                    targetable_type: 'User',
                                    action: "followed").destroy
    # Delete the notification from @user's list of notifications.
    Pusher['private-user-'+@user.id.to_s].trigger('delete_notification',
                                               { unread_count: @user.notifications.unread.count,
                                                 notification_id: n.id })
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end