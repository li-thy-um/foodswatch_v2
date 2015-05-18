$ () ->

  # Add micropost-collapse to $micropost and bind event 'collapse'
  init_collapse = ($micropost) ->
    micropost_id = $micropost.attr('id')
    collapse = new MicropostCollapse( micropost_id )
    collapse.render $micropost.find('.panel-footer')
    $micropost.find('.btn-share').bind 'collapse', () ->
      collapse.act('share')
    $micropost.find('.btn-comment').bind 'collapse', () ->
      collapse.act('comment')

  $(document).on 'click', '.micropost .btn-share, .micropost .btn-comment', () ->
    $micropost = $(this).closest('.micropost')
    init_collapse($micropost) if $micropost.find('.micropost-collapse').length == 0
    $(this).trigger('collapse')

class MicropostCollapse
  constructor: ( micropost_id ) ->
    @_action = ''
    @_micropost_id = micropost_id
    @_dom = $("<div class='micropost-collapse'></div>").hide()

  render: ($target) =>
    $target.append(@_dom)

  act: (action) =>
    if @_action == ''
      @_content_for action, (content) =>
        @_show(content)
    else if @_action != action
      @_content_for action, (content) =>
        @_replace(content) # replace content with content of action
    else if @_action == action
      @_hide()

    if action == @_action
      @_action = ''
    else
      @_action = action

  _show: (content) =>
    @_dom.append(content)
    @_dom.slideDown()

  _replace: (content) =>
    @_dom.empty()
    @_dom.append(content)

  _hide: () =>
    @_dom.slideUp () =>
      @_dom.empty() # then remove content

  # return the content for collapse in html.
  _content_for: (action, render) =>
    $.get "/collapses/#{action}/#{@_micropost_id}", (content) =>
      render(content)
