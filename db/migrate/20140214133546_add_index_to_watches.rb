class AddIndexToWatches < ActiveRecord::Migration
  def change
    add_index :watches, :food_id
    add_index :watches, :user_id
  end
end
