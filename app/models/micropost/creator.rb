module Micropost::Creator

  def save_with_foods(foods_params)
    setup_content foods_params.any?
    save!
    create_notice
    (foods_params || []).map { |f| Food.find_by_id(f[:id]) or Food.create!(f) }.each do |f|
      post_food_relationships.create!(food_id: f.id)
      user.watch! f
    end
  end

  private

  def create_notice
    action_user = self.user
    case self.type
    when :share
      target_user_original = self.original_post.user
      if action_user.id != target_user_original.id
        target_user_original.notices.create! target_post_id: self.original_id, action_post_id: self.id
      end
      target_user_shared = self.shared_post.user
      if action_user.id != target_user_shared.id && self.shared_id != self.original_id
        target_user_shared.notices.create! target_post_id: self.shared_id, action_post_id: self.id
      end
    when :comment
      target_user = self.comment_post.user
      if action_user.id != target_user.id
        target_user.notices.create! target_post_id: self.comment_id, action_post_id: self.id
      end
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
