class Micropost < ActiveRecord::Base
  include Micropost::Creator
  extend Decorator

  scope :normal, -> { where(comment_id: nil) }
  default_scope -> { order('created_at DESC') }
  belongs_to :user
  belongs_to :comment_post, foreign_key: :comment_id, class_name: :Micropost, counter_cache: :comments_count
  belongs_to :shared_post, foreign_key: :shared_id, class_name: :Micropost, counter_cache: :share_count
  belongs_to :original_post, foreign_key: :original_id, class_name: :Micropost

  has_many :post_food_relationships, foreign_key: :post_id, dependent: :destroy
  has_many :foods, through: :post_food_relationships

  has_many :likes, dependent: :destroy
  has_many :comments, foreign_key: :comment_id, class_name: :Micropost, dependent: :destroy
  has_many :shares, foreign_key: :shared_id, class_name: :Micropost

  has_many :action_notices, foreign_key: :action_post_id, class_name: :Notice, dependent: :destroy
  has_many :target_notices, foreign_key: :target_post_id, class_name: :Notice, dependent: :destroy

  before_validation { content and content.strip! }

  validates_presence_of :user_id, message: "用户不能为空。"
  validates_presence_of :content, message: "微博内容不能为空。"
  validates_length_of :content, maximum: 140, message: "微博长度不能超过140字符。"

  in_transaction :save_with_foods

  def type
    case
    when original_id?
      :share
    when comment_id?
      :comment
    else
      :create
    end
  end

  def total_calorie
    total_calorie_of :calorie
  end

  def total_calorie_of(type)
    self.foods.inject(0) { |c, f| c + f.calorie_of(type) }
  end

  def self.from_users_followed_by(user)
    user_ids = user.followed_users.map(&:id) + [user.id]
    where(user_id: user_ids)
  end

end
