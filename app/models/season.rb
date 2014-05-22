class Season < ActiveRecord::Base
  default_scope -> { order('number') }

  # Associations
  belongs_to :league
  has_many :matches
  has_many :tournaments

  # Validations
  validates :number, presence: true
  validates_inclusion_of :current_season, in: [true, false]
  validates :fighters, presence: true
end
