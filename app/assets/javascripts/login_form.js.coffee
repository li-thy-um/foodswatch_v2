$ () ->
  $(document).on 'click', '#forget_password', ->
    $form = $('#sign_in_form')
    original_action = $form.attr('action')
    $form.attr('action', '/passwords').submit();
    $form.attr('action', original_action)
