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
  validates :p1_score, :numericality => { :greater_than_or_equal_to => 0 }
  validates :p2_score, :numericality => { :greater_than_or_equal_to => 0 }
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
            errors.add(:match_score_at_match_count, "Only one fighter's score can be at " + match_count.to_s)
          end

        # Neither of the scores are at the match count
        else
          errors.add(:match_score_at_match_count, "One fighter's score must be at " + match_count.to_s)
        end

      # One of the player's score is HIGHER than match count 
      else
        errors.add(:match_score_at_match_count, "One fighter's score cannot be higher than " + match_count.to_s)
      end
    end
  end
end