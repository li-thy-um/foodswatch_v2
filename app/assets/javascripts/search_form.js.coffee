$ () ->
  $(document).on 'click', 'div.search .dropdown-menu>li>a', ->
    $select = $(this)
    text = $select.html()
    type = $select.data 'type'
    $('div.search .dropdown-toggle>span:first').html(text)
    $('div.search form').attr('action', "/search/#{type}")

  $(document).on 'click', 'div.search .btn-search', ->
    $('div.search form').submit()
