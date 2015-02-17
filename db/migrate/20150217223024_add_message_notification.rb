class AddMessageNotification < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :post_id
      t.string  :status
    
      t.timestamps null: false
    end
  end
end
