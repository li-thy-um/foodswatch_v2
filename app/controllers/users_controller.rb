class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :show, :edit, :update, :destroy, :following, :followers, :send_confirm_email]
  before_action :not_signed_in_user, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :email_not_confirmed, only: :send_confirm_email

  def calorie
    @user = User.find(params[:id])
    @title = "#{@user.name}的统计信息"
  end

  def watches
    @user = User.find(params[:id])
    @title = "#{@user.name}的食物"
    @foods = @user.watched_foods.paginate(page: params[:page])
    render 'watch_list'
  end

  def following
    @title = '关注'
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = '粉丝'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def index
    @users = User.order(created_at: :desc).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @title =  @user.name
    @microposts = @user.microposts.where('comment_id is NULL').paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def destroy
    user = User.find(params[:id])
    if user.admin && current_user?(user)
      flash[:danger] = '管理员不能删除自己啦！'
      redirect_back_or(user)
    else
      user.destroy
      flash[:success] = '此人已死，有事烧纸！'
      redirect_to users_url
    end
  end

  def send_confirm_email
    UserMailer.welcome_email(current_user).deliver_later
    flash[:success] = "确认邮件已发送，请及时确认注册邮箱。没有收到确认邮件？"
    flash[:link] = { content: "重新发送确认邮件", href: send_confirm_email_path }
    redirect_to root_path
  end

  def confirm_email
    @user = User.find(params[:id])
    @user && @user.confirm_email(params[:token])
    if current_user?(@user)
      flash[:success] = "邮箱 #{@user.email} 已确认。"
    else
      flash[:success] = "邮箱 #{@user.email} 已确认，请登陆。"
    end
    redirect_to signin_path
  rescue RuntimeError => e
    if current_user?(@user)
      flash[:danger] = "邮箱确认失败，请重试。"
      flash[:link] = { content: "重新发送确认邮件", href: send_confirm_email_path }
    else
      flash[:danger] = "邮箱确认失败，请重试。"
    end
    redirect_to root_path
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      UserMailer.welcome_email(@user).deliver_later
      flash[:success] = "注册成功，请及时确认注册邮箱。没有受到确认邮件？"
      flash[:link] = { content: "重新发送确认邮件", href: send_confirm_email_path }
      redirect_to @user
    else
      flash[:danger] = "注册失败，请重试。#{error_message_for @user}"
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = '用户信息已更新！'
      redirect_to @user
    else
      flash[:danger] = "用户信息修改失败。#{error_message_for @user}"
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    # Before filters

    def email_not_confirmed
      redirect_to(root_path) if current_user.email_confirmed?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
