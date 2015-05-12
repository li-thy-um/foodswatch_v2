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
      content = '' if content.nil?
      content.strip!
      if content == ''
        content = if !original_id.nil?
          '分享'
        elsif !comment_id.nil?
          nil
        else
          has_foods ? '我吃了:' : nil
        end
      end
    end
end
