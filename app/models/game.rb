class Game < ActiveRecord::Base
  has_many :characters, dependent: :destroy

  validates :name, presence: true
  validates :logo, presence: true
end
