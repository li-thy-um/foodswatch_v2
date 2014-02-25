$(function(){
  var $input = $(".letter_count");
  $input.keypress(change_surplus).keypress();
  $input.keyup(change_surplus);
  $input.keydown(submit_form);
});

function _surplus($input){
  //surplus = max_length - content_length
  var text = $.trim($input.val());
  return 140 - text.length;
}

var submit_form = function(e) {
  var $form = $("#new" + $(this).prev().val());
  
  //When ctrl+enter pressed, submit the form.
  if(e.ctrlKey && e.which == "13" && _surplus($(this)) >= 0) {
    $form.submit();       
  }
}

var change_surplus = function() {
  var $input = $(this);
  var $text = $("#surplus_count" + $input.prev().val())
  var surplus = _surplus($input);

  // change number text.
  $text.text(surplus);
  
  // change color and submit-btn.
  var red = $text.hasClass("surplus-negative");
  $btn = $($input.attr("attached-btn"))
  if(red && surplus >= 0){
    $text.removeClass("surplus-negative"); 
    enable($btn);
  }
  if(!red && surplus < 0){ 
    $text.addClass("surplus-negative");
    disable($btn);
  } 
}
