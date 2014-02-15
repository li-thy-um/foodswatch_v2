class AddFoodIdToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :food_id, :integer
  end
end
