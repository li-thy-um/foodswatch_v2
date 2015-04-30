class SessionsController < ApplicationController
  before_action :not_signed_in_user, only: [ :new ]

  def new
  end

  def create
    user = User.find_by(email: user_email) || User.find_by(name: user_name)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      unless user.email_confirmed?
        flash[:warning] = "用户邮箱还没有确认，请及时确认注册邮箱。没有受到确认邮件？"
        flash[:link] = { content: "重新发送确认邮件", href: send_confirm_email_path }
      end
      redirect_back_or root_path
    else
      flash[:danger] = '登录失败！请检查用户名/密码。'
      redirect_to signin_path
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
