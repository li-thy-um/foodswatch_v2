class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.integer :user_id
      t.integer :target_post_id
      t.integer :action_post_id
      t.boolean :read, default: false

      t.timestamps null: false
    end

    add_index :notices, :read
    add_index :notices, :user_id
    add_index :notices, [:user_id, :read]
  end
end
