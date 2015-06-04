class LikesController < ApplicationController
  before_action :signed_in_user

  def create
    @like = current_user.like! params[:like][:micropost_id]
  rescue => e
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render action: :error
  end

  def destroy
    @like = current_user.cancel_like! params[:id]
  rescue
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render action: :error
  end
end
