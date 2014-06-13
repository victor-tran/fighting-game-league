class League < ActiveRecord::Base
  include PgSearch
  multisearchable against: [:name, :info]

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :seasons
  has_many :matches
  has_many :tournaments
  belongs_to :game
  belongs_to :commissioner, class_name: "User"
  has_many :relationships, foreign_key: "league_id",
                           class_name: "LeagueRelationship",
                           dependent: :destroy
  has_many :followers, through: :relationships
  has_many :posts, as: :postable, dependent: :destroy

  # Accessors
  attr_accessor :password_confirmation

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
  validates :current_round, presence: true
  validates :match_count, presence: true
  validates :info, presence: true
  validates_inclusion_of :playoffs_started, in: [true, false]
  validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.zones_map(&:name)
  has_secure_password validations: false
  validates :password, length: { minimum: MIN_LENGTH_PASSWORD },
                       allow_blank: true
  validate do
    if password_protected == true
      if !password.present?
        errors.add :password, "missing"
      elsif !password_confirmation.present?
        errors.add :password_confirmation, "missing"
      elsif password != password_confirmation
        errors.add :password, "must match"
      end
    elsif password_protected == false and password.present?
      errors.add :password_protected, "missing when password was present"
    end
  end

  # Banner stuff.
  has_attached_file :banner, 
    styles: {
      tiny:  '20x20#',
      post:  '44x44#', 
      thumb: '80x80#',
      large: '1140x275#'
    }, 
    default_url: "/assets/league/banner/:style/missing.png"

  # Validates that the attached image is jpg or png.
  validates_attachment :banner,
    content_type: { content_type: ["image/jpg", "image/png",
                                   "image/jpeg", "image/gif"] }

  # Returns the league's current season.
  def current_season
    curr_season = seasons.where("current_season = ?", true).first

    if curr_season == nil
      curr_season = seasons.last
    end

    curr_season
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
    
    # Shuffle the users in a random order before scheduling.
    arr = users.to_a.shuffle

    # Pick the first element in the array as the pivot.
    pivot = arr.delete_at(0)

    # Schedule matches round by round
    for current_round in 1..total_rounds

      # Schedule the match with the pivot and the last element in arr.
      matches.create!(round_number: current_round, 
                      p1_id: pivot.id, 
                      p2_id: arr[-1].id, 
                      p1_score: 0,
                      p2_score: 0,
                      season_id: current_season.id,
                      league_id: id,
                      p1_accepted: false,
                      p2_accepted: false,
                      game_id: game_id)

      # Following code will break if there are only 2 users in the league.
      if users.count > 2
        # Set the index variables for inner loop.
        i = 0
        j = arr.count - 2
        while j >= (arr.count / 2)

          # Schedule the match with the first and outermost element as the two
          # players in the match and work your way in.
          matches.create!(round_number: current_round, 
                          p1_id: arr[i].id, 
                          p2_id: arr[j].id, 
                          p1_score: 0,
                          p2_score: 0,
                          season_id: current_season.id,
                          league_id: id,
                          p1_accepted: false,
                          p2_accepted: false,
                          game_id: game_id)
          i += 1
          j -= 1
        end

        # Now rotate the array to keep scheduling in a "round robin" fashion.
        arr.rotate!
      end
    end
  end

  # Returns an array sorted by Wins that contains each user's W-L-MP.
  def generate_user_standings(match_set)

    # Get the fighters for the season that the matches in match_set take place in.
    fighters = match_set.first.season.fighters

    # Set all user's W-L values to 0-0 and set matches played to 0.
    user_hashmap = {}
    fighters.each do |user_id|
      user_hashmap[User.find(user_id)] = [0,0,0]
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
      end
    end
    
    # Convert hashmap to an array that is sorted by Wins and then by MP.
    user_hashmap.to_a.sort_by{ |user| [ -user[1][0], -user[1][2] ] }
  end

  def start_playoffs
    # Create Challonge double elimination tournament through the Ruby API.
    t = Challonge::Tournament.new
    t.name = self.name + " Season " + self.current_season.number.to_s + " Playoffs"
    t.url = self.name.downcase.tr(' ', '_') + "_season_" + self.current_season.number.to_s + "_playoffs"
    t.tournament_type = 'double elimination'
    t.show_rounds = true
    
    if t.save

      # Add the participants to the tournament based on seeding during
      # regular season.
      seeded_users = self.generate_user_standings(self.current_season.matches)
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
      tournaments.create!(name: name + " Season " + current_season.number.to_s + " Playoffs",
                          league_id: id,
                          season_id: current_season.id,
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
