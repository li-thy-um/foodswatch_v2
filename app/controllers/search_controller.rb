class SearchController < ApplicationController

  def micropost
    @microposts = Micropost.where(comment_id: nil).where("content like :query", query: query).paginate(page: params[:page])
    @search_type = :micropost
  end

  def user
    @users =  User.where("name like :query", query: query).order("created_at DESC").paginate(page: params[:page])
    @search_type = :user
  end

  def food
    @foods = Food.where("name like :query", query: query).paginate(page: params[:page])
    @search_type = :food
  end

  private

    def query
      "%#{params[:search][:query]}%"
    end

end
