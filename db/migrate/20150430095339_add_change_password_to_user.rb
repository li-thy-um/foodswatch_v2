class AddChangePasswordToUser < ActiveRecord::Migration
  def up
    add_column :users, :change_password_token, :string, default: nil
    add_column :users, :change_password_at, :timestamp, default: nil
  end

  def donw
    remove_column :user, :change_password_token
    remove_column :user, :change_password_at
  end
end
