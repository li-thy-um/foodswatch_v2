class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.save_with_foods foods_params
    if parent_id = params[:micropost][:comment_id] || params[:micropost][:shared_id]
      @post = Micropost.find_by_id(parent_id)
    end
    render action: params[:create_type]
  rescue => e
    logger.error e.message
    logger.error e.backtrace.join("\n")
    flash[:danger] = "发布失败，请重试。#{error_message_for @micropost}"
    render action: :create_fail
  end

  def destroy
    @micropost = current_user.microposts.find(params[:id])
    @micropost.destroy!
    render action: :destroy
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = '用户无权删除该微博'
    redirect_to root_url
  rescue ActiveRecord::RecordNotDestroyed
    flash[:danger] = '删除失败'
    redirect_to root_url
  end

  def comments
    @micropost = Micropost.find_by_id(params[:id])
    @comments = @micropost.comments.paginate(page: params[:page])
  end

  def shares
    @micropost = Micropost.find_by_id(params[:id])
    @shares = @micropost.shares.paginate(page: params[:page])
  end

  private

    def foods_params
      foods = params.permit(foods: [:prot, :fat, :carb, :name])[:foods] || []
      foods + (params[:food_ids] || []).map{|id| {id: id}}
    end

    def micropost_params
      params.require(:micropost).permit(:content, :comment_id, :original_id, :shared_id, :post_food_id)
    end
end
