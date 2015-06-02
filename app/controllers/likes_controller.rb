class LikesController < ApplicationController
  before_action :signed_in_user

  def create
    @like = current_user.likes.create!(params.require(:like).permit(:micropost_id))
  rescue
    render action: :error
  end

  def destroy
    @like = Like.find(params[:id]).destroy!
  rescue
    render action: :error
  end
end
