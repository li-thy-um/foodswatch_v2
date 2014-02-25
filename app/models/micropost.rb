class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  before_validation :trim_content
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  has_many :post_food_relationships, foreign_key: :post_id, dependent: :destroy
  has_many :foods, through: :post_food_relationships
  after_create :add_share_count
  after_destroy :minus_share_count

  def shared_by(user)
    Micropost.where("original_id = #{self.id} AND user_id = #{user.id}").first
  end

  def watcher_count
    return 0 if post_food == nil
    @post_food.watcher_count
  end

  def post_food
    @post_food = Food.find_by_id(self.post_food_id)
  end

  def shares
    Micropost.where("shared_id = #{self.id}")
  end

  def comments
    Micropost.where("comment_id = #{self.id}").order('created_at DESC')  
  end

  def original_post
    Micropost.where("id = #{self.original_id}").first
  end

  def attach!(food)
    post_food_relationships.create!(food_id: food.id) 
  end

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids})
      OR user_id = :user_id",
      user_id: user)
  end

  private
    
    def trim_content
      self.content = self.content.rstrip.lstrip
    end

    def minus_share_count
      change_share_count(:minus)
    end

    def add_share_count
      change_share_count(:add)
    end

    def change_share_count (type)
      change_ids = Array.new
      change_ids << self.original_id 
      change_ids << self.shared_id
      change_ids.compact!
      return if change_ids.empty?
      Micropost.find(change_ids).each do |micropost|
        micropost.share_count = 0 if micropost.share_count == nil
        micropost.share_count += 1 if type == :add
        micropost.share_count -= 1 if type == :minus
        micropost.save
      end 
    end
end
