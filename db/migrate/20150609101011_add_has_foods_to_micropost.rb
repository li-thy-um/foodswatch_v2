class AddHasFoodsToMicropost < ActiveRecord::Migration
  def up
    add_column :microposts, :has_foods, :boolean, default: false
    Micropost.reset_column_information
    Micropost.all.each do |m|
      m.update_attribute :has_foods, m.foods.size > 0
    end
  end

  def down
    remove_column :microposts, :has_foods
  end
end
