class User < ActiveRecord::Base
  has_many :likes
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
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: true }
  VLID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VLID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  def liking?(micropost)
    likes.find_by(micropost_id: micropost.id)
  end

  def like!(micropost)
    likes.create!(micropost_id: micropost.id)
  end

  def chart_string_of_day(num)
    start_day = Time.now.end_of_day.days_ago(num)
    labels = (1..num).map { |i| label_of start_day.advance(days: i) }
    data   = (1..num).map { |i| data_of  start_day.advance(days: i) }

    data = (0...data_type.size).inject([]) do |l, k|
      l << (0...num).inject([]) { |a, i| a << data[i][k] }.join(",")
    end
    [labels.join(","), data.join("@")].join("_")
      #"1,2,3_1786,1589,1645@1500,1450,1505@705,468,809@507,609,604"
  end

  def calorie_today
    microposts_today.inject(0) { |t, post| t + post.total_calorie }
  end

  def commenting?(post)
    post.comments.find_by_user_id(self.id)
  end

  def sharing?(post)
    post.shares.find_by_user_id(self.id)
  end

  def watching?(food)
    watches.find_by(food_id: food.id)
  end

  def watch!(food)
    watches.create!(food_id: food.id)
  end

  def unwatch!(food)
    watches.find_by(food_id: food.id).destroy
  end

  def watch_list_string()
    watched_foods.map do |food|
      if food.name && food.name != ""
        [food.id, food.name].join("_")
      else
        nil
      end
    end.compact.join(",")
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
    arr_post_id = followed_posts.map(&:id)
    arr_filtered_id = followed_posts.select do |po|
      po.comment_id.nil?
    end.map(&:id)
    Micropost.where(id: arr_filtered_id)
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def data_type
      [:calorie, :carb, :prot, :fat]
    end

    #[cal, c, p ,f]
    #time is end of the day.
    def data_of(day)
      posts = microposts_between(day.beginning_of_day, day.end_of_day)
      data_type.inject([]) do |d, t|
        d << posts.inject(0) { |n, p| n + p.total_calorie_of(t) }
      end
    end

    def label_of(day)
      a = day.to_s.split(" ")[0].split("-")
      [a[1], a[2]].join("-")
    end

    def microposts_today
      now = Time.now
      microposts_between(now.beginning_of_day, now)
    end

    def microposts_between(b, e)
      self.microposts.where(
        ":begin < created_at and created_at < :end", begin: b, end: e)
    end

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
