class User < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :leagues, :through => :memberships
  has_many :matches, :through => :leagues

  # Betting associations
  has_many :bets, foreign_key: 'better_id'
  has_many :favorites, through: :bets
  has_many :reverse_bets, foreign_key: 'favorite_id',
                          class_name:  'Bet',
                          dependent: :destroy
  has_many :betters, through: :reverse_bets, source: :better

  before_save { self.email = email.downcase }
  
  MAX_LENGTH_FIRST_NAME = 20
  MAX_LENGTH_LAST_NAME = 20
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  MIN_LENGTH_PASSWORD = 6
  MAX_LENGTH_TAGLINE = 60
  MAX_LENGTH_BIO = 2500
  
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
  def bet!(match, favorite)
    bets.create!(match_id: match.id, favorite_id: favorite.id)
    self.update_attribute(:fight_bucks, self.fight_bucks - 1)
  end

  # Returns true if current user is fighting in match.
  def fighting_in?(match)
    self.id == match.p1_id || self.id == match.p2_id
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
