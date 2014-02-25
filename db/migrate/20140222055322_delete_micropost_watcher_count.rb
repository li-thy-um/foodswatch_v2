class DeleteMicropostWatcherCount < ActiveRecord::Migration
  def change
    remove_column :microposts, :watcher_count
  end
end
