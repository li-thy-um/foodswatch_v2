class UsersController < ApplicationController

  before_action :signed_in_user, only: [:remove_avatar, :avatar, :index, :show, :edit, :update, :destroy, :following, :followers, :send_confirm_email]
  before_action :not_signed_in_user, only: [:new, :create]
  before_action :prepare_user, only:[:remove_avatar, :avatar, :send_confirm_email, :confirm_email, :edit, :update, :destroy, :show, :calorie, :foods, :following, :followers]
  before_action :correct_user, only: [:remove_avatar, :avatar, :edit, :update]
  before_action :admin_user, only: :destroy
  before_action :email_not_confirmed, only: [:send_confirm_email, :confirm_email]
  before_action :verify_confirm_token, only: :confirm_email

  def calorie
    respond_to do |format|
      format.html
      format.json { render json: @user.chart_string_of_day(10) }
    end
  end

  def foods
    @foods = @user.watched_foods.paginate(page: params[:page])
  end

  def following
    @title = '关注'
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = '粉丝'
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def index
    @users = User.order(created_at: :desc).paginate(page: params[:page])
  end

  def show
    @title =  @user.name
    @microposts = @user.microposts.where('comment_id is NULL').paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def destroy
    if @user.admin && current_user?(@user)
      flash[:danger] = '管理员不能删除自己啦！'
      redirect_back_or(@user)
    else
      @user.destroy
      flash[:success] = '此人已死，有事烧纸！'
      redirect_to users_url
    end
  end

  def send_confirm_email
    @user.update_email_confirmation_token
    UserMailer.welcome_email(@user).deliver_later
    flash[:success] = "确认邮件已发送，请及时确认注册邮箱。没有收到确认邮件？"
    flash[:link] = { content: "重新发送确认邮件", href: send_confirm_email_user_path(@user) }
    redirect_to root_url
  end

  def confirm_email
    @user.confirm_email
    if current_user?(@user)
      flash[:success] = "邮箱 #{@user.email} 已确认。"
    else
      flash[:success] = "邮箱 #{@user.email} 已确认，请登陆。"
    end
    redirect_to signin_path
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      @user.update_email_confirmation_token
      flash[:success] = "注册成功，请及时确认注册邮箱。没有收到确认邮件？"
      flash[:link] = { content: "重新发送确认邮件", href: send_confirm_email_user_path(@user) }
      UserMailer.welcome_email(@user).deliver_later
      redirect_to @user
    else
      flash[:danger] = "注册失败，请重试。#{error_message_for @user}"
      redirect_to root_path
    end
  end

  def edit; ;end

  def remove_avatar
    @user.remove_avatar!
    flash[:success] = "已改为Gravatar头像。"
    redirect_to edit_user_path(@user)
  end

  def avatar
    @user.upload_avatar params[:user][:avatar]
    flash[:success] = "头像已修改。"
    redirect_to edit_user_path(@user)
  rescue => e
    logger.debug e.inspect
    flash[:danger] = "上传失败。"
    redirect_to edit_user_path(@user)
  end

  def update
    @user.update!(update_params)
    flash[:success] = '用户信息已更新！'
    redirect_to edit_user_path(@user)
  rescue => e
    logger.debug e.inspect
    flash[:danger] = "用户信息修改失败。#{error_message_for @user}"
    redirect_to edit_user_path(@user)
  end

  private

    def update_params
      params.require(:user).permit(:name, :password)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    # Before filters
    def prepare_user
      @user = User.find_by_id(params[:id])
    end

    def verify_confirm_token
      return if @user && @user.email_confirmation_token == params[:token]
      if current_user?(@user)
        flash[:danger] = "邮箱确认失败，请重试。"
        flash[:link] = { content: "重新发送确认邮件", href: send_confirm_email_user_path(@user) }
      else
        flash[:danger] = "邮箱确认失败，请重试。"
      end
      redirect_to root_path
    end

    def email_not_confirmed
      redirect_to(root_path) if @user.email_confirmed?
    end

    def correct_user
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
