$ ->
  $(document).on 'click', '#upload_avatar', () ->
    $('#user_avatar').click()

  $(document).on 'change', '#user_avatar', () ->
    $('#user_avatar_form').submit()
