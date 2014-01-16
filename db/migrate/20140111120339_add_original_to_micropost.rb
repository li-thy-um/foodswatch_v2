class AddOriginalToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :original_id, :integer
  end
end
