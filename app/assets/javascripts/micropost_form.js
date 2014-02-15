$(function(){
  var $input = $(".letter_count");
  $input.keypress(change_surplus).keypress();
  $input.keyup(change_surplus);
  $input.keydown(submit_form);
  $input.tooltip({
    placement: "top",
    title:     "[Ctrl+Enter] To Post.",
    trigger:   "click"
  });

  // Share modal
  $(".btn-submit").click(function(){
    var form_id = $(this).attr("form-id");
    $("#"+form_id).submit();
  })
});

var submit_form = function(e) {
  var $form = $("#new" + $(this).prev().val());
  //When ctrl+enter pressed, submit the form.
  if(e.ctrlKey && e.which == "13") {
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
  
  // change color and submit-btn.
  var red = $text.hasClass("surplus-negative");
  $btn = $($input.attr("attached-btn"))
  if(red && surplus > 0){
    $text.removeClass("surplus-negative"); 
    enable($btn);
  }
  if(!red && surplus <= 0){ 
    $text.addClass("surplus-negative");
    disable($btn);
  } 
}
