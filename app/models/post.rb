class Post < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }
  belongs_to :postable, polymorphic: true
  belongs_to :league
  belongs_to :match
  belongs_to :bet
  validates :action, presence: true
  validates :postable_id, presence: true
  validates :postable_type, presence: true
end
