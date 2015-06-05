class SearchController < ApplicationController

  def micropost
    @microposts = Micropost.normal.where("content like :query", query: query).paginate(page: params[:page])
    @search_type = :micropost
    @page = params[:page]
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
