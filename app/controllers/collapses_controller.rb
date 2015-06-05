class CollapsesController < ApplicationController
  before_action :signed_in_user

  def share
    @micropost = Micropost.find(params[:id])
    render partial: 'collapses/share', locals: {micropost: @micropost}
  rescue => e
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render json: false
  end

  def comment
    @micropost = Micropost.find(params[:id])
    render partial: 'collapses/comment', locals: {micropost: @micropost}
  rescue => e
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render json: false
  end

end
