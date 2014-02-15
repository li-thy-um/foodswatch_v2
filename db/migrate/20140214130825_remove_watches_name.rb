class RemoveWatchesName < ActiveRecord::Migration
  def change
    remove_column :watches, :name
  end
end
