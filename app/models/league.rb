class League < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :matches

  belongs_to :game

  # Constants
  MAX_LENGTH_LEAGUE_NAME = 50
  MIN_LENGTH_PASSWORD = 6

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
  has_secure_password
  validates :password, length: { minimum: MIN_LENGTH_PASSWORD }

  # Banner stuff.
  has_attached_file :banner, 
    styles: {
      small: '100x100>',
      medium: '400x125',
      large: '1140x275#'
    }, 
    :default_url => "/images/:style/missing.png"

  # Validates that the attached image is jpg or png.
  validates_attachment :banner,
    :content_type => { :content_type => ["image/jpg", "image/png", "image/jpeg", "image/gif"] }

  # Search stuff.
  def self.text_search(query)
    if query.present?
      where("name @@ :q", q: query)
    else
      scoped
    end
  end

  # Returns the total rounds for current league.
  def total_rounds
    matches_per_round = users.count / 2
    total_matches = (users.count - 1) * matches_per_round
    total_rounds = total_matches / matches_per_round

    total_rounds
  end

  # Returns true if there are more rounds left in the season
  def has_more_rounds_left_in_season?
    next_round = current_round + 1
    next_round <= total_rounds
  end

  # Returns matches for this league's current season.
  def matches_for_current_season

    current_matches = Set.new

    matches.each do |match|
      if match.season_number == current_season_number
        current_matches.add(match)
      end
    end

    current_matches
  end

  # Returns an array sorted by Wins that contains each user's W-L-MP.
  def generate_user_standings

    # Set all user's W-L values to 0-0 and set matches played to 0.
    user_hashmap = {}
    users.each do |user|
      user_hashmap[user] = [0,0,0]
    end

    match_set = matches_for_current_season

    # Calculate each user's W-L-MP
    match_set.each do |match|

      # Only calculate if match has been accepted by p1 & p2.
      if match.p1_accepted == true && match.p2_accepted == true
        if match.p1_id == match.winner_id
          user_hashmap[User.find(match.p1_id)][0] += 1
          user_hashmap[User.find(match.p1_id)][2] += 1

          user_hashmap[User.find(match.p2_id)][1] += 1
          user_hashmap[User.find(match.p2_id)][2] += 1
        else
          user_hashmap[User.find(match.p2_id)][0] += 1
          user_hashmap[User.find(match.p2_id)][2] += 1

          user_hashmap[User.find(match.p1_id)][1] += 1
          user_hashmap[User.find(match.p1_id)][2] += 1
        end

        # Remove the match from match_set
        match_set.delete(match)
      end
    end

    # Convert hashmap to an array that is sorted by Wins and then by MP.
    user_hashmap.to_a.sort_by{ |user| [ -user[1][0], -user[1][2] ] }
  end

  # Generates and schedules matches for a single round-robin schedule.
  def generate_matches
    
    matches_per_round = users.count / 2

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
                        p2_accepted: false,
                        game_id: game_id)

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
