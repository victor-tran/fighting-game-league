class Notification < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }
  belongs_to :sendable, polymorphic: true
  belongs_to :receiver, class_name: "User"
  belongs_to :targetable, polymorphic: true

  validates :sendable_id, presence: true
  validates :sendable_type, presence: true
  validates :receiver_id, presence: true
  validates :targetable_id, presence: true
  validates :targetable_type, presence: true
  validates :content, presence: true
  validates_inclusion_of :read, in: [true, false]

  def self.unread
    where(read: false)
  end

  ################################
  ## Like/Comment Notifications ##
  ################################
  def self.liked_post(user, post)
    "#{user.alias} liked your post: '#{post.content}'"
  end

  def self.commented_on_post(user, post)
    "#{user.alias} commented on your post: '#{post.content}'"
  end

  ################################
  ###### User Notifications ######
  ################################
  def self.followed_user(user)
    "#{user.alias} is now following you."
  end

  def self.followed_league(user, league)
    "#{user.alias} is now following your '#{league.name}' league."
  end

  def self.joined_league(user, league)
    "#{user.alias} has joined your '#{league.name}' league."
  end

  ################################
  ##### League Notifications #####
  ################################
  def self.season_started(league)
    "#{league.name} season #{league.current_season.number} has begun!"
  end

  def self.new_round_started(league)
    "#{league.name} round #{league.current_round} has begun!"
  end

  def self.playoffs_started(league)
    "#{league.name} season #{league.current_season.number} playoffs have begun!"
  end

  def self.playoffs_ended(league)
    "#{league.name} season #{league.current_season.number} has ended with " +
    "#{league.tournaments.last.winner.alias} taking home 1st place!"
  end

  ################################
  ##### Match Notifications ######
  ################################
  def self.date_set(match)
    "The '#{match.p1.alias} vs. #{match.p2.alias}' match has been set for " +
    "#{match.match_date.in_time_zone(match.league.time_zone).strftime("%I:%M %p %Z on %B %d")}."
  end

  def self.score_set(setter, league)
    "#{setter.alias} set the score for match between you two in the '#{league.name}' league."
  end

  def self.match_finalized(action, match, opponent, score)
    "You #{action} your match against #{opponent.alias}, #{score}."
  end

  def self.bet_on_user(bet, opponent)
    "#{bet.better.alias} bet #{pluralize(bet.wager_amount, "fight buck")} on you to win against #{opponent.alias}."
  end

  def self.bet_decided(action, bet, amount_won)
    "You #{action} #{pluralize(amount_won, "fight buck")} from your bet on the '#{bet.match.p1.alias} vs. #{bet.match.p2.alias}' match."
  end
end
