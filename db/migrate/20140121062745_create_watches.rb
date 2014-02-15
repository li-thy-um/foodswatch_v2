class CreateWatches < ActiveRecord::Migration
  def change
    create_table :watches do |t|
      t.string  :name
      t.integer :user_id
      t.integer :food_id

      t.timestamps
    end
  end
end
