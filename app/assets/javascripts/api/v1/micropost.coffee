# This is for render the Micropost panel by front-end

class User
  constructor: (id) ->
    @id = id

  get: (option) =>
    $.get "/api/v1/users/#{@id}/#{option.action}?page=#{option.page}&query=#{option.query}", (res) =>
      option.success(res)

class Micropost
  constructor: (micropost, page) ->
    @page = page
    @micropsot = micropost
    dom_id = if @page == "share" then "share_#{micropost.id}" else micropost.id
    @dom = "
      <div class='panel panel-default micropost' id='#{dom_id}'>
        <div class='panel-body'>
          <div class='row-fluid'>
            <div class='media'>
              <div class='media-left'>
                #{micropost.user.avatar}
              </div>
              <div class='media-body'>
                <span class='media-heading media-body'>
                  #{micropost.user.link}
                </span>
                <br>
                <span class='content'>
                  #{micropost.content}
                <span>
                #{@foods_panel(micropost.foods)}
                #{@original_post(micropost.original_post)}
                <div class='timestamp'>
                  <span>
                    #{micropost.timestamp}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
        #{@action_panel(micropost)}
      </div>
    "
    @$dom = $(@dom).hide()

  btn_comment: (micropost) =>
    "
      <a class='btn btn-comment btn-action btn-primary'>
        <span>
          评论 #{micropost.count.comment}
        </span>
      </a>
    "

  btn_share: (micropost) =>
    "
      <a class='btn btn-share btn-action btn-success'>
        <span>
          分享 #{micropost.count.share}
        </span>
      </a>
    "

  btn_like: (micropost) =>
    if micropost.is_liking
      "
        <a class='btn btn-like btn-liked btn-default' data-remote='true'
          rel='nofollow' data-method='delete'
          href='/likes/#{micropost.like_id}'>

          <i class='fa fa-thumbs-o-up'>
            #{micropost.count.like}
          </i>
        </a>
      "
    else
      "
        <a class='btn btn-like btn-default' data-remote='true'
          rel='nofollow' data-method='post'
          href='/likes?like[micropost_id]=#{micropost.id}'>

          <i class='fa fa-thumbs-o-up'>
            #{micropost.count.like}
          </i>
        </a>
      "

  btn_delete: (micropost) =>
    return "" unless $('body').data('user') == micropost.user.id
    "
      <a class='btn btn-action btn-danger btn-delete'
        data-confirm='确定删除?'
        data-remote='true' rel='nofollow' data-method='delete'
        href='/microposts/#{micropost.id}'>

        删除
      </a>
    "

  action_panel: (micropost) =>
    if @page == 'share' then return ""
    "
      <div class='panel-footer'>
        <div class='post-action'>
          <div class='post_action_panel_#{micropost.id}'>
            #{@btn_delete(micropost)}
            #{@btn_share(micropost)}
            #{@btn_comment(micropost)}
            #{@btn_like(micropost)}
          </div>
        </div>
      </div>
    "

  foods_panel: (foods) =>
    return "" if foods.length == 0
    html = "<div class='panel-body'>"
    foods.forEach (food) ->
      html += "
        <a class='food-tag' data-id='#{food.id}'>
          <i class='fa fa-cutlery'></i>
          #{food.name}
        </a>
      "
    html += "</div>"
    html

  original_post: (post) =>
    return "" unless post
    "
      <div class='panel-body'>
        #{new Micropost(post, 'share').dom}
      </div>
    "

$(document).on "ready page:load", () ->
    if ($dom = $("[data-action='feeds']")).length > 0
      render_microposts($dom, "feeds")

    if ($dom = $("[data-action='search']")).length > 0
      render_microposts($dom, "search")

    if ($dom = $("[data-action='microposts']")).length > 0
      render_microposts($dom)

render_microposts = ($dom, action) ->
  page = $dom.data('page') || 1
  new User($dom.data('user')).get
    action: action || "microposts"
    query: if action == "search" then $dom.data("query") else ""
    page: page
    success: (res) ->
      $dom.empty()
      res.data.forEach (data) ->
        micropost = new Micropost(data)
        $dom.append(micropost.$dom.fadeIn())
