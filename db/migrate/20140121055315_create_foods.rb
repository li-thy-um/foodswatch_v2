class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string  :name       
      t.integer :weight     # g
      t.integer :protein    # g
      t.integer :carb       # g
      t.integer :fat        # g
      t.integer :calorie    # kCal
      t.string  :info       # For other food-info, may use xml literal. 
      t.string  :sub_foods  
        # String like "#food_id_1#food_id_2" order by post content.
      
      t.timestamps
    end
  end
end
