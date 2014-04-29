class Post < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }
  belongs_to :postable, polymorphic: true
  validates :action, presence: true
  validates :postable_id, presence: true
  validates :postable_type, presence: true
end
