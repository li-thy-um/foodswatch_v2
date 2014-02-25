class WatchesController < ApplicationController
  before_action :signed_in_user

  def create
    action = :toggle
    @container = params[:container]
    @food = Food.find(params[:watch][:food_id]) 
    current_user.watch!(@food)
    if params[:name] != nil
      @food2 = Food.create({name: params[:name]}.merge(@food.nutri_info))
      current_user.watch!(@food2)
      action = :watch_post
    end
    respond_to do |format|
      format.js { render action: action } 
    end
  end

  def destroy
    @container = params[:container]
    @food = Watch.find(params[:id]).food
    current_user.unwatch!(@food)
    respond_to do |format|
      format.js { render action: :toggle }
    end
  end
end
