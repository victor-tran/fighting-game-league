class Match < ActiveRecord::Base
  belongs_to :league
  belongs_to :p1, class_name: "User"
  belongs_to :p2, class_name: "User"
  belongs_to :game
  has_many :bets, dependent: :destroy

  # Validations
  validates :round_number, presence: true
  validates :p1_id, presence: true
  validates :p2_id, presence: true
  validates :season_number, presence: true
  validates :league_id, presence: true
  validates_numericality_of :p1_score, :only_integer => true
  validates :game_id, presence: true
  validate :match_scores_are_at_match_count
 
  # Match score count validation
  def match_scores_are_at_match_count
    match_count = League.find(league_id).match_count

    # Score is being changed
    if p1_score > 0 || p2_score > 0

      # Either player's score are not HIGHER than match count
      if p1_score <= match_count && p2_score <= match_count

        # At least one of the scores is at the league match count
        if p1_score == match_count || p2_score == match_count

          # Make sure that BOTH aren't at match count
          if p1_score == match_count && p2_score == match_count
            errors.add(:only_one_match_score, " can be at " + match_count.to_s)
          end

        # Neither of the scores are at the match count
        else
          errors.add(:at_least_one_match_score, "must be at " + match_count.to_s)
        end

      # One of the player's score is HIGHER than match count 
      else
        errors.add(:match_score, " cannot be higher than " + match_count.to_s)
      end
    end
  end

  # Pay the users who bet on winning player
  def pay_winning_betters
    
    # Figure out winning user
    if p1_score > p2_score
      winner_id = p1_id
    else
      winner_id = p2_id
    end

    # Pay all users who's favorite pick equals winner_id
    self.bets.each do |bet|
      if bet.favorite_id == winner_id
        user = User.find(bet.better_id)
        user.update_attribute(:fight_bucks, user.fight_bucks + 2)
      end
    end
    
  end
end