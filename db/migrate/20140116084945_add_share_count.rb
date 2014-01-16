class AddShareCount < ActiveRecord::Migration
  def change
    add_column :microposts, :shared_id, :integer  
    add_column :microposts, :share_count, :integer, default: 0  
  end
end
