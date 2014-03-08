$(init_chart);

function init_chart(){
  if($("#chart_test").val() == undefined){ return; }
  
  var option = {
    axisY : { title: "热量 (KCal)" },
    data : all_data(),
    toolTip: { content: function(e){
     return e.entries[0].dataSeries.name + " <strong>"+e.entries[0].dataPoint.y + "KCal"  ;
      }
    }
  }
  new CanvasJS.Chart("chart_test", option).render();
}

function all_data(){
  var types = [
    {name: "碳水热量", value: 1, color: "#46a546"},
    {name: "蛋白质热量", value: 2, color: "#9d261d"},
    {name: "脂肪热量", value: 3, color: "#ffc40d"}
  ];

  return types.map(function(t){
    return {
      type: "stackedColumn",
      showInLegend: "true",
      legendText: t.name,
      name: t.name,
      color: t.color,
      dataPoints: data_points(t.value)
    };
  }); 
}

function data_points(index){
  var data = get_data(index);
  var labs = labels();
  var points = labs.map(function(lab){
    return { y: "", label: lab } 
  });
  points.forEach(function(p, i){
    p.y = data[i];
  });
  return points;
}

function get_data(i){
  return $("#chart_data").val().split("_")[1].split("@")[i].split(",").map(
      function(x){ return parseInt(x) });
}

function labels(){
  return $('#chart_data').val().split("_")[0].split(",");
}
