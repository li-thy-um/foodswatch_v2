class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :micropost, counter_cache: true
  validates :user_id, presence: true
  validates :micropost_id, presence: true
end
