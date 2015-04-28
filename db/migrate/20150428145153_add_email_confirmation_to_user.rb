class AddEmailConfirmationToUser < ActiveRecord::Migration
  def up
    add_column :users, :email_confirmed, :boolean, defalut: false
    add_column :users, :email_confirmation_token, :string, default: ''
  end

  def down
    remove_column :users, :email_confirmed
    remove_column :users, :email_confirmation_token
  end
end
