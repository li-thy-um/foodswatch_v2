class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  has_many :likes, dependent: :destroy
  has_many :post_food_relationships, foreign_key: :post_id, dependent: :destroy
  has_many :foods, through: :post_food_relationships
  has_many :comments, foreign_key: :comment_id, class_name: :Micropost, dependent: :destroy

  before_validation { content.strip! }

  validates_presence_of :content, message: "微博内容不能为空。"
  validates_length_of :content, maximum: 140, message: "微博长度不能超过140字符。"

  include MicropostCreator

  def total_calorie
    total_calorie_of :calorie
  end

  def total_calorie_of(type)
    self.foods.inject(0) { |c, f| c + f.calorie_of(type) }
  end

  def watcher_count
    return 0 if post_food == nil
    @post_food.watcher_count
  end

  def post_food
    @post_food = Food.find_by_id(post_food_id)
  end

  def shares
    Micropost.where("shared_id = :id OR original_id = :id", id: id)
  end

  def original_post
    Micropost.find_by_id(original_id)
  end

  def self.from_users_followed_by(user)
    arr_users = Relationship.where("follower_id = ?", user).map(&:followed_id) + [user.id]
    rel_users = User.where(id: arr_users)
    where(id: rel_users.map(&:microposts).flatten.map(&:id))
  end
end
