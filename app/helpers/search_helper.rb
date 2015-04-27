module SearchHelper
  def search_label(key)
    {
      micropost: "微博",
      user: "用户",
      food: "食物"
    }[key]
  end
end
