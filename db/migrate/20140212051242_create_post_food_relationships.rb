class CreatePostFoodRelationships < ActiveRecord::Migration
  def change
    create_table :post_food_relationships do |t|
      t.integer :post_id
      t.integer :food_id

      t.timestamps
    end

  end
end
