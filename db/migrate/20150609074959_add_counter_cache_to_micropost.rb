class AddCounterCacheToMicropost < ActiveRecord::Migration
  def self.up
    add_column :microposts, :likes_count, :integer, default: 0
    add_column :microposts, :comments_count, :integer, default: 0

    Micropost.reset_column_information
    Micropost.all.each do |m|
      m.update_attribute :likes_count, m.likes.length
      m.update_attribute :comments_count, m.comments.length
    end
  end

  def self.down
    remove_column :microposts, :likes_count
    remove_column :microposts, :comments_count
  end
end
