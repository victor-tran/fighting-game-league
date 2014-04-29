class LeagueRelationship < ActiveRecord::Base
  belongs_to :league
  belongs_to :follower, class_name: "User"
  validates :league_id, presence: true
  validates :follower_id, presence: true
end
