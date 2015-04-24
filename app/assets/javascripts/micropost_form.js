$(init_post_form);

function init_post_form(){
  $("body").on('keydown',  '.letter_count', submit_form);
}

var submit_form = function(e) {
  var $attached_btn = $($(this).attr("attached-btn"));

  //When ctrl+enter pressed, submit the form.
  if(e.ctrlKey && e.which == "13" && _surplus($(this)) >= 0) {
    $attached_btn.click();
  }
}
