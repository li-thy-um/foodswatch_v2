class FoodsController < ApplicationController
  before_action :signed_in_user

  def query
    foods = current_user.watched_foods.where("name like ?", "%#{params[:query]}%")
    text = foods.map { |f| "#{f.id}_#{f.name}" }.join(",")
    puts text
    render :text => text
  end

end
