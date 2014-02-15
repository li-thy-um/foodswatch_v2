class RemoveWatcherCount < ActiveRecord::Migration
  def change
    remove_column :watches, :watcher_count
  end
end
