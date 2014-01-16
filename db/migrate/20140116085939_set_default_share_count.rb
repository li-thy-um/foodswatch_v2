class SetDefaultShareCount < ActiveRecord::Migration
  def change
    change_column :microposts, :share_count, :integer, default: 0
  end
end
