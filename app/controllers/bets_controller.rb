include ActionView::Helpers::TextHelper
class BetsController < ApplicationController
  before_action :signed_in_user
  
  def create
    @match = Match.find(params[:bet][:match_id])
    @fav_user = User.find(params[:bet][:favorite_id])
    wager_amount = params[:bet][:wager_amount].to_i
    if wager_amount > current_user.fight_bucks
      flash[:warning] = "Not enough fight bucks"
    else
      # Figure out the opponent.
      if @fav_user == @match.p1
        @opponent = @match.p2
      else
        @opponent = @match.p1
      end

      # Create the bet.
      @bet = current_user.bet!(@match, @fav_user, wager_amount)
      
      # Create a notification for the user that was favored.
      create_bet_on_user_notification

      # Create a betting post to display on user feeds.
      current_user.posts.create!(action: 'bet_on_p1',
                                 subjectable_id: @bet.id,
                                 subjectable_type: 'Bet',
                                 content: "#{current_user.alias} bet #{pluralize(wager_amount, "fight buck")} " +
                                          "on #{@fav_user.alias} to win against #{@opponent.alias}.")
    end
    redirect_to match_path(@match)
  end

  private
    def create_bet_on_user_notification

      # Create a notification on the backend.
      n = @bet.favorite.notifications.create!(sendable_id: current_user.id,
                                              sendable_type: 'User',
                                              targetable_id: @bet.id,
                                              targetable_type: 'Bet',
                                              content: Notification.bet_on_user(@bet, @opponent),
                                              read: false)
      # Send a push notification via Pusher API to follower.
      if current_user.avatar_file_name == nil
        Pusher['private-user-'+@bet.favorite.id.to_s].trigger('match_notification',
                                                      { match_id: @bet.match.id,
                                                        unread_count: @bet.favorite.notifications.unread.count,
                                                        notification_content: Notification.bet_on_user(@bet, @opponent),
                                                        no_banner: true,
                                                        notification_id: n.id })
      else
        Pusher['private-user-'+@bet.favorite.id.to_s].trigger('match_notification',
                                                      { match_id: @bet.match.id,
                                                        unread_count: @bet.favorite.notifications.unread.count,
                                                        notification_content: Notification.bet_on_user(@bet, @opponent),
                                                        no_banner: false,
                                                        img_alt: current_user.avatar.banner_file_name.gsub(/.(jpg|jpeg|gif|png)/,""),
                                                        img_src: current_user.avatar.url(:post),
                                                        notification_id: n.id })
      end
    end
end
