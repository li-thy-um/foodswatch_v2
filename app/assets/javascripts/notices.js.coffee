$ () ->
  refresh_notice = () ->
    $.get '/notices/count.js' if $('#notice').length > 0

  setInterval refresh_notice, 5 * 1000

  $('.notices .notice .action a').each () ->
    $(this).click()
