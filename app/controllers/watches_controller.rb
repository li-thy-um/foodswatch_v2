class WatchesController < ApplicationController
  before_action :signed_in_user

  def create
    @watch = current_user.watches.build(params.require(:watch).permit(:food_id))
    if @watch.save
      render action: :create
    else
      render action: :error
    end
    # render action: if params[:name] == nil
    #   current_user.watch!(@food)
    #   :toggle
    # elsif params[:name] == ''
    #   :watch_post_fail
    # else
    #   @food2 = Food.create({name: params[:name]}.merge(@food.nutri_info))
    #   current_user.watch!(@food2)
    #   :watch_post
    # end
  end

  def destroy
    @watch = Watch.find(params[:id])
    if @watch.destroy
      render action: :destroy
    else
      render action: :error
    end
  end

end
