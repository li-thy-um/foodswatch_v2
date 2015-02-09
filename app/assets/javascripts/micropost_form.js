$(init_post_form);

function init_post_form(){
  $("body").delegate('.letter_count', 'keypress', change_surplus);
  $("body").delegate('.letter_count', 'keyup',    change_surplus);
  $("body").delegate('.letter_count', 'keydown',  submit_form);
}

function _surplus($input){
  //surplus = max_length - content_length
  var text = $.trim($input.val());
  if (text.length == 0){
    return "";
  }else{
    return 140 - text.length;
  }
}

function clear_form($textarea){
  $textarea.val("");
  $textarea.keypress();
  if ($textarea.attr("id") == "new_post_textarea"){
      $("#food_form").html("");
      $("#choosed").html("");
  }
  var $collapse = $textarea.parent().parent();
  var $surplus = $collapse.next();
  if (!$surplus.hasClass("hidden")
      && $textarea.attr("id").split("_")[0] == "share")
  {
    $collapse.collapse('hide');
    $surplus.addClass('hidden');
  }
}

var submit_form = function(e) {
  var $attached_btn = $($(this).attr("attached-btn"));

  //When ctrl+enter pressed, submit the form.
  if(e.ctrlKey && e.which == "13" && _surplus($(this)) >= 0) {
    $attached_btn.click();
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
