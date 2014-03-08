$(display_chart);

function display_chart(){
  if ($("#chart_large").html() == undefined) { return }
  var ctx = $("#chart_large").get(0).getContext("2d");
  var data = {
    labels : labels(),
    datasets : datasets() 
  }
  var chart_large = new Chart(ctx).Bar(data, {scaleLabel: "<%=value%> kCal"});
}

function labels(){
  return $('#chart_data').val().split("_")[0].split(",");
}

function datasets(){
  return ["calorie", "carb", "prot", "fat"].
    map(function(x){ return generate(x) });
}

function generate(type){
  var opt = {
    "calorie": { color: "255,64,64",   data: get_data(0) },
    "carb":    { color: "0,255,127",   data: get_data(1) },
    "prot":    { color: "152,245,255", data: get_data(2) },
    "fat":     { color: "255,236,139", data: get_data(3) }
  }
  return {
    title : "title",
    fillColor :   color_str(opt[type].color, "1"),
    strokeColor : color_str(opt[type].color, "1"),
    pointColor :  color_str(opt[type].color, "1"),
    pointStrokeColor : "#000",
    data : opt[type].data
  };
}

function get_data(i){
  return $("#chart_data").val().split("_")[1].split("@")[i].split(",").map(
      function(x){ return parseInt(x) });
}

function color_str(color, aero){
  return "rgba(" + color + "," + aero +")";
}
