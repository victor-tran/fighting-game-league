class Match < ActiveRecord::Base
  belongs_to :league
  belongs_to :p1, class_name: "User"
  belongs_to :p2, class_name: "User"

  # Validations
  validates :round_number, presence: true
  validates :p1_id, presence: true
  validates :p2_id, presence: true
  validates :season_number, presence: true
  validates :league_id, presence: true
end
