class Post < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }
  belongs_to :postable, polymorphic: true
  belongs_to :subjectable, polymorphic: true
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :action, presence: true
  validates :postable_id, presence: true
  validates :postable_type, presence: true
end
