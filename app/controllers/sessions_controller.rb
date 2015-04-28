class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: user_email) || User.find_by(name: user_name)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or root_path
    else
      flash.now[:error] = '登录失败！请检查用户名/密码。'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

    def user_email
      params[:session][:email].downcase
    end

    def user_name
      params[:session][:email]
    end
end
