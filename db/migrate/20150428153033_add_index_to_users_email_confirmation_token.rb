class AddIndexToUsersEmailConfirmationToken < ActiveRecord::Migration
  def up
    add_index :users, :email_confirmation_token
  end

  def down
    remove_index :users, :email_confirmation_token
  end
end
