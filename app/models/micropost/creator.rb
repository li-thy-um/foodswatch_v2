module Micropost::Creator

  def save_with_foods(foods_params)
    self.has_foods = foods_params.any?
    setup_content self.has_foods
    save!
    create_notice
    (foods_params || []).map { |f| Food.find_by_id(f[:id]) or Food.create!(f) }.each do |f|
      post_food_relationships.create!(food_id: f.id)
      user.watch! f
    end
  end

  private

  def create_notice
    notice_hash = {
      action_user_id: self.user_id,
      action_post_id: self.id
    }

    # if it's share or comment, notice the original poster.
    case self.type
    when :share
      target_user_original = self.original_post.user
      if self.user_id != target_user_original.id
        target_user_original.notices.create! notice_hash.merge({target_post_id: self.original_id})
      end
      target_user_shared = self.shared_post.user
      if self.user_id != target_user_shared.id && self.shared_id != self.original_id
        target_user_shared.notices.create! notice_hash.merge({target_post_id: self.shared_id})
      end
    when :comment
      target_user = self.comment_post.user
      if self.user_id != target_user.id
        target_user.notices.create! notice_hash.merge({target_post_id: self.comment_id})
      end
    end

    # if it contains @username and the username doesn't refer to the poster, notice the relative user.
    usernames = self.content.scan(/(?<=@)\p{Word}+/)
    # if a post contains the same username more than one time, only notice once for that user.
    usernames.uniq.each do |name|
      user = User.find_by(name: name)
      user && user.id != self.user_id and
      user.notices.create! notice_hash.merge({
        target_post_id: self.id,
        notice_type: :at
      })
    end
  end

  def setup_content(has_foods)
    content = self.content || ''
    content.strip!
    return unless content == ''
    self.content = case self.type
    when :share
      '分享：'
    when :comment
      nil
    when :create
      has_foods ? '我吃了：' : nil
    end
  end
end
