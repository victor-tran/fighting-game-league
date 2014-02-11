class League < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  has_many :matches, dependent: :destroy

  # Constants
  MAX_LENGTH_LEAGUE_NAME = 50

  # Validations
  validates :name,  presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: MAX_LENGTH_LEAGUE_NAME }
  validates :game_id, presence:true
  validates :commissioner_id, presence: true
  validates_inclusion_of :started, :in => [true, false]
  validates :current_season_number, presence: true
  validates :current_round, presence: true
  validates :match_count, presence: true
  validates :info, presence: true

  # Generates and schedules matches for a single round-robin schedule.
  def generate_matches

    # Season data
    matches_per_round = users.count / 2
    total_matches = (users.count - 1) * matches_per_round
    total_rounds = total_matches / matches_per_round

    # Generate all possible combinations of head-to-head matches.
    match_array = users.combination(2).to_a

    # The hashmap that will keep track of who has already been
    # scheduled to play for that round.
    user_hashmap = {}

    # Schedule matches round by round, by selecting a random match out of 
    # the set and making sure that either one of the players hasn't already
    # been scheduled to play for that round through our generated hashmap.
    for i in 1..total_rounds

      # Will reset all user's values to false before each round of scheduling.
      users.each do |user|
        user_hashmap[user] = false
      end

      # Schedule matches for this round.
      for j in 1..matches_per_round

        # Select a random match
        match = match_array.sample

        # Keep choosing a random match out of the match_array until we get two
        # teams that haven't been scheduled for this round.
        until user_hashmap[match[0]] == false && user_hashmap[match[1]] == false
          match = match_array.sample
        end

        # Create and assign the match for this current round
        matches.create!(round_number: i, 
                        p1_id: match[0].id, 
                        p2_id: match[1].id, 
                        p1_score: 0,
                        p2_score: 0,
                        season_number: current_season_number,
                        league_id: id,
                        p1_accepted: false,
                        p2_accepted: false)

        # Mark the users in the hashmap as TRUE so they won't be scheduled
        # more than once per round.
        user_hashmap[match[0]] = true
        user_hashmap[match[1]] = true

        # Remove the match out of the match_array
        match_array.delete(match)
      end
    end
  end
end