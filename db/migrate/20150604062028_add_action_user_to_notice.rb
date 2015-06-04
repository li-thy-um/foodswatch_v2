class AddActionUserToNotice < ActiveRecord::Migration
  def change
    add_column :notices, :action_user_id, :integer
  end
end
