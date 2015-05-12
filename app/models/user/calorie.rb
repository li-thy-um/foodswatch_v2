module User::Calorie

  DATA_TYPE = [:carb, :prot, :fat]

  #[c, p ,f]
  #time is end of the day.
  def data_of(day)
    posts = microposts_between(day.beginning_of_day, day.end_of_day)

    {
      carb: posts.inject(0) { |n, p| n + p.total_calorie_of(:carb) },
      prot: posts.inject(0) { |n, p| n + p.total_calorie_of(:prot) },
      fat: posts.inject(0) { |n, p| n + p.total_calorie_of(:fat) }
    }

  end

  def label_of(day)
    a = day.to_s.split(" ")[0].split("-")
    [a[1], a[2]].join("-")
  end

  def chart_string_of_day(num)
    start_day = Time.now.end_of_day.days_ago(num)
    labels = (1..num).map { |i| label_of start_day.advance(days: i) }
    data   = (1..num).map { |i| data_of  start_day.advance(days: i) }
    {
      labels: labels,
      carb: data.map { |d| d[:carb] },
      prot: data.map { |d| d[:prot] },
      fat: data.map { |d| d[:fat] }
    }
  end

  def calorie_today
    microposts_today.inject(0) { |t, post| t + post.total_calorie }
  end

end
