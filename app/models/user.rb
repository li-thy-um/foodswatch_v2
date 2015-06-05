class User < ActiveRecord::Base
  has_many :likes, dependent: :destroy
  has_many :notices, dependent: :destroy
  has_many :watches, dependent: :destroy
  has_many :watched_foods, through: :watches, source: :food
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followed_users, -> { order('relationships.created_at desc') }, through: :relationships, source: :followed
  has_many :followers,  -> { order('relationships.created_at desc') }, through: :reverse_relationships

  before_validation { name and name.strip! }
  before_validation { email and email.strip! }
  before_validation { password and password.strip! }
  before_save { self.email.downcase! }
  before_create :create_remember_token

  VLID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates_presence_of :name, message: "用户名不能为空。"
  validates_length_of :name, maximum: 20, message: "用户名长度不能超过20字符。"
  validates_format_of :name, with: /\A\p{Word}*\z/, message: "用户名不能包含标点符号。"
  validates_uniqueness_of :name, case_sensitive: true, message: "用户名已经被注册了。"
  validates_presence_of :email, message: "电子邮件不能为空。"
  validates_format_of :email, with: VLID_EMAIL_REGEX, message: "电子邮件地址格式不正确。"
  validates_uniqueness_of :email, case_sensitive: false, message: "电子邮件地址已经被注册了。"
  validates_length_of :password, minimum: 6, message: "密码长度不能少于6字符。"

  include User::Avatar
  include User::Calorie
  extend User::Token
  extend Decorator

  in_transaction :like!, :cancel_like!

  has_secure_password

  def like!(micropost_id)
    micropost = Micropost.find micropost_id
    like = self.likes.create! micropost_id: micropost_id
    # Noitce the poster if the poster is not self.
    unless micropost.nil? || micropost.user_id == self.id
      micropost.user.notices.create!({
        action_user_id: self.id,
        target_post_id: micropost_id,
        action_post_id: micropost_id,
        notice_type: :like
      })
    end
    like
  end

  def cancel_like!(like_id)
    like = Like.find(like_id).destroy!
    post = like.micropost
    notice = Notice.find_by({
      notice_type: :like,
      user_id: post.user,
      target_post_id: post.id,
      action_post_id: post.id,
      action_user_id: self.id
    })
    notice && notice.destroy!
    like
  end

  def destroy
    remove_avatar_file! if avatar
    super
  end

  # authentiacte_token for API
  def auth_token
    remember_token
  end

  def clear_change_password_token
    update_attribute :change_password_token, nil
    update_attribute :change_password_at, nil
  end

  def update_change_password_token
    update_attribute :change_password_token, User.encrypted_random_token
    update_attribute :change_password_at, Time.zone.now
  end

  def update_email_confirmation_token
    update_attribute :email_confirmation_token, User.encrypted_random_token
  end

  def liking?(micropost)
    likes.find_by(micropost_id: micropost.id)
  end

  def watching?(food)
    !watch_for(food).nil?
  end

  def watch!(food)
    watches.create!(food_id: food.id) unless watching? food
  end

  def unwatch!(food)
    watch = watch_for(food)
    watch && watch.destroy
  end

  def following?(other_user)
    !relationship_with(other_user).nil?
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id) unless following? other_user
  end

  def unfollow!(other_user)
    relationship = relationship_with(other_user)
    relationship and relationship.destroy
  end

  def confirm_email
    update_attribute :email_confirmation_token, ''
    update_attribute :email_confirmed, true
  end

  def feed
    Micropost.from_users_followed_by(self).normal
  end

  def microposts_today
    now = Time.now
    microposts_between(now.beginning_of_day, now)
  end

  def microposts_between(b, e)
    self.microposts.where(":begin < created_at and created_at < :end", begin: b, end: e)
  end

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  private

    def watch_for(food)
      watches.find_by(food_id: food.id)
    end

    def relationship_with(other_user)
      relationships.find_by(followed_id: other_user.id)
    end
end
