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
      view_context.has_more_page?(@microposts)
    end

    def json_of_microposts
      # cache the likes of current_user to reduce db query.
      if current_user
        micropost_ids = @microposts.map(&:id)
        @likes_of_current_user = current_user.likes.where(micropost_id: micropost_ids)
      end

      #cache original_posts
      @original_posts = @microposts.map(&:original_post).compact!.uniq!(&:id)

      # cache the foods info of the micropost
      micropost_has_foods_ids = (@microposts + @original_posts).select(&:has_foods).map(&:id)
      pf_relationships = PostFoodRelationship.where(post_id: micropost_has_foods_ids)
      @post_id_hash_pf_relationship = pf_relationships.group_by(&:post_id)
      @food_id_hash_food = Food.where(id: pf_relationships.map(&:food_id).uniq!).group_by(&:id)

      @microposts.map { |m| json_of m }
    end

    def basic_json_of(micropost)
      {
        id: micropost.id,
        content: view_context.wrap(micropost.content),
        user: {
          id: (user = micropost.user).id,
          name: user.name,
          avatar_url: view_context.avatar_url(user)
        },
        foods: (micropost.has_foods ? foods_json_of(micropost) : []),
        timestamp: view_context.timestamp_for(micropost),
      }
    end

    def json_of(micropost)
      basic_json_of(micropost).merge!(
        {
          original_post: (original_post_json_of(micropost) if micropost.original_id),
          count: {
            like: micropost.likes.size,
            share: micropost.share_count,
            comment: micropost.comments.size
          },
          like_id: (like = like_of(micropost.id)) && like.id,
          is_liking: !like.nil?
        }
      )
    end

    def foods_json_of(micropost)
      @post_id_hash_pf_relationship[micropost.id].map do |pf_relationship|
        food = @food_id_hash_food[pf_relationship.food_id].first
        {
          id: food.id,
          name: food.name
        }
      end
    end

    def original_post_json_of(micropost)
      if original_post = @original_posts.select { |m| m.id == micropost.original_id }.first
        basic_json_of(original_post)
      else
        :deleted
      end
    end

    def like_of(micropost_id)
      return nil unless @likes_of_current_user
      @likes_of_current_user.select { |like| like.micropost_id == micropost_id }.first
    end

    def prepare_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_error '没有此用户'
    end
end
