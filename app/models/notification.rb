class Notification < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }
  belongs_to :sendable, polymorphic: true
  belongs_to :receiver, class_name: "User"
  belongs_to :targetable, polymorphic: true

  validates :sendable_id, presence: true
  validates :sendable_type, presence: true
  validates :receiver_id, presence: true
  validates :targetable_id, presence: true
  validates :targetable_type, presence: true
  validates :action, presence: true
  validates_inclusion_of :read, in: [true, false]

  def self.unread
    where(read: false)
  end
end
