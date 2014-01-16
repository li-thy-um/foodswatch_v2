$(function(){
  var $input = $(".letter_count");
  $input.keypress(change_surplus).keypress();
  $input.keyup(change_surplus);
  $input.keydown(submit_form);
  $input.tooltip({
    placement: "bottom",
    title:     "[ctrl+enter] to post.",
    trigger:   "focus"
  });
});

var submit_form= function(e) {
  var $form = $("#new" + $(this).prev().val());
  //When enter pressed, submit the form.
  if(e.ctrlKey && e.which == "13"){
    $form.submit();       
  }
}

var change_surplus = function() {
  var $input = $(this);
  var surplus = 140 - $input.val().length;
    //surplus = max_length - content_length
  var $text = $("#surplus_count" + $input.prev().val())
  
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
