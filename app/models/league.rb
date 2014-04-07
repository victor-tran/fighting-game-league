class League < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :matches
  has_many :tournaments
  belongs_to :game
  belongs_to :commissioner, class_name: "User"

  # Constants
  MAX_LENGTH_LEAGUE_NAME = 40
  MIN_LENGTH_PASSWORD = 6

  # Validations
  validates :name,  presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: MAX_LENGTH_LEAGUE_NAME }
  validates :game_id, presence: true
  validates :commissioner_id, presence: true
  validates_inclusion_of :started, in: [true, false]
  validates :current_season_number, presence: true
  validates :current_round, presence: true
  validates :match_count, presence: true
  validates :info, presence: true
  validates_inclusion_of :playoffs_started, in: [true, false]
  has_secure_password validations: false
  validates :password, length: { minimum: MIN_LENGTH_PASSWORD },
                       allow_blank: true

  # Banner stuff.
  has_attached_file :banner, 
    styles: {
      small: '100x100>',
      medium: '400x125',
      large: '1140x275#'
    }, 
    :default_url => "http://www.screenslam.com/blog/wp-content/uploads/2012/05/missing-ashley-judd-banner.jpg"

  # Validates that the attached image is jpg or png.
  validates_attachment :banner,
    :content_type => { :content_type => ["image/jpg", "image/png",
                                         "image/jpeg", "image/gif"] }

  # Search stuff.
  def self.text_search(query)
    if query.present?
      where("name @@ :q", q: query)
    else
      all
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
      unless match.tournament_id != nil
        if match.season_number == current_season_number
          current_matches.add(match)
        end
      end
    end

    current_matches
  end

  # Returns the number of total matches played for the league for the
  # statistics page.
  def total_matches_played
    count = 0

    matches.each do |match|
      unless match.finalized_date == nil 
        count += 1
      end
    end

    count
  end

  # Generates and schedules matches for a single round-robin schedule.
  def generate_matches
    
    matches_per_round = users.count / 2

    # Generate all possible combinations of head-to-head matches.
    # Each match in the match array will be an array with 2 users.
    # Player 1 = match[0] and Player 2 = match[1]
    match_array = users.combination(2).to_a

    # The hashmap that will keep track of who has already been
    # scheduled to play for that round.
    user_hashmap = {}

    # Schedule matches round by round, by selecting a random match out of 
    # the set and making sure that either one of the players hasn't already
    # been scheduled to play for that round through our generated hashmap.
    for i in 1..total_rounds

      # Will reset all user's scheduled values to false before each round of 
      # scheduling.
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

  # Swap the second quarter of an array with the last quarter
  def swap_interleaved(a)
    n = a.size >> 2
    a[n..2*n-1],a[3*n..4*n-1] = a[3*n..4*n-1],a[n..2*n-1]
  end

  # Swap the third quarter of an array with the last quarter
  def swap(a)
    n = a.size >> 2
    a[2*n..3*n-1],a[3*n..4*n-1] = a[3*n..4*n-1],a[2*n..3*n-1]
  end

  # For the given array, swap_interleaved, then swap
  # if level is not reached, split array in half and recurse for both halves
  def rec(a, level)
    swap_interleaved a
    swap(a)
    if (level>0)
      a[0..a.size/2-1] = rec(a[0..a.size/2-1], level-1)
      a[a.size/2..-1] = rec(a[a.size/2..-1], level-1)
    end
    a
  end

  # Generate the matchups for a single elimination tournament.
  def generate_single_elimination_tournament_matchups(user_array)
    # Match up first-round pairings
    num_players = user_array.length
    n = (Math.log(num_players-1)/Math.log(2)).to_i+1

    # New array (2**n in size)
    a = Array.new(2**n)

    # add players
    a[0..num_players-1] = user_array

    # make first-round pairings
    a = a[0..a.size/2-1].zip(a[a.size/2..-1].reverse)

    # recurse
    (n-3).downto(0) do |l|
      rec(a,l)
    end

    # remove double byes
    result = []
    a.each_slice(2) do |a,b|
      if a[1] || b[1]
        result << a << b
      else
        result << [a[0],b[0]]
      end
    end
    result
  end

  # Returns an array sorted by Wins that contains each user's W-L-MP.
  def generate_user_standings(match_set)

    # Set all user's W-L values to 0-0 and set matches played to 0.
    user_hashmap = {}
    users.each do |user|
      user_hashmap[user] = [0,0,0]
    end

    # Calculate each user's W-L-MP
    match_set.each do |match|

      # Only calculate if match has been accepted by p1 & p2.
      if match.p1_accepted == true && match.p2_accepted == true
        if match.p1_id == match.winner_id
          user_hashmap[match.p1][0] += 1
          user_hashmap[match.p1][2] += 1

          user_hashmap[match.p2][1] += 1
          user_hashmap[match.p2][2] += 1
        else
          user_hashmap[match.p2][0] += 1
          user_hashmap[match.p2][2] += 1

          user_hashmap[match.p1][1] += 1
          user_hashmap[match.p1][2] += 1
        end

        # Remove the match from match_set
        match_set.delete(match)
      end
    end
    
    # Convert hashmap to an array that is sorted by Wins and then by MP.
    user_hashmap.to_a.sort_by{ |user| [ -user[1][0], -user[1][2] ] }
  end

  def start_playoffs
    # Create Challonge double elimination tournament through the Ruby API.
    t = Challonge::Tournament.new
    t.name = self.name + " Season " + self.current_season_number.to_s + " Playoffs"
    t.url = self.name.downcase.tr(' ', '_') + "_season_" + self.current_season_number.to_s + "_playoffs"
    t.tournament_type = 'double elimination'
    
    if t.save

      # Add the participants to the tournament based on seeding during
      # regular season.
      seeded_users = self.generate_user_standings(self.matches_for_current_season)
      for i in 0..seeded_users.count - 1
        user = User.find(seeded_users[i][0])
        Challonge::Participant.create(name: user.alias,
                                      email: user.email,
                                      misc: user.id,
                                      tournament: t)
      end

      # Start the tournament!
      t.start!

      # Create participants array for the tournament.
      id_array = Array.new
      for i in 0..seeded_users.count - 1
        user = User.find(seeded_users[i][0])
        id_array[i] = user.id.to_s
      end

      # After successfully creating a tournament on Challonge,
      # create a new tournament for FGL.
      tournaments.create!(name: name + " Season " + current_season_number.to_s + " Playoffs",
                          league_id: id,
                          season_number: current_season_number,
                          participants: id_array,
                          live_image_url: t.live_image_url,
                          full_challonge_url: t.full_challonge_url,
                          game_id: game_id)
    end
  end

  def end_playoffs
    url = tournaments.last.full_challonge_url.sub(/^https?\:\/\//, '').sub(/^challonge.com/,'').sub(/^\//, '')
    t = Challonge::Tournament.find(url)
    
    # Finalize the tournament on Challonge.
    t.post(:finalize)

    # Find the winner of the tournament and update our DB.
    t.participants.each do |participant|
      if participant.final_rank.to_i == 1
        Tournament.find_by_full_challonge_url(t.full_challonge_url).update_attribute(:winner_id, participant.misc.to_i)
      end
    end
  end

  def awaiting_review?
    url = tournaments.last.full_challonge_url.sub(/^https?\:\/\//, '').sub(/^challonge.com/,'').sub(/^\//, '')
    
    if Challonge::Tournament.find(url).state == "awaiting_review"
      true
    else
      false
    end
  end

  def playoffs_underway?
    url = tournaments.last.full_challonge_url.sub(/^https?\:\/\//, '').sub(/^challonge.com/,'').sub(/^\//, '')
    
    if Challonge::Tournament.find(url).state == "underway"
      true
    else
      false
    end
  end

  def playoffs_complete?
    url = tournaments.last.full_challonge_url.sub(/^https?\:\/\//, '').sub(/^challonge.com/,'').sub(/^\//, '')
    
    if Challonge::Tournament.find(url).state == "complete"
      true
    else
      false
    end
  end

end
