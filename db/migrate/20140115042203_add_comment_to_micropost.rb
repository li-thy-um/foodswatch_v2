class AddCommentToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :comment_id, :integer
  end
end
