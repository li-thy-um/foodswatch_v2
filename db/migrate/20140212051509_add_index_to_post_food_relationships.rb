class AddIndexToPostFoodRelationships < ActiveRecord::Migration
  def change
    add_index :post_food_relationships, :post_id
    add_index :post_food_relationships, :food_id
  end
end
