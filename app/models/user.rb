class User < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :leagues, :through => :memberships
  has_many :matches, :through => :leagues

  before_save { self.email = email.downcase }
  
  MAX_LENGTH_FIRST_NAME = 20
  MAX_LENGTH_LAST_NAME = 20
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  MIN_LENGTH_PASSWORD = 6
  MAX_LENGTH_TAGLINE = 60
  
  # Validations
  validates :first_name, presence: true, length: { maximum: MAX_LENGTH_FIRST_NAME }
  validates :last_name, presence: true, length: { maximum: MAX_LENGTH_LAST_NAME }
  validates :alias, presence: true
  validates :email, presence: true,
          format: { with: VALID_EMAIL_REGEX },
          uniqueness: { case_sensitive: false }
  validates :tagline, length: { maximum: MAX_LENGTH_TAGLINE }
  has_secure_password
  validates :password, length: { minimum: MIN_LENGTH_PASSWORD }

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
