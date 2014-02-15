class FixMistakePostFoodIdDefault < ActiveRecord::Migration
  def change
    change_column_default :microposts, :post_food_id, nil  
  end
end
