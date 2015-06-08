class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @user = current_user
      @micropost = @user.microposts.build
    end
  end
end
