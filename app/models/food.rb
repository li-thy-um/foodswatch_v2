class Food < ActiveRecord::Base
  has_many :post_food_relationships, dependent: :destroy
  has_many :microposts, through: :post_food_relationships, source: :post
  has_many :watches, dependent: :destroy
  has_many :watchers, through: :watches, source: :user

  before_save :set_calorie

  def watch_of(user)
    watches.find_by_user_id(user)
  end

  def calorie_of(type)
    self[type] ? self[type] * unit_calorie_of[type] : 0
  end

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

    def unit_calorie_of
      { calorie: 1, prot: 4, carb: 4, fat: 9 }
    end

    def set_calorie
      self.calorie = [:prot, :carb, :fat].inject(0) { |c, t| c + calorie_of(t) }
    end
end
