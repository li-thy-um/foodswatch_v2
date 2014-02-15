class User < ActiveRecord::Base
  has_many :watches, dependent: :destroy
  has_many :watched_foods, through: :watches, source: :food
  has_many :microposts, dependent: :destroy
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

  def watch!(food)
    watches.create!(food_id: food.id) 
  end

  def unwatch!(food)
    watches.find_by(food_id: food.id).destroy
  end

  def watch_list_string()
    list = Array.new
    watched_foods.each do |food|
      list << [food.id, food.name].join("_")
    end
    list.join(",")
    ##"1_辣椒炒肉,11_辣椒炒蛋,2_糖醋排骨,3_汤大份"
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end
  
  def feed
    Micropost.from_users_followed_by(self)
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
