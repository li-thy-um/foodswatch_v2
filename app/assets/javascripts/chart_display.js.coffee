$(document).on 'ready page:load', () ->
  if $('#chart_test').length
    new CalorieChart('chart_test').render()

class CalorieChart
  constructor: (target_id) ->
    @option =
      toolTip:
        content:
          (e) ->
            e.entries[0].dataSeries.name + " <strong>"+e.entries[0].dataPoint.y + "KCal"

    @target_id = target_id

  render: () =>
    $.get 'calorie.json', (data) =>
      @data = data
      @option.data = @transform_data()
      new CanvasJS.Chart(@target_id, @option).render()

  transform_data: () =>
    [
      { name: "碳水热量", type: 'carb', color: "#5cb85c" }
      { name: "蛋白质热量", type: 'prot', color: "#d9534f" }
      { name: "脂肪热量", type: 'fat', color: "#f0ad4e" }
    ].map (t) =>
      type: "stackedColumn",
      showInLegend: "true",
      legendText: t.name,
      name: t.name,
      color: t.color,
      dataPoints: @data_points(t.type)

  data_points: (type) =>
    @data['labels'].map (lab, i) =>
      label: lab
      y: @data[type][i]
