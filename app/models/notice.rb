class Notice < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }
  scope :unread, -> { where('read = false') }
  belongs_to :user
  belongs_to :target_post, class_name: :Micropost
  belongs_to :action_post, class_name: :Micropost
  validates_presence_of :user_id
  validates_presence_of :target_post_id
  validates_presence_of :action_post_id
end
