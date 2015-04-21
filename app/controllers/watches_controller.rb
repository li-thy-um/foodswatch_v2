class WatchesController < ApplicationController
  before_action :signed_in_user

  def create
    @container = params[:container]
    @food = Food.find(params[:watch][:food_id])
    render action: if params[:name] == nil
      current_user.watch!(@food)
      :toggle
    elsif params[:name] == ''
      :watch_post_fail
    else
      @food2 = Food.create({name: params[:name]}.merge(@food.nutri_info))
      current_user.watch!(@food2)
      :watch_post
    end
  end

  def destroy
    @container = params[:container]
    @food = Watch.find(params[:id]).food
    current_user.unwatch!(@food)
    render action: :toggle if @container
  end
end
