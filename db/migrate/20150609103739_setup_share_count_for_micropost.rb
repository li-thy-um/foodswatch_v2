class SetupShareCountForMicropost < ActiveRecord::Migration
  def change
    Micropost.all.each do |m|
      m.update_attribute :share_count, m.shares.length
    end
  end
end
