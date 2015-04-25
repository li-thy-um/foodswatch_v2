class SearchController < ApplicationController

  def micropost
    @microposts = Micropost.where("content like :query", query: query).paginate(page: params[:page])
  end

  def user
    @users =  User.where("name like :query", query: query).paginate(page: params[:page])
  end

  def food
    @foods = Food.where("name like :query", query: query).paginate(page: params[:page])
  end

  private

    def query
      "%#{params[:search][:query]}%"
    end

end
