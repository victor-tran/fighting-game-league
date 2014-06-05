class MembershipsController < ApplicationController
	before_action :signed_in_user
  
  def create
    @league = League.find(params[:membership][:league_id])

    if @league.password_protected 
      if @league.authenticate(params[:membership][:password])
        current_user.join!(@league) unless @league.started
        # Create a notification on the backend.
        n = @league.commissioner.notifications.create!(sendable_id: current_user.id,
                                                       sendable_type: 'User',
                                                       targetable_id: @league.id,
                                                       targetable_type: 'League',
                                                       content: Notification.joined_league(current_user, @league),
                                                       read: false)
        # Send a push notification via Pusher API to @user.
        if current_user.avatar_file_name == nil
          Pusher['private-user-'+@league.commissioner.id.to_s].trigger('user_notification',
                                                         { follower_id: current_user.id,
                                                           unread_count: @league.commissioner.notifications.unread.count,
                                                           notification_content: Notification.joined_league(current_user, @league),
                                                           no_avatar: true,
                                                           notification_id: n.id })
        else
          Pusher['private-user-'+@league.commissioner.id.to_s].trigger('user_notification',
                                                         { follower_id: current_user.id,
                                                           unread_count: @league.commissioner.notifications.unread.count,
                                                           notification_content: Notification.joined_league(current_user, @league),
                                                           no_avatar: false,
                                                           img_alt: current_user.avatar_file_name.gsub(/.(jpg|jpeg|gif|png)/,""),
                                                           img_src: current_user.avatar.url(:post),
                                                           notification_id: n.id })
        end
        flash[:notice] = "Joined " + @league.name
        redirect_to @league
      else
        flash[:warning] = "Invalid password"
        redirect_to join_password_league_path(@league)
      end
    else
      current_user.join!(@league) unless @league.started
      # Create a notification on the backend.
      n = @league.commissioner.notifications.create!(sendable_id: current_user.id,
                                                     sendable_type: 'User',
                                                     targetable_id: @league.id,
                                                     targetable_type: 'League',
                                                     content: Notification.joined_league(current_user, @league),
                                                     read: false)
      # Send a push notification via Pusher API to @user.
      if current_user.avatar_file_name == nil
        Pusher['private-user-'+@league.commissioner.id.to_s].trigger('user_notification',
                                                       { follower_id: current_user.id,
                                                         unread_count: @league.commissioner.notifications.unread.count,
                                                         notification_content: Notification.joined_league(current_user, @league),
                                                         no_avatar: true,
                                                         notification_id: n.id })
      else
        Pusher['private-user-'+@league.commissioner.id.to_s].trigger('user_notification',
                                                       { follower_id: current_user.id,
                                                         unread_count: @league.commissioner.notifications.unread.count,
                                                         notification_content: Notification.joined_league(current_user, @league),
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
  end

  def destroy
    @league = Membership.find(params[:id]).league
    current_user.leave!(@league) unless @league.started
    # Delete @user's 'joined' notification on the backend.
    n = @league.commissioner.notifications.find_by(sendable_id: current_user.id,
                                                   sendable_type: 'User',
                                                   targetable_id: @league.id,
                                                   targetable_type: 'League',
                                                   content: Notification.joined_league(current_user, @league)).destroy
    # Delete the 'joined' notification from @user's list of notifications.
    Pusher['private-user-'+@league.commissioner.id.to_s].trigger('delete_notification',
                                               { unread_count: @league.commissioner.notifications.unread.count,
                                                 notification_id: n.id })
    # If @user followed a league first, then joined they league, then delete
    # the 'followed' notification on the backend as well.
    n = @league.commissioner.notifications.find_by(sendable_id: current_user.id,
                                                   sendable_type: 'User',
                                                   targetable_id: @league.id,
                                                   targetable_type: 'League',
                                                   content: Notification.followed_league(current_user, @league))
    unless n == nil
      n.destroy
    end
    respond_to do |format|
      format.html { redirect_to @league }
      format.js
    end
  end
end
