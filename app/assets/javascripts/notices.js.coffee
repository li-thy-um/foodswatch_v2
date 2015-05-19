$ () ->
  refresh_notice = () ->
    $.get '/notices/count.js'

  setInterval refresh_notice, 2 * 1000

  # add input of read notice ids ( notices of this page) into a hidden form.
  # subbmit the form

  $('.notices .notice .action a').each () ->
    $(this).click()
