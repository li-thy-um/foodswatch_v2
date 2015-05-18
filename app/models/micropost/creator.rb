module Micropost::Creator

  def save_with_foods(foods_params)
    setup_content foods_params.any?
    save!
    (foods_params || []).map { |f| Food.find_by_id(f[:id]) or Food.create!(f) }.each do |f|
      post_food_relationships.create!(food_id: f.id)
      user.watch! f
    end
  end

  private

  def setup_content(has_foods)
    content = self.content || ''
    content.strip!
    return unless content == ''
    self.content = case self.type
    when :share
      '分享'
    when :comment
      nil
    when :create
      has_foods ? '我吃了:' : nil
    end
  end
end
