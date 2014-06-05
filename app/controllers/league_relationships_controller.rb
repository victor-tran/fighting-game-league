class LeagueRelationshipsController < ApplicationController
  before_action :signed_in_user

  def create
    @league = League.find(params[:league_relationship][:league_id])
    current_user.follow_league!(@league)

    # Create a notification on the backend.
    n = @league.commissioner.notifications.create!(sendable_id: current_user.id,
                                                   sendable_type: 'User',
                                                   targetable_id: @league.id,
                                                   targetable_type: 'League',
                                                   content: Notification.followed_league(current_user, @league),
                                                   read: false)
    # Send a push notification via Pusher API to @user.
    if current_user.avatar_file_name == nil
      Pusher['private-user-'+@league.commissioner.id.to_s].trigger('user_notification',
                                                     { follower_id: current_user.id,
                                                       unread_count: @league.commissioner.notifications.unread.count,
                                                       notification_content: Notification.followed_league(current_user, @league),
                                                       no_avatar: true,
                                                       notification_id: n.id })
    else
      Pusher['private-user-'+@league.commissioner.id.to_s].trigger('user_notification',
                                                     { follower_id: current_user.id,
                                                       unread_count: @league.commissioner.notifications.unread.count,
                                                       notification_content: Notification.followed_league(current_user, @league),
                                                       no_avatar: false,
                                                       img_alt: current_user.avatar_file_name.gsub(/.(jpg|jpeg|gif|png)/,""),
                                                       img_src: current_user.avatar.url(:post),
                                                       notification_id: n.id })
    end
    respond_to do |format|
      format.html { redirect_to @league }
      format.js
    end
  end

  def destroy
    @league = LeagueRelationship.find(params[:id]).league
    current_user.unfollow_league!(@league)
    # Delete @user's notification on the backend.
    n = @league.commissioner.notifications.find_by(sendable_id: current_user.id,
                                                   sendable_type: 'User',
                                                   targetable_id: @league.id,
                                                   targetable_type: 'League',
                                                   content: Notification.followed_league(current_user, @league)).destroy
    # Delete the notification from @user's list of notifications.
    Pusher['private-user-'+@league.commissioner.id.to_s].trigger('delete_notification',
                                               { unread_count: @league.commissioner.notifications.unread.count,
                                                 notification_id: n.id })
    respond_to do |format|
      format.html { redirect_to @league }
      format.js
    end
  end
end
