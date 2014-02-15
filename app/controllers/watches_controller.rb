class WatchesController < ApplicationController
  before_action :signed_in_user

  def create
    @food = Food.create( Food.post_food(params[:post_id]).nutri_info,
                         name: params[:name] ) 
    current_user.watch!(@food)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @food = Watch.find(params[:id]).food
    current_user.unwatch!(@food)
    respond_to do |format|
      format.js
    end
  end

  private
end
