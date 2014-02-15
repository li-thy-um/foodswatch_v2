class Food < ActiveRecord::Base
  has_many :post_food_relationships, dependent: :destroy
  has_many :microposts, through: :post_food_relationships, source: :post 
  has_many :watches, dependent: :destroy
  has_many :watchers, through: :watches, source: :user
  before_save :set_calorie

  def watcher_count
    watchers.size 
  end

  def nutri_info
    { 
      prot:    self.prot,
      carb:    self.carb,
      fat:     self.fat,
      calorie: self.calorie
    }  
  end

  private
    
    def set_calorie
      self.calorie = compute_calorie(self.prot || 0,
                                     self.carb || 0,
                                     self.fat  || 0)
    end

    def compute_calorie(prot, carb, fat)
      prot * 4 + carb * 4 + fat * 9
    end
end
