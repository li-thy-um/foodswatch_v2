class DeleteColumnSubFoodsFoodId < ActiveRecord::Migration
  def change
    remove_column :microposts, :food_id
    remove_column :foods, :sub_foods
  end
end
