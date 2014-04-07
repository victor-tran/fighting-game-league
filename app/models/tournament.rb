class Tournament < ActiveRecord::Base
  has_many :matches
  belongs_to :league
  belongs_to :winner, class_name: "User"

  # Constants
  MAX_LENGTH_TOURNAMENT_NAME = 60

  # Validations
  validates :name,  presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: MAX_LENGTH_TOURNAMENT_NAME }
  validates :league_id, presence: true
  validates :participants, presence: true
  validates :season_number, presence: true
  validates_numericality_of :winner_id, only_integer: true, allow_blank: true
  validates :game_id, presence: true
end
