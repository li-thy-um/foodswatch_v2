class ModalsController < ApplicationController
  before_action :signed_in_user

  def share
    @micropost = Micropost.find_by_id(params[:id])
    render partial: 'shared/modals/share'
  end

  def food
    @food = Food.find_by_id(params[:id])
    render partial: 'shared/modals/food'
  end

end
