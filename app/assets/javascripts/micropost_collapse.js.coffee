$ () ->

  # add MicropostCollapse to each micropost
  $('.micropost .panel-footer').each () ->
    $micropost = $(this).closest('.micropost')
    micropost_id = $micropost.attr('id')
    collapse = new MicropostCollapse( micropost_id )
    collapse.render $(this)
    $micropost.find('.btn-share').data('collapse', collapse)
    $micropost.find('.btn-comment').data('collapse', collapse)

  # bind event 'click'
  $(document).on 'click', '.micropost .btn-share', () ->
    collapse = $(this).data('collapse')
    collapse && collapse.act('share')

  $(document).on 'click', '.micropost .btn-comment', () ->
    collapse = $(this).data('collapse')
    collapse && collapse.act('comment')

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

  _content_for: (action, render) =>
    $.get "/collapses/#{action}/#{@_micropost_id}", (content) =>
      render(content)
