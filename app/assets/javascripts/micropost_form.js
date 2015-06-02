$(init_post_form);

var init_post_form = function() {
  var selector = '#new_post_textarea, .comment-text-area, .share-text-area'
  $(document).on('keydown', selector, submit_form);
};

var submit_form = function(e) {
  //When ctrl+enter pressed, submit the form.
  if(e.ctrlKey && e.which == "13") {
    $(this).closest('form').submit();
  }
};
