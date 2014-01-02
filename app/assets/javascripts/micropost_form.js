$(function(){
  var $micropost_content = $("#micropost_content");
  $micropost_content.keypress(change_surplus).keypress();
  $micropost_content.keyup(change_surplus);
});

var change_surplus = function() {
  var surplus = 140 - $("#micropost_content").val().length;
    //surplus = max_length - content_length
  var $text = $("#surplus_count");
  
  // change number text.
  $text.text(surplus);
  
  // change the color. 
  var red = $text.hasClass("surplus-negative");
  if(red && surplus > 0){
    $text.removeClass("surplus-negative");
  }
  if(!red && surplus <= 0){ 
    $text.addClass("surplus-negative");
  } 
}
