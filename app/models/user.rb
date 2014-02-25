class User < ActiveRecord::Base
  has_many :watches, dependent: :destroy
  has_many :watched_foods, through: :watches, source: :food
  has_many :microposts, -> { where("comment_id is NULL") }, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships
  before_save { self.email.downcase! }
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  VLID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VLID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  def commenting?(post)
    post.comments.find_by_user_id(self.id)  
  end

  def sharing?(post)
    post.shares.find_by_user_id(self.id) 
  end

  def watch!(food)
    watches.create!(food_id: food.id)
  end

  def unwatch!(food)
    watches.find_by(food_id: food.id).destroy
  end

  def watching?(food)
    watches.find_by(food_id: food.id) 
  end
  
  def watch_list_string()
    list = Array.new
    watched_foods.each do |food|
      list << [food.id, food.name].join("_") if food.name && food.name != ""
    end
    list.join(",")
    ##"1_辣椒炒肉,11_辣椒炒蛋,2_糖醋排骨,3_汤大份"
  end

  def following?(other_user)
    return false if other_user == nil
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end
  
  def feed
    followed_posts = Micropost.from_users_followed_by(self)
    followed_posts.where("original_id is NULL
      OR (original_id not IN (:followed_posts) AND user_id != :user_id)",
      followed_posts: followed_posts, user_id: self).
    where("comment_id is NULL")
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
