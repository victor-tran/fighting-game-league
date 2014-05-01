class Match < ActiveRecord::Base

  # Associations
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
  validates_numericality_of :p1_score, only_integer: true
  validates_numericality_of :p2_score, only_integer: true
  validates :game_id, presence: true
  validate :match_scores_are_at_match_count
 
  # Match score count validation
  def match_scores_are_at_match_count
    match_count = League.find(league_id).match_count

    # Make sure that scores can't be negative.  
    if p1_score < 0 || p2_score < 0
      errors.add(:match_score, " cannot be negative")
  
    # Don't allow 0-0 score for tournament matches
    elsif tournament_id != nil && p1_score == 0 && p2_score == 0
      errors.add(:at_least_one_match_score, "must be above 0")

    # Score is being changed
    elsif p1_score > 0 || p2_score > 0

      # Tournament matches don't adhere to league's match count.
      if tournament_id != nil

        # Make sure there isn't a tie for a tournament match.
        if p1_score == p2_score
          errors.add(:there_cannot, " be a tie")
        end

      # Either player's score are not HIGHER than match count
      elsif p1_score <= match_count && p2_score <= match_count

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


  # Returns user id of the winner of the match.
  def winner_id
    if p1_score > p2_score
      p1_id
    else
      p2_id
    end
  end

  # Pay the users who bet on winning player
  def pay_winning_betters

    winning_id = winner_id

    # Pay all users who's favorite pick equals winner_id
    self.bets.each do |bet|
      if bet.favorite_id == winning_id
        user = User.find(bet.better_id)
        user.update_attribute(:fight_bucks, bet.wager_amount * 2)

=begin
        # Post to user feed based on user's current betting streak.
        if user.current_betting_streak == 5
          user.posts.create!(action: "3_bet_streak")
        end
=end
      end
    end
    
  end

  # Returns p1 alias -- p1 score:p2 score -- p2 alias
  def display_score
    p1.alias + " -- " + p1_score.to_s + ":" + p2_score.to_s + " -- " + p2.alias
  end

  # Returns true if match score = 0:0
  def scores_not_set?
    p1_score == 0 && p2_score == 0
  end
end