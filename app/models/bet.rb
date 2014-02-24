class Bet < ActiveRecord::Base
  belongs_to :match
  belongs_to :better, class_name: 'User'
  belongs_to :favorite, class_name: 'User'

  validates_numericality_of :wager_amount, :greater_than => 0
end
