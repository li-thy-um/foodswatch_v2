class Api::V1::MicropostsController < Api::V1::ApplicationApiController

  before_action :authorize_user

  def create
    micropost = @user.microposts.build micropost_params
    micropost.save_with_foods foods_params
    render_json id: micropost.id
  end

  def destroy
    @user.microposts.find(params[:id]).destroy!
    render_success
  rescue ActiveRecord::RecordNotFound
    render_error '用户无权删除该微博'
  rescue ActiveRecord::RecordNotDestroyed
    render_error '删除失败'
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def foods_params
      params.permit(foods: [:id, :prot, :fat, :carb, :name])[:foods]
    end
end
