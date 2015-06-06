MicropostList = React.createClass

  render: ->
    microposts = this.props.data

    micropostNodes = this.props.data.map (micropost) ->
      `<Micropost data={micropost} key={micropost.id} />`

    `<div className="micropostList">
      {micropostNodes}
    </div>`


MicropostActionPanel = React.createClass

  render: ->
    micropost = this.props.data
    action_panel_class_name = "post_action_panel_#{micropost.id}"
    delete_button = `<DeleteButton data={micropost} />` if $('body').data('user') == micropost.user.id

    `<div className='panel-footer'>
      <div className='post-action'>
        <div className={action_panel_class_name}>
          {delete_button}
          <ShareButton data={micropost}/>
          <CommentButton data={micropost}/>
          <LikeButton data={micropost}/>
        </div>
      </div>
    </div>`

DeleteButton = React.createClass

  render: ->
    micropost = this.props.data
    href = "/microposts/#{micropost.id}"

    `<a className='btn btn-action btn-danger btn-delete'
      data-confirm='确定删除?'
      data-remote='true' rel='nofollow' data-method='delete'
      href={href}>

      删除
    </a>`

ShareButton = React.createClass

  render: ->
    micropost = this.props.data

    `<a className='btn btn-share btn-action btn-success'>
      <span>
        分享 {micropost.count.share}
      </span>
    </a>`

CommentButton = React.createClass

  render: ->
    micropost = this.props.data

    ` <a className='btn btn-comment btn-action btn-primary'>
      <span>
        评论 {micropost.count.comment}
      </span>
    </a>`

LikeButton = React.createClass

  render: ->
    micropost = this.props.data
    className = 'btn btn-like btn-default'
    if micropost.is_liking
      className += ' btn-liked'
      method = 'delete'
      href = "/likes/#{micropost.like_id}"
    else
      method = 'post'
      href = "/likes?like[micropost_id]=#{micropost.id}"

    `<a className={className} data-remote='true'
      rel='nofollow' data-method={method}
      href={href}>
      <span>
        <i className='fa fa-thumbs-o-up'></i> {micropost.count.like}
      </span>
    </a>`

MicropostFoodsPanel = React.createClass

  render: ->
    foods = this.props.data

    foodNodes = foods.map (food, i) ->
      `<FoodTag data={food} key={i}/>`

    `<div className="panel-body">
      {foodNodes}
    </div>`

FoodTag = React.createClass

  render: ->
    food = this.props.data

    `<a className="food-tag" data-id={food.id}>
      <i className="fa fa-cutlery"></i>
      {food.name}
    </a>`

Micropost = React.createClass

  render: ->
    micropost = this.props.data
    page = this.props.page

    original_post = `
      <div className="panel-body">
        <Micropost data={micropost.original_post} page="share"/>
      </div>` if micropost.original_post

    foods_panel = `
      <MicropostFoodsPanel data={micropost.foods} />` if micropost.foods.length > 0

    action_panel = `
      <MicropostActionPanel data={micropost} />
    ` if page != "share"

    `<div className='panel panel-default micropost' id={micropost.id}>
      <div className='panel-body'>
        <div className='row-fluid'>
          <div className='media'>
            <div className='media-left' dangerouslySetInnerHTML={{__html: micropost.user.avatar}} />
            <div className='media-body'>
              <span className='media-heading media-body' dangerouslySetInnerHTML={{__html: micropost.user.link}}/>
              <br/>
              <span className='content' dangerouslySetInnerHTML={{__html: micropost.content}} />
              {foods_panel}
              {original_post}
              <div className='timestamp'>
                <span> {micropost.timestamp} </span>
              </div>
            </div>
          </div>
        </div>
      </div>
      {action_panel}
    </div>`

class User
  constructor: (id) ->
    @id = id

  get: (option) =>
    $.get "/api/v1/users/#{@id}/#{option.action}?page=#{option.page}&query=#{option.query}", (res) =>
      option.success(res)

$(document).on "ready page:load", ->
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
      React.render(`<MicropostList data={res.data}/>`, $dom[0])
