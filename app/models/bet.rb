class Bet < ActiveRecord::Base
  belongs_to :match
  belongs_to :better, class_name: 'User'
  belongs_to :favorite, class_name: 'User'

  validates :match_id, presence: true
  validates :better_id, presence: true
  validates :favorite_id, presence: true
  validates_numericality_of :wager_amount, greater_than: 0

  def create_bet_won_notification(amount_won)

    # Create a notification for the better on the backend.
    n = better.notifications.create!(sendable_id: match.id,
                                     sendable_type: 'Match',
                                     targetable_id: id,
                                     targetable_type: 'Bet',
                                     content: Notification.bet_decided('won', self, amount_won),
                                     read: false)
    # Send a push notification via Pusher API to follower.
    if match.league.banner_file_name == nil
      Pusher['private-user-'+better.id.to_s].trigger('match_notification',
                                                    { match_id: match.id,
                                                      unread_count: favorite.notifications.unread.count,
                                                      notification_content: Notification.bet_decided('won', self, amount_won),
                                                      no_banner: true,
                                                      notification_id: n.id })
    else
      Pusher['private-user-'+better.id.to_s].trigger('match_notification',
                                                    { match_id: match.id,
                                                      unread_count: favorite.notifications.unread.count,
                                                      notification_content: Notification.bet_decided('won', self, amount_won),
                                                      no_banner: false,
                                                      img_alt: match.league.banner_file_name.gsub(/.(jpg|jpeg|gif|png)/,""),
                                                      img_src: match.league.banner.url(:post),
                                                      notification_id: n.id })
    end
  end

  def create_bet_lost_notification(amount_lost)

    # Create a notification for the better on the backend.
    n = better.notifications.create!(sendable_id: match.id,
                                     sendable_type: 'Match',
                                     targetable_id: id,
                                     targetable_type: 'Bet',
                                     content: Notification.bet_decided('lost', self, amount_lost),
                                     read: false)
    # Send a push notification via Pusher API to follower.
    if match.league.banner_file_name == nil
      Pusher['private-user-'+better.id.to_s].trigger('match_notification',
                                                    { match_id: match.id,
                                                      unread_count: favorite.notifications.unread.count,
                                                      notification_content: Notification.bet_decided('lost', self, amount_lost),
                                                      no_banner: true,
                                                      notification_id: n.id })
    else
      Pusher['private-user-'+better.id.to_s].trigger('match_notification',
                                                    { match_id: match.id,
                                                      unread_count: favorite.notifications.unread.count,
                                                      notification_content: Notification.bet_decided('lost', self, amount_lost),
                                                      no_banner: false,
                                                      img_alt: match.league.banner_file_name.gsub(/.(jpg|jpeg|gif|png)/,""),
                                                      img_src: match.league.banner.url(:post),
                                                      notification_id: n.id })
    end
  end
end
