class AddPostWatcherCount < ActiveRecord::Migration
  def change
    add_column :microposts, :watcher_count, :integer, default: 0
  end
end
