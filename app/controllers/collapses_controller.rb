class CollapsesController < ApplicationController
  before_action :signed_in_user

  def share
    @micropost = Micropost.find_by_id(params[:id])
    render partial: 'shared/collapses/share', locals: {micropost: @micropost}
  end

  def comment
    @micropost = Micropost.find_by_id(params[:id])
    render partial: 'shared/collapses/comment', locals: {micropost: @micropost}
  end

end
