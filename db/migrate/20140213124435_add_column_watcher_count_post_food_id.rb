class AddColumnWatcherCountPostFoodIdCommentCount < ActiveRecord::Migration
  def change
    add_column :watches, :watcher_count, :integer
    add_column :microposts, :post_food_id, :integer, default: 0
      # Mistake
  end
end
