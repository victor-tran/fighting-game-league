class User < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :leagues, :through => :memberships
  has_many :p1_matches, class_name: 'Match', foreign_key: 'p1_id'
  has_many :p2_matches, class_name: 'Match', foreign_key: 'p2_id'
  has_many :bets, foreign_key: 'better_id'
  def matches
    p1_matches + p2_matches
  end

  before_save { self.email = email.downcase }
  
  MAX_LENGTH_FIRST_NAME = 20
  MAX_LENGTH_LAST_NAME = 20
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  MIN_LENGTH_PASSWORD = 6
  MAX_LENGTH_TAGLINE = 60
  MAX_LENGTH_BIO = 2500

  # Paperclip image stuff.
  has_attached_file :avatar, 
    styles: {
      thumb: '80x80#',
      square: '160x160#',
      medium: '300x300>',
      large: '500x500>'
    }, 
    :default_url => "/images/:style/missing.png"

  # Validates that the attached image is jpg or png.
  validates_attachment :avatar,
    :content_type => { :content_type => ["image/jpg", "image/png", "image/jpeg", "image/gif"] }
  
  # Validations
  validates :first_name, presence: true, length: { maximum: MAX_LENGTH_FIRST_NAME }
  validates :last_name, presence: true, length: { maximum: MAX_LENGTH_LAST_NAME }
  validates :alias, presence: true
  validates :email, presence: true,
          format: { with: VALID_EMAIL_REGEX },
          uniqueness: { case_sensitive: false }
  validates :tagline, length: { maximum: MAX_LENGTH_TAGLINE }
  validates :bio, length: { maximum: MAX_LENGTH_BIO }
  validates :fight_bucks, presence: true
  has_secure_password
  validates :password, length: { minimum: MIN_LENGTH_PASSWORD }

  # Returns "first_name 'alias' last_name" of given User.
  def full_name
    first_name + " '" + self.alias + "' " + last_name
  end

  # Returns true if current user is a member of given league.
  def memberOf?(league)
    memberships.find_by(league_id: league.id)
  end
  
  # Adds league to current user's list of leagues.
  def join!(league)
    memberships.create!(league_id: league.id)
  end
  
  # Removes league from current user's list of leagues.
  def leave!(league)
    memberships.find_by(league_id: league.id).destroy!
  end

  # Returns true if current user bet on match.
  def betting_on?(match)
    bets.find_by(match_id: match.id, better_id: id)
  end

  # Adds bet to current_user.bets
  def bet!(match, favorite, wager)
    bets.create!(match_id: match.id, favorite_id: favorite.id, wager_amount: wager)
    self.update_attribute(:fight_bucks, self.fight_bucks - (wager))
  end

  # Returns true if current user is fighting in match.
  def fighting_in?(match)
    self.id == match.p1_id || self.id == match.p2_id
  end


  # Return set of matches that the user has to play in the
  # current rounds of each league.
  def current_matches
    my_current_matches = Set.new

    leagues.each do |league|
      
      if league.matches != []

        # In each league's set of matches, find the match where the 
        # current_user is either player 1 or 2 and where the current
        # round is equal to the league's current round and the current
        # season is equals to the league's current season.
        current_match = league.matches.where(
          "round_number = ? AND season_number = ? AND p1_id = ? OR p2_id = ?", 
          league.current_round, league.current_season_number, id, id).first

        unless current_match == nil 
          my_current_matches.add(current_match)
        end
      end

    end

    my_current_matches
  end

  # Returns overall W-L fighter history.
  def overall_WL
    wins = 0
    losses = 0

    matches.each do |match|
      if match.p1_accepted == true && match.p2_accepted == true
        if match.winner_id == id
          wins += 1
        else
          losses += 1
        end
      end
    end

    wins.to_s + "-" + losses.to_s
  end

  # Returns current match streak.
  def current_streak

    # Decided matches must be sorted by accepted date.
    decided_matches = matches.reject! { |match| match.finalized_date == nil }.sort_by &:finalized_date

    if decided_matches != []
      streak = 0

      if decided_matches.first.winner_id == id
        winning_streak = true
      else
        winning_streak = false
      end


      # Winning streak loop
      if winning_streak

        while winning_streak do
          
          decided_matches.each do |match|
          
            if match.winner_id == id
              streak += 1
            else
              winning_streak = false
              break
            end
          end

          winning_streak = false
          break
        end
      
      # Losing streak loop
      else

        until winning_streak do
          
          decided_matches.each do |match|
          
            if match.winner_id == id
              winning_streak = true
              break
            else              
              streak += 1
            end

          end

          winning_streak = true
          break
        end

      end

      # Return winning streak
      if !winning_streak
        "W" + streak.to_s

      # Return losing streak
      else
        "L" + streak.to_s
      end
    
    # User doesn't have any decided matches yet.
    else
      0
    end
  end

  # Returns the longest match win streak.
  def longest_win_streak_ever

    # Decided matches must be sorted by accepted date.
    decided_matches = matches.reject! { |match| match.finalized_date == nil }.sort_by &:finalized_date

    if decided_matches != []
      longest_streak = 0
      streak = 0

      decided_matches.each do |match|
        if match.winner_id == id
          streak += 1
          if streak > longest_streak
            longest_streak = streak
          end

        else
          streak = 0
        end

      end

      longest_streak
    
    # User doesn't have any decided matches yet.
    else
      0
    end
  end

  # Returns a list of all pending matches for user.
  def pending_matches

    # Set of matches to be returned
    pending_matches = Set.new

    matches.each do |match|
      if match.round_number == League.find(match.league_id).current_round

        # Add to pending matches if character hasn't been set yet.
        if id == match.p1_id && match.p1_character == nil
          pending_matches.add(match)
        elsif id == match.p2_id && match.p2_character == nil
          pending_matches.add(match)

        # Add to pending matches if date has not been set yet.
        elsif match.match_date == nil
          pending_matches.add(match)

        # Add to pending matches if matches have NOT been accepted by user yet.
        elsif id == match.p1_id && match.p1_accepted == false
          pending_matches.add(match)
        elsif id == match.p2_id && match.p2_accepted == false
          pending_matches.add(match)
        end

      end
    end

    pending_matches
  end

  # Return list of disputed matches for all leagues that the current user
  # is a commissioner for.
  def league_disputes
    commissioned_leagues = leagues.where("commissioner_id = ?", id)

    disputed_matches = Set.new

    commissioned_leagues.each do |league|
      disputed_matches = disputed_matches + league.matches.where("disputed = ?", true)
    end

    disputed_matches
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  private  
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
