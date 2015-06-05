class Api::V1::UsersController < Api::V1::ApplicationApiController

  before_action :prepare_user, only: [:feeds, :microposts]

  def feeds
    microposts = @user.feed.paginate(page: params[:page]).map do |micropost|
      json_of micropost
    end
    render_json microposts
  end

  def microposts
    microposts = @user.microposts.normal.paginate(page: params[:page]).map do |micropost|
      json_of micropost
    end
    render_json microposts
  end

  private

    def json_of(micropost)
      {
        id: micropost.id,
        content: view_context.wrap(micropost.content),
        original_post: if original_post = micropost.original_post
          json_of(original_post)
        end,
        count: {
          like: micropost.likes.count,
          share: micropost.shares.count,
          comment: micropost.comments.count
        },
        user: {
          id: (user = micropost.user).id,
          link: view_context.user_link(user),
          avatar: view_context.gravatar_for(user, size: 55)
        },
        foods: micropost.foods.map do |food|
          {
            id: food.id,
            name: view_context.strip_tags(food.name)
          }
        end,
        timestamp: view_context.timestamp_for(micropost),
        is_liking: (cuser = current_user) && (like = cuser.liking?(micropost)),
        like_id: cuser && like && like.id
      }
    end

    def prepare_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_error '没有此用户'
    end
end
