$(init_post_form);

function init_post_form(){
  $(document).on('keydown', '#new_post_textarea, .comment-text-area, .share-text-area', submit_form);
}

var submit_form = function(e) {
  //When ctrl+enter pressed, submit the form.
  if(e.ctrlKey && e.which == "13") {
    $(this).closest('form').submit();
  }
}
