$(init_post_form);

function init_post_form(){
  $("body").on('keydown',  '#new_post_textarea', submit_form);
}

var submit_form = function(e) {
  //When ctrl+enter pressed, submit the form.
  if(e.ctrlKey && e.which == "13") {
    $("#new_post_form").submit();
  }
}
