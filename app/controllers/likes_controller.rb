class LikesController < ApplicationController
  before_action :signed_in_user

  def create
    @like = current_user.likes.build(params.require(:like).permit(:micropost_id))
    if @like.save
      render action: :create
    else
      render action: :error
    end
  end

  def destroy
    @like = Like.find(params[:id])
    if @like.destroy
      render action: :destroy
    else
      render action: :error
    end
  end
end
