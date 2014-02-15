class PostFoodRelationship < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :food
  validates :post_id, presence: true
  validates :food_id, presence: true
end
