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
                                                       action: "joined",
                                                       read: false)
        # Send a push notification via Pusher API to @user.
        if current_user.avatar_file_name == nil
          Pusher['private-user-'+@league.commissioner.id.to_s].trigger('new_follower_notification',
                                                         { follower_id: current_user.id,
                                                           unread_count: @league.commissioner.notifications.unread.count,
                                                           notification_content: "#{current_user.alias} joined your '#{@league.name}' league.",
                                                           no_avatar: true,
                                                           notification_id: n.id })
        else
          Pusher['private-user-'+@league.commissioner.id.to_s].trigger('new_follower_notification',
                                                         { follower_id: current_user.id,
                                                           unread_count: @league.commissioner.notifications.unread.count,
                                                           notification_content: "#{current_user.alias} joined your '#{@league.name}' league.",
                                                           no_avatar: false,
                                                           img_alt: current_user.avatar_file_name.gsub(".jpg", ""),
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
                                                     action: "joined",
                                                     read: false)
      # Send a push notification via Pusher API to @user.
      if current_user.avatar_file_name == nil
        Pusher['private-user-'+@league.commissioner.id.to_s].trigger('new_follower_notification',
                                                       { follower_id: current_user.id,
                                                         unread_count: @league.commissioner.notifications.unread.count,
                                                         notification_content: "#{current_user.alias} joined your '#{@league.name}' league.",
                                                         no_avatar: true,
                                                         notification_id: n.id })
      else
        Pusher['private-user-'+@league.commissioner.id.to_s].trigger('new_follower_notification',
                                                       { follower_id: current_user.id,
                                                         unread_count: @league.commissioner.notifications.unread.count,
                                                         notification_content: "#{current_user.alias} joined your '#{@league.name}' league.",
                                                         no_avatar: false,
                                                         img_alt: current_user.avatar_file_name.gsub(".jpg", ""),
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
                                                   action: "joined").destroy
    # Delete the 'joined' notification from @user's list of notifications.
    Pusher['private-user-'+@league.commissioner.id.to_s].trigger('delete_notification',
                                               { unread_count: @league.commissioner.notifications.unread.count,
                                                 notification_id: n.id })
    # Delete @user's 'followed' notification on the backend.
    n = @league.commissioner.notifications.find_by(sendable_id: current_user.id,
                                                   sendable_type: 'User',
                                                   targetable_id: @league.id,
                                                   targetable_type: 'League',
                                                   action: "followed").destroy
    respond_to do |format|
      format.html { redirect_to @league }
      format.js
    end
  end
end
