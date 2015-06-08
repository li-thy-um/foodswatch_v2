class SearchController < ApplicationController

  def micropost
    @search_type = :micropost
    @query = params[:search][:query]
    @user = current_user
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
