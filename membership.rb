class Membership < ActiveRecord::Base
	belongs_to :league
  belongs_to :user

  validates :league_id, presence: true
  validates :user_id, presence: true
end
