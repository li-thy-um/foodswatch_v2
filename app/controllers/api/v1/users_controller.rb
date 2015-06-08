class Api::V1::UsersController < Api::V1::ApplicationApiController

  before_action :prepare_user, only: [:feeds, :microposts]

  def search
    @microposts = Micropost.normal.where("content like :query", query: query).paginate(page: params[:page])
    render_json microposts: json_of_microposts, hasMorePosts: has_more_page?
  end

  def feeds
    @microposts = @user.feed.paginate(page: params[:page])
    render_json microposts: json_of_microposts, hasMorePosts: has_more_page?
  end

  def microposts
    @microposts = @user.microposts.normal.paginate(page: params[:page])
    render_json microposts: json_of_microposts, hasMorePosts: has_more_page?
  end

  private

    def query
      "%#{params[:query]}%"
    end

    def has_more_page?
      view_context.has_more_page?(@microposts, params[:page].to_i)
    end

    def json_of_microposts
      @microposts.map { |m| json_of m }
    end

    def json_of(micropost)
      {
        id: micropost.id,
        content: view_context.wrap(micropost.content),
        original_post: if micropost.original_id
          if original_post = micropost.original_post
            json_of(original_post)
          else
            :deleted
          end
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
        is_liking: (cuser = current_user) && !(like = cuser.liking?(micropost)).nil?,
        like_id: cuser && like && like.id
      }
    end

    def prepare_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_error '没有此用户'
    end
end
