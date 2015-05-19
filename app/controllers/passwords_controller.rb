class PasswordsController < ApplicationController
  before_action :validate_time, only: [:show]
  before_action :validate_token, only: [:show]
  before_action :validate_email, only: [:create]

  # 给邮箱地址发邮件找回密码
  def create
    @user.update_change_password_token
    UserMailer.change_password_email(@user).deliver_later
    flash[:success] = "密码重置邮件已发送，请登陆 #{@email} 查收。"
    redirect_to signin_path
  end

  # 登陆并跳转到修改用户信息页面
  def show
    @user.clear_change_password_token
    sign_in @user
    flash[:success] = "登陆成功，请及时修改密码。"
    redirect_to edit_user_path(@user)
  end

  private

    def validate_email
      @email = params[:session][:email]
      unless @user = User.find_by(email: @email)
        flash[:danger] = "对不起，这个电子邮件地址没有被注册。"
        redirect_to signin_path
      end
    end

    def validate_token
      @user = User.find_by(email: params[:email])
      if @user.nil? || @user.change_password_token.nil? || @user.change_password_token !=  params[:id]
        flash[:danger] = "修改密码请求非法，请重新申请求改密码。"
        redirect_to signin_path
      end
    end

    def validate_time
      @user = User.find_by(email: params[:email])
      if @user.nil? || @user.change_password_at.nil? ||  Time.zone.now > @user.change_password_at + 1.hour
        flash[:danger] = "修改密码请求已超时，请重新申请求改密码。"
        redirect_to signin_path
      end
    end
end
