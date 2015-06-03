selector = '#new_post_textarea, .comment-text-area, .share-text-area'
$(document).on 'keydown', selector, (e) ->
  # When ctrl+enter pressed, submit the form.
  if e.ctrlKey && e.which == 13
    $(this).closest('form').submit()
