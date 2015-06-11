refresh_notice = () ->
  $.get '/notices/count.js' if $('#notice').length > 0

setInterval refresh_notice, 300 * 1000
