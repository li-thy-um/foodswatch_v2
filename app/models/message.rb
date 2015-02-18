class Message < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :user
  validates :post_id, presence: true
  validates :user_id, presence: true
  validates :status, inclusion: { in: %w(read send) }
end
