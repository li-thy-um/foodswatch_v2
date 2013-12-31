$(function(){
  var $micropost_content = $("#micropost_content");
  $micropost_content.keypress(change_surplus).keypress();
});

var change_surplus = function() {
  var max_length = 140;
  var content_length = $("#micropost_content").val().length;
  var surplus = max_length - content_length;
 
  // change number text.
  $("#surplus_count").text(surplus);
  
  // change the color. 
  var $text = $("#surplus_count");
  if($text.hasClass("surplus-negative") && surplus > 0){
    $text.removeClass("surplus-negative");
  }
  if(surplus < 0){ 
    $text.addClass("surplus-negative");
  } 
}
