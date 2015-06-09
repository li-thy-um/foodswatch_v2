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

    `<a className='btn btn-comment btn-action btn-primary'>
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
      <span className='label label-warning'>
        <i className="fa fa-cutlery"> {food.name}</i>
      </span>
    </a>`

Micropost = React.createClass

  render: ->
    micropost = this.props.data
    page = this.props.page
    dom_id = if page == 'share' then "share_#{micropost.id}" else micropost.id

    if page == 'share' && micropost == 'deleted'
      return  `<div className='panel panel-default micropost' id={dom_id}>
                  <div className='panel-body'>
                    <span className='content'>
                      原微博已删除
                    </span>
                  </div>
                  <div className='panel-body'></div>
                </div>`

    original_post = `
      <div className="panel-body">
        <Micropost data={micropost.original_post} page="share"/>
      </div>` if micropost.original_post

    foods_panel = `
      <MicropostFoodsPanel data={micropost.foods} />` if micropost.foods.length > 0

    action_panel = `
      <MicropostActionPanel data={micropost} />` if page != "share"

    `<div className='panel panel-default micropost' id={dom_id}>
      <div className='panel-body'>
        <div className='row-fluid'>
          <div className='media'>
            <div className='media-left'>
              <UserAvatar user={micropost.user} size="55" />
            </div>
            <div className='media-body'>
              <span className='media-heading media-body'>
                <UserLink user={micropost.user} />
              </span>
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

UserAvatar = React.createClass

  render: ->
    user = @props.user
    size = @props.size
    url = "#{user.avatar_url}?s=55"
    `<img alt={user.name} className="gravatar" height={size} width={size} src={url} />`

UserLink = React.createClass

  render: ->
    user_id = @props.user.id
    user_name = @props.user.name
    url = "/users/#{user_id}"
    `<a href={url}>@{user_name}</a>`

MorePostsButton = React.createClass

  render: ->
    `<button className='btn btn-default btn-block' onClick={this.props.handleClick}>
      <i className="fa fa-angle-double-down"> 显示下一页 </i>
    </button>`

LoadingPanel = React.createClass

  render: ->
    `<div className='panel panel-default'>
      <div className='panel-body center'>
        <i className="fa fa-spinner fa-pulse fa-3x"></i>
      </div>
    </div>`

MicropostList = React.createClass

  render: ->
    micropostNodes = @state.data.map (micropost) ->
      `<Micropost data={micropost} key={micropost.id} />`

    appendix = if @state.loading
      `<LoadingPanel />`
    else if @state.hasMorePosts
      `<MorePostsButton handleClick={this.onClickMorePostButton}/>`

    `<div className="micropostList">
      {micropostNodes}
      {appendix}
    </div>`

  onClickMorePostButton: ->
    page = @state.page + 1
    @setState {page: page, loading: true}, ->
      @fetchData()

  fetchData: ->
    url = "/api/v1/users/#{@state.user}/#{@state.action}?page=#{@state.page}&query=#{@state.query}"
    $.get url, (res) =>
      data = @state.data.concat res.data.microposts
      @setState {data : data, loading: false, hasMorePosts: res.data.hasMorePosts}

  getInitialState: ->
    data: []
    user: @props.user
    query: @props.query
    action: @props.action
    page: 1
    loading: true
    hasMorePosts: true

  componentDidMount: ->
    @fetchData()

$(document).on "ready page:load", ->
  if ($dom = $(".microposts")).length > 0
    user = $dom.data('user')
    page = $dom.data('page')
    query = $dom.data('query')
    action = $dom.data('action')
    React.render(`<MicropostList user={user} query={query} action={action} />`, $dom[0])
