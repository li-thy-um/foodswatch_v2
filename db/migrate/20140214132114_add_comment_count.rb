class AddCommentCount < ActiveRecord::Migration
  def change
    add_column :microposts, :comment_count, :integer, default: 0
  end
end
