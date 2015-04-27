class WatchesController < ApplicationController
  before_action :signed_in_user

  def create
    @watch = current_user.watches.build(params.require(:watch).permit(:food_id))
    if @watch.save
      @food = @watch.food
      render action: :create
    else
      render action: :error
    end
  end

  def destroy
    @watch = Watch.find(params[:id])
    @food = @watch.food
    if @watch.destroy
      render action: :destroy
    else
      render action: :error
    end
  end

end
