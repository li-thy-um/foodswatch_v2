class AddIndexToCommentAndOriginal < ActiveRecord::Migration
  def change
    add_index :microposts, :original_id
    add_index :microposts, :comment_id
  end
end
