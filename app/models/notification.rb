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
end
